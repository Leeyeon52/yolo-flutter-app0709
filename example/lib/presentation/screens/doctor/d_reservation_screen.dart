import 'package:flutter/material.dart';
import '/presentation/widgets/app_drawer.dart';

class DoctorReservationScreen extends StatelessWidget {
  const DoctorReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('예약 현황'),
        // AppBar 자동으로 ← 버튼 활성화됨 (context.push로 들어왔기 때문)
      ),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text('예약 리스트 표시 영역'),
      ),
    );
  }
}
