import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'camera_inference_screen.dart';
import 'web_placeholder_screen.dart'; // 웹용 안내 화면

class HomeScreen extends StatefulWidget {
  final String baseUrl;
  final String userId;

  const HomeScreen({
    super.key,
    required this.baseUrl,
    required this.userId,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        MaterialPageRoute(
          builder: (_) => CameraInferenceScreen(
            userId: widget.userId, // ✅ LoginScreen에서 받은 userId 사용
            baseUrl: widget.baseUrl, // ✅ LoginScreen에서 받은 baseUrl 사용
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('홈 화면')),
      body: Center(
        child: Column( // Column 추가하여 userId 표시
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '환영합니다, ${widget.userId}님!', // userId 표시
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => goToNext(context),
              child: const Text('YOLO 추론 시작'),
            ),
          ],
        ),
      ),
    );
  }
}