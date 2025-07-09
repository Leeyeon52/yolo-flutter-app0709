
import 'package:flutter/material.dart';
import 'home_screen.dart'; // 같은 폴더라면 이렇게


class LoginScreen extends StatefulWidget {
  final String baseUrl; // ✅ baseUrl을 받기 위한 필드 추가

  const LoginScreen({
    super.key,
    required this.baseUrl, // ✅ 생성자에 baseUrl 추가
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    // 실제 로그인 검증 생략하고 바로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          baseUrl: widget.baseUrl, // ✅ HomeScreen으로 baseUrl 전달
          userId: emailController.text, // 예시: 로그인 ID를 userId로 전달
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '비밀번호'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: login,
              child: const Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
