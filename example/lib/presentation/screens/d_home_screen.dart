import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('의사 홈')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/login');
          },
          child: const Text('로그아웃'),
        ),
      ),
    );
  }
}
