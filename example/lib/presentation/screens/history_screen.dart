import 'package:flutter/material.dart';
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('이전결과 보기')),
      body: const Center(child: Text('이전 진단 기록 목록')),
    );
  }
}