import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:nfc/features/home/data/data_source/data_source_interface.dart';
import 'package:nfc/features/home/data/models/user.dart';
import 'package:nfc/features/home/domain/entities/operation_type_enum.dart';

class NfcDataSourceImpl implements UserDataSourceInterface {
  NfcDataSourceImpl();

  @override
  Future<void> createUser(UserModel user) {
    return writeNfcData(user.toJson());
  }

  @override
  Future<void> deleteUser(String id) {
    // Persist an intent to delete the user with matching id.
    // Actual low-level NDEF write is not implemented here (see writeNfcData).
    return writeNfcData({'id': id, 'delete': true});
  }

  @override
  Future<UserModel> getUser() async {
    final String raw = await getNfcData();
    try {
      final Map<String, dynamic> jsonMap =
          jsonDecode(raw) as Map<String, dynamic>;
      return UserModel.fromJson(jsonMap);
    } on FormatException {
      // Fallback: construct a minimal valid structure so the app can proceed gracefully
      final Map<String, dynamic> fallback = _createValidJsonStructure(raw);
      return UserModel.fromJson(fallback);
    }
  }

  @override
  Future<void> updateUser(UserModel user) {
    return writeNfcData(user.toJson());
  }

  /// Reads JSON data stored in an NTAG216 (or other NDEF-capable NFC tag)
  /// Uses flutter_nfc_kit NDEF helpers to read first text record as JSON.
  Future<String> getNfcData() async {
    try {
      await FlutterNfcKit.poll();

      final List<ndef.NDEFRecord> records = await FlutterNfcKit.readNDEFRecords(
        cached: false,
      );
      if (records.isEmpty) {
        throw Exception('No NDEF records found');
      }

      return _extractTextFromNdefRecord(records.first);
    } on Exception catch (e) {
      final String message = e.toString();
      if (message.contains('not supported') || message.contains('disabled')) {
        throw Exception('NFC is not available or turned off on this device');
      }
      if (message.contains('not NDEF') || message.contains('NDEF')) {
        throw Exception('This tag does not support NDEF');
      }
      rethrow;
    } finally {
      await _safeFinish();
    }
  }

  /// Writes JSON data to an NTAG216 (or other NDEF-capable NFC tag)
  /// Writes a single NDEF Text record containing JSON string.
  Future<void> writeNfcData(Map<String, dynamic> data) async {
    final String encoded = jsonEncode(data);
    try {
      await FlutterNfcKit.poll();

      // Conservative size check for NTAG216
      if (encoded.codeUnits.length > 800) {
        throw Exception('Tag capacity too small for provided data');
      }

      final ndef.TextRecord record = ndef.TextRecord(
        language: 'en',
        text: encoded,
      );
      await FlutterNfcKit.writeNDEFRecords(<ndef.NDEFRecord>[record]);
    } on Exception catch (e) {
      final String message = e.toString();
      if (message.contains('not supported') || message.contains('disabled')) {
        throw Exception('NFC is not available or turned off on this device');
      }
      if (message.contains('not NDEF') || message.contains('NDEF')) {
        throw Exception('This tag does not support NDEF');
      }
      rethrow;
    } finally {
      await _safeFinish();
    }
  }

  /// Ends any ongoing NFC session safely
  Future<void> resetSession() async {
    await _safeFinish();
  }

  /// Disposes resources; safe no-op for compatibility with tests and callers
  void dispose() {
    // Intentionally do not await here; keep it fire-and-forget
    _safeFinish();
  }

  // Helper to construct a valid user-like JSON when raw tag data isn't JSON
  Map<String, dynamic> _createValidJsonStructure(dynamic rawData) {
    return <String, dynamic>{
      'id': 'nfc_${DateTime.now().millisecondsSinceEpoch}',
      'name': 'NFC Card',
      'balance': 0.0,
      'rawData': rawData,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  Future<void> _safeFinish() async {
    try {
      await FlutterNfcKit.finish();
    } catch (_) {
      // Ignore in tests or environments where the plugin channel isn't set up
    }
  }

  String _extractTextFromNdefRecord(ndef.NDEFRecord record) {
    // For Well Known Text records: payload[0] status byte where lower 6 bits are language code length
    // We do not rely on typeNameFormat enum here to avoid cross-package enum coupling.
    final Uint8List? typeBytes = record.type;
    if (typeBytes != null && typeBytes.isNotEmpty && typeBytes.first == 0x54) {
      final Uint8List payload = record.payload ?? Uint8List(0);
      if (payload.isEmpty) return '';
      final int langCodeLen = payload[0] & 0x3F;
      final Uint8List textBytes = payload.sublist(1 + langCodeLen);
      return utf8.decode(textBytes);
    }
    // Otherwise try raw payload as UTF-8
    try {
      return utf8.decode(record.payload ?? Uint8List(0));
    } catch (_) {
      return '';
    }
  }

  @override
  Future<void> makeTransaction(
    UserModel user,
    OperationTypeEnum operationType,
    double amount,
  ) {
    return _makeTransactionInternal(user, operationType, amount);
  }

  Future<void> _makeTransactionInternal(
    UserModel user,
    OperationTypeEnum operationType,
    double amount,
  ) async {
    if (amount <= 0) {
      throw Exception('Amount must be greater than 0');
    }

    switch (operationType) {
      case OperationTypeEnum.withdrawal:
        // Read latest card data to validate current balance, then deduct
        final UserModel currentOnCard = await getUser();
        if (amount > currentOnCard.balance) {
          throw Exception('Amount exceeds balance');
        }
        final UserModel updated = UserModel(
          id: currentOnCard.id,
          name: currentOnCard.name,
          balance: currentOnCard.balance - amount,
        );
        await writeNfcData(updated.toJson());
        return;
      case OperationTypeEnum.deposit:
        // Read current card, add amount, then write
        final UserModel currentOnCard = await getUser();
        final UserModel updated = UserModel(
          id: currentOnCard.id,
          name: currentOnCard.name,
          balance: currentOnCard.balance + amount,
        );
        await writeNfcData(updated.toJson());
        return;
      case OperationTypeEnum.transfer:
        // Transfer: scan sender, deduct; then scan recipient, add.
        // Each step uses a single NFC session (poll -> read/write -> finish).
        await _performTransfer(amount);
        return;
    }
  }

  Future<void> _performTransfer(double amount) async {
    // Step 1: Scan sender and deduct the amount
    final UserModel senderCurrent = await getUser();
    if (amount > senderCurrent.balance) {
      throw Exception('Amount exceeds balance');
    }
    final UserModel senderUpdated = UserModel(
      id: senderCurrent.id,
      name: senderCurrent.name,
      balance: senderCurrent.balance - amount,
    );
    await writeNfcData(senderUpdated.toJson());

    // Step 2: Scan recipient and add the amount
    final UserModel recipientCurrent = await getUser();
    final UserModel recipientUpdated = UserModel(
      id: recipientCurrent.id,
      name: recipientCurrent.name,
      balance: recipientCurrent.balance + amount,
    );
    await writeNfcData(recipientUpdated.toJson());
  }
}
