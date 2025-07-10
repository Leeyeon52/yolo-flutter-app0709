import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '/presentation/viewmodel/auth_viewmodel.dart';
import '/presentation/viewmodel/userinfo_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  final String baseUrl;

  const LoginScreen({
    super.key,
    required this.baseUrl,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 로그인 함수
  Future<void> login() async {
    final authViewModel = context.read<AuthViewModel>();
    final userInfoViewModel = context.read<UserInfoViewModel>();

    final id = emailController.text.trim();
    final pw = passwordController.text.trim();

    if (id.isEmpty || pw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이디와 비밀번호를 입력해주세요')),
      );
      return;
    }

    // 로그인 요청
    final user = await authViewModel.loginUser(id, pw);

    if (user != null) {
      userInfoViewModel.loadUser(user); // ✅ 유저 정보 저장
      context.go('/home');
    } else {
      final error = authViewModel.errorMessage ?? '로그인 실패';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
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
              decoration: const InputDecoration(labelText: '아이디'),
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
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                context.go('/register');
              },
              child: const Text('회원가입 하기'),
            ),
          ],
        ),
      ),
    );
  }
}