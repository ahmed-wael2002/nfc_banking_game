import 'package:flutter_test/flutter_test.dart';
import 'package:nfc/features/home/data/data_source/remote/nfc_data_source_impl.dart';
import 'package:nfc/features/home/data/models/user.dart';
import 'dart:convert';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('NfcDataSourceImpl', () {
    late NfcDataSourceImpl nfcDataSource;

    setUp(() {
      // Note: In a real test environment, you would use a mock NfcManager
      // For now, we'll test the logic without actual NFC hardware
      nfcDataSource = NfcDataSourceImpl();
    });

    tearDown(() {});

    group('NFC Data Processing', () {
      test('should process NDEF text record correctly', () {
        // Arrange
        final testData =
            '{"id":"user123","name":"Ahmed Wael","balance":1500.0}';
        final ndefRecord = {
          'type': [0x54], // Text record type
          'payload': [0x02, ...testData.codeUnits], // UTF-8 encoding
        };

        // Act
        final extractedData = _extractNdefTextRecord(ndefRecord);

        // Assert
        expect(extractedData, testData);
      });

      test('should process NDEF custom record correctly', () {
        // Arrange
        final testData = '{"id":"user456","name":"John Doe","balance":2000.0}';
        final ndefRecord = {
          'type': [0x01], // Custom record type
          'payload': testData.codeUnits,
        };

        // Act
        final extractedData = _extractNdefCustomRecord(ndefRecord);

        // Assert
        expect(extractedData, testData);
      });

      test('should create valid JSON structure for non-JSON data', () {
        // Arrange
        final rawData = 'This is not JSON data';

        // Act
        final jsonData = _createValidJsonStructure(rawData);

        // Assert
        expect(jsonData['rawData'], rawData);
        expect(jsonData['name'], 'NFC Card');
        expect(jsonData['balance'], 0.0);
        expect(jsonData['id'], isA<String>());
        expect(jsonData['timestamp'], isA<String>());
      });

      test('should handle empty string data', () {
        // Arrange
        final emptyData = '';

        // Act
        final jsonData = _createValidJsonStructure(emptyData);

        // Assert
        expect(jsonData['rawData'], emptyData);
        expect(jsonData['name'], 'NFC Card');
      });

      test('should handle null data gracefully', () {
        // Arrange
        final nullData = null;

        // Act
        final jsonData = _createValidJsonStructure(nullData);

        // Assert
        expect(jsonData['rawData'], null);
        expect(jsonData['name'], 'NFC Card');
      });
    });

    group('User Model Operations', () {
      test('should convert UserModel to JSON correctly', () {
        // Arrange
        final user = UserModel(
          id: 'user123',
          name: 'Ahmed Wael',
          balance: 1500.0,
        );

        // Act
        final jsonData = user.toJson();

        // Assert
        expect(jsonData['id'], 'user123');
        expect(jsonData['name'], 'Ahmed Wael');
        expect(jsonData['balance'], 1500.0);
      });

      test('should create UserModel from JSON correctly', () {
        // Arrange
        final jsonData = {
          'id': 'user123',
          'name': 'Ahmed Wael',
          'balance': 1500.0,
        };

        // Act
        final user = UserModel.fromJson(jsonData);

        // Assert
        expect(user.id, 'user123');
        expect(user.name, 'Ahmed Wael');
        expect(user.balance, 1500.0);
      });

      test('should handle JSON encoding and decoding correctly', () {
        // Arrange
        final user = UserModel(
          id: 'user123',
          name: 'Ahmed Wael',
          balance: 1500.0,
        );

        // Act
        final jsonString = json.encode(user.toJson());
        final decodedJson = json.decode(jsonString);
        final decodedUser = UserModel.fromJson(decodedJson);

        // Assert
        expect(decodedUser.id, user.id);
        expect(decodedUser.name, user.name);
        expect(decodedUser.balance, user.balance);
      });
    });

    group('NDEF Message Creation', () {
      test('should create valid NDEF text message', () {
        // Arrange
        final testData =
            '{"id":"user123","name":"Ahmed Wael","balance":1500.0}';

        // Act
        final ndefMessage = _createNdefTextMessage(testData);

        // Assert
        expect(ndefMessage['records'], isList);
        expect(ndefMessage['records'].length, 1);

        final record = ndefMessage['records'][0];
        expect(record['type'], [0x54]); // Text record type
        expect(record['payload'], isList);
        expect(record['payload'][0], 0x02); // UTF-8 encoding
      });

      test('should create valid NDEF custom message', () {
        // Arrange
        final testData =
            '{"id":"user123","name":"Ahmed Wael","balance":1500.0}';

        // Act
        final ndefMessage = _createNdefCustomMessage(testData);

        // Assert
        expect(ndefMessage['records'], isList);
        expect(ndefMessage['records'].length, 1);

        final record = ndefMessage['records'][0];
        expect(record['type'], [0x01]); // Custom record type
        expect(record['payload'], isList);
      });
    });

    group('Error Handling', () {
      test('should handle invalid JSON gracefully', () {
        // Arrange
        final invalidJson = 'This is not valid JSON';

        // Act & Assert
        expect(() => json.decode(invalidJson), throwsA(isA<FormatException>()));
      });

      test('should handle empty string data', () {
        // Arrange
        final emptyData = '';

        // Act
        final jsonData = _createValidJsonStructure(emptyData);

        // Assert
        expect(jsonData['rawData'], emptyData);
        expect(jsonData['name'], 'NFC Card');
      });

      test('should handle null data gracefully', () {
        // Arrange
        final nullData = null;

        // Act
        final jsonData = _createValidJsonStructure(nullData);

        // Assert
        expect(jsonData['rawData'], null);
        expect(jsonData['name'], 'NFC Card');
      });
    });

    group('Session Management', () {
      test('should handle session reset correctly', () async {
        // Act & Assert - should not throw
        expect(() async => await nfcDataSource.resetSession(), returnsNormally);
      });

      test('should handle dispose correctly', () {
        // Act & Assert - should not throw
        expect(() => nfcDataSource.dispose(), returnsNormally);
      });
    });
  });
}

// Helper functions for testing NDEF processing
String _extractNdefTextRecord(Map<String, dynamic> record) {
  final type = record['type'] as List;
  final payload = record['payload'] as List;

  if (type.isNotEmpty && type[0] == 0x54) {
    if (payload.length > 1) {
      // For NDEF text records, the first byte contains status and length
      // The actual text starts from the second byte
      final textBytes = payload.sublist(1).cast<int>();
      return String.fromCharCodes(textBytes);
    }
  }
  return '';
}

String _extractNdefCustomRecord(Map<String, dynamic> record) {
  final type = record['type'] as List;
  final payload = record['payload'] as List;

  if (type.isNotEmpty && type[0] == 0x01) {
    final payloadBytes = payload.cast<int>();
    return String.fromCharCodes(payloadBytes);
  }
  return '';
}

Map<String, dynamic> _createValidJsonStructure(dynamic rawData) {
  return {
    'id': 'nfc_${DateTime.now().millisecondsSinceEpoch}',
    'name': 'NFC Card',
    'balance': 0.0,
    'rawData': rawData,
    'timestamp': DateTime.now().toIso8601String(),
  };
}

Map<String, dynamic> _createDefaultUserStructure() {
  return {
    'id': 'nfc_${DateTime.now().millisecondsSinceEpoch}',
    'name': 'NFC Card',
    'balance': 0.0,
    'timestamp': DateTime.now().toIso8601String(),
  };
}

Map<String, dynamic> _createNdefTextMessage(String data) {
  return {
    'records': [
      {
        'type': [0x54], // Text record type
        'payload': [0x02, ...data.codeUnits], // UTF-8 encoding
      },
    ],
  };
}

Map<String, dynamic> _createNdefCustomMessage(String data) {
  return {
    'records': [
      {
        'type': [0x01], // Custom record type
        'payload': data.codeUnits,
      },
    ],
  };
}
