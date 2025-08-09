import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:nfc/features/home/data/data_source/data_source_interface.dart';
import 'package:nfc/features/home/data/models/user.dart';

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
}
