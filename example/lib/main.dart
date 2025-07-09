import 'package:flutter/material.dart';
import 'presentation/screens/login_screen.dart';

void main() {
  const String globalBaseUrl = "https://d9988bfda490.ngrok-free.app"; // 여기에 실제 백엔드 URL을 입력하세요.

  runApp(
    const YOLOExampleApp(baseUrl: globalBaseUrl),
  );
}

class YOLOExampleApp extends StatelessWidget {
  final String baseUrl; // baseUrl을 받을 수 있도록 필드 추가

  const YOLOExampleApp({super.key, required this.baseUrl}); // 생성자에 baseUrl 추가
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YOLO Plugin Example',
      home: LoginScreen(baseUrl: baseUrl), // LoginScreen에 baseUrl 전달 (LoginScreen 수정 필요)
      debugShowCheckedModeBanner: false,
    );
  }
}