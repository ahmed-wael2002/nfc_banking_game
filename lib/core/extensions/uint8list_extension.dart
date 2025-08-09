import 'dart:typed_data';

extension Uint8listExtension on Uint8List {
  String getFileExtension() {
    if (length < 4) return '';

    // Check for common file signatures (magic numbers)
    if (this[0] == 0xFF && this[1] == 0xD8 && this[2] == 0xFF) {
      return 'jpg';
    } else if (this[0] == 0x89 &&
        this[1] == 0x50 &&
        this[2] == 0x4E &&
        this[3] == 0x47) {
      return 'png';
    } else if (this[0] == 0x47 && this[1] == 0x49 && this[2] == 0x46) {
      return 'gif';
    } else if (this[0] == 0x50 &&
        this[1] == 0x4B &&
        (this[2] == 0x03 || this[2] == 0x05 || this[2] == 0x07)) {
      return 'zip';
    } else if (this[0] == 0x25 &&
        this[1] == 0x50 &&
        this[2] == 0x44 &&
        this[3] == 0x46) {
      return 'pdf';
    } else if ((this[0] == 0xD0 &&
            this[1] == 0xCF &&
            this[2] == 0x11 &&
            this[3] == 0xE0) ||
        (this[0] == 0x50 &&
            this[1] == 0x4B &&
            this[2] == 0x03 &&
            this[3] == 0x04 &&
            length > 30 &&
            sublist(30, 31).contains('word/'.codeUnitAt(0)))) {
      return 'doc';
    }

    return '';
  }
}
