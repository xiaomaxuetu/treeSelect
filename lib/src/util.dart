import 'dart:convert';
import 'dart:math';

class Util {
  static String generateRandom([int length = 16]) {
    final Random _random = Random.secure();
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values).substring(0, length);
  }

  static bool truthful(value) {
    if (value == null) {
      return false;
    }
    if (value == true ||
        value == 'true' ||
        value == 1 ||
        value == '1' ||
        value.toString().toLowerCase() == 'yes') {
      return true;
    }
    return false;
  }
}
