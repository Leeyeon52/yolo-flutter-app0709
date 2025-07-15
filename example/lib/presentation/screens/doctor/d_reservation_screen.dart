import 'package:flutter/material.dart';
import '/presentation/widgets/app_drawer.dart';

class DoctorReservationScreen extends StatelessWidget {
  final String userId;
  final String baseUrl;

  const DoctorReservationScreen({
    super.key,
    required this.userId,
    required this.baseUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('예약 현황'),
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Text('예약 리스트 표시 영역\nUser ID: $userId\nBase URL: $baseUrl'),
      ),
    );
  }
}
