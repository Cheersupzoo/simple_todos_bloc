import 'dart:math';

/// This will generate unique IDs in the format:
///
///     3e5-7c8ffb9
///
/// ### Example
///
///     final String id = Uuid().generateV4();

class Uuid {
  final Random _random = Random();


  String generateV4() {
    // Generate xxx-xxxxxxx / 3-7.
    final int special = 8 + _random.nextInt(4);

    return 
        '${_bitsDigits(12, 3)}-'
        '${_bitsDigits(12, 3)}${_bitsDigits(16, 4)}';
  }


  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
