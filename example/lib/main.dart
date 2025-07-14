import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'services/router.dart';

import 'presentation/viewmodel/auth_viewmodel.dart';
import 'presentation/viewmodel/userinfo_viewmodel.dart';
import 'presentation/viewmodel/doctor/d_consultation_record_viewmodel.dart';
import 'presentation/viewmodel/doctor/d_patient_viewmodel.dart';
import 'presentation/viewmodel/doctor/d_alert_viewmodel.dart'; // 🆕

void main() {
  const String globalBaseUrl = "http://172.20.48.1:5000/api";

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel(baseUrl: globalBaseUrl)),
        ChangeNotifierProvider(create: (_) => UserInfoViewModel()),
        ChangeNotifierProvider(create: (_) => DPatientViewModel(baseUrl: globalBaseUrl)),
        ChangeNotifierProvider(create: (_) => ConsultationRecordViewModel(baseUrl: globalBaseUrl)),
        ChangeNotifierProvider(create: (_) => DAlertViewModel()), // 🆕 비대면 알림 추가
      ],
      child: YOLOExampleApp(baseUrl: globalBaseUrl),
    ),
  );
}

class YOLOExampleApp extends StatelessWidget {
  final String baseUrl;

  const YOLOExampleApp({super.key, required this.baseUrl});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tooth AI Example',
      debugShowCheckedModeBanner: false,
      routerConfig: createRouter(baseUrl),
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
