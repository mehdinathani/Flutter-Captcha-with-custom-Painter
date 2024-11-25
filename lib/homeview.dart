import 'dart:math';

import 'package:flutter/material.dart';
import 'captchaService.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController controller = TextEditingController();
  final Captchaservice _captchaService = Captchaservice();
  bool isVerified = false;

  @override
  void initState() {
    super.initState();
    _captchaService.buildCaptcha();
  }

  /// Refresh CAPTCHA
  void refreshCaptcha() {
    _captchaService.buildCaptcha();
    controller.clear();
    isVerified = false;
    setState(() {});
  }

  /// Verify CAPTCHA
  void checkCaptcha() {
    setState(() {
      isVerified = _captchaService.randomString == controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        centerTitle: true,
        title: const Text(
          "Custom CAPTCHA",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Enter CAPTCHA Value",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // CAPTCHA Image with CustomPainter
                  Container(
                    width: 200,
                    height: 100,
                    color: Colors.grey[200],
                    child: CustomPaint(
                      painter: CaptchaPainter(_captchaService.randomString),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Refresh CAPTCHA Button
                  IconButton(
                    onPressed: refreshCaptcha,
                    icon: const Icon(Icons.refresh, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  // TextField for user input
                  TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter CAPTCHA",
                      labelText: "CAPTCHA",
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Verify CAPTCHA Button
                  ElevatedButton(
                    onPressed: checkCaptcha,
                    child: const Text("Check"),
                  ),
                  const SizedBox(height: 10),
                  // CAPTCHA Result
                  if (isVerified)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified, color: Colors.green),
                        SizedBox(width: 5),
                        Text("Verified", style: TextStyle(color: Colors.green)),
                      ],
                    )
                  else
                    const Text("Please enter the value shown on the screen"),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey,
            child: const Text(
              textAlign: TextAlign.center,
              "Created with ❤ by Mehdi Abbas Nathani",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class CaptchaPainter extends CustomPainter {
  final String captchaText;
  CaptchaPainter(this.captchaText);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();

    // Draw random lines for obfuscation
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = random.nextDouble() * 2 + 1;
    for (int i = 0; i < 5; i++) {
      paint.color = Colors.primaries[random.nextInt(Colors.primaries.length)];
      canvas.drawLine(
        Offset(random.nextDouble() * size.width,
            random.nextDouble() * size.height),
        Offset(random.nextDouble() * size.width,
            random.nextDouble() * size.height),
        paint,
      );
    }

    // Draw CAPTCHA text
    final textPainter = TextPainter(
      text: TextSpan(
        text: captchaText,
        style: TextStyle(
          fontSize: 24,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
