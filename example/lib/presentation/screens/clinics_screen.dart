import 'package:flutter/material.dart';
class ClinicsScreen extends StatelessWidget {
  const ClinicsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('주변 치과')),
      body: const Center(child: Text('주변 치과 지도 및 목록')),
    );
  }
}