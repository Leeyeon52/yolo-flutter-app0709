import 'package:flutter/foundation.dart';

enum AlertStatus { waiting, inProgress, done }

class Alert {
  final String id, name, description, date;
  final AlertStatus status;

  Alert({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.status,
  });

  String get statusText => switch (status) {
        AlertStatus.waiting => '대기중',
        AlertStatus.inProgress => '진료중',
        AlertStatus.done => '답변완료',
      };
}

class DAlertViewModel extends ChangeNotifier {
  bool loading = false;
  List<Alert> alerts = [];

  Future<void> fetchAlerts() async {
    loading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // ✅ 시뮬레이션

    alerts = [
      Alert(
        id: '1',
        name: '김철수',
        description: '치석, 치주염',
        date: 'Wed, 18 Jul',
        status: AlertStatus.waiting,
      ),
      Alert(
        id: '2',
        name: '이영희',
        description: '충치 의심, 잇몸 통증',
        date: 'Sun, 15 Jul',
        status: AlertStatus.waiting,
      ),
      Alert(
        id: '3',
        name: '조세호',
        description: '치아 시린 증상',
        date: 'Thu, 12 Jul',
        status: AlertStatus.inProgress,
      ),
      Alert(
        id: '4',
        name: '문상훈',
        description: '임플란트 상담 요청',
        date: 'Fri, 06 Jul',
        status: AlertStatus.done,
      ),
    ];

    loading = false;
    notifyListeners();
  }
}
