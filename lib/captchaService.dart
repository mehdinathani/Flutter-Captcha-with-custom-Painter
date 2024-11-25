import 'dart:math';

class Captchaservice {
  String randomString = '';
  static const String _letters =
      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";

  /// Generate a random CAPTCHA string
  void buildCaptcha({int length = 6}) {
    final random = Random();
    randomString = String.fromCharCodes(
      List.generate(length,
          (index) => _letters.codeUnitAt(random.nextInt(_letters.length))),
    );
  }
}
