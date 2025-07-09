//C:\Users\302-1\Desktop\yolo-flutter-app\example\lib\presentation\screens\home_screen.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'camera_inference_screen.dart';
import 'web_placeholder_screen.dart'; // 웹용 안내 화면

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void goToNext(BuildContext context) {
    if (kIsWeb) {
      // 웹에서는 안내 화면으로
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const WebPlaceholderScreen()),
      );
    } else {
      // 모바일에서는 YOLO 추론 화면으로
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CameraInferenceScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('홈 화면')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => goToNext(context),
          child: const Text('YOLO 추론 시작'),
        ),
      ),
    );
  }
}
