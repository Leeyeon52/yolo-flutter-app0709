import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'presentation/viewmodel/userinfo_viewmodel.dart';
import 'services/router.dart';
import '/presentation/screens/doctor/d_home_screen.dart'; // d_home_screen.dart 임포트

// ✅ AuthViewModel 임포트
import '/presentation/viewmodel/auth_viewmodel.dart';
// ✅ doctor 폴더 내의 뷰모델 임포트 (AuthViewModel은 이제 일반 폴더에서 가져오므로 제거)
import '/presentation/viewmodel/doctor/d_patient_viewmodel.dart';
import '/presentation/viewmodel/doctor/d_consultation_viewmodel.dart';


void main() {
  const String globalBaseUrl = "http://192.168.0.19:5000/api";

  runApp(
    MultiProvider(
      providers: [
        // ✅ AuthViewModel Provider 등록 (DAuthViewModel 대신)
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(baseUrl: globalBaseUrl),
        ),
        ChangeNotifierProvider(
          create: (_) => UserInfoViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => DoctorDashboardViewModel(),
        ),
        // ✅ DPatientViewModel Provider 등록
        ChangeNotifierProvider(
          create: (_) => DPatientViewModel(baseUrl: globalBaseUrl),
        ),
        // ✅ DConsultationViewModel Provider 등록
        ChangeNotifierProvider(
          create: (_) => DConsultationViewModel(baseUrl: globalBaseUrl), // Base URL 전달
        ),
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
      title: 'YOLO Plugin Example',
      debugShowCheckedModeBanner: false,
      routerConfig: createRouter(baseUrl),
      theme: ThemeData(
        primaryColor: const Color(0xFF42A5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF42A5F5),
        ),
      ),
    );
  }
}
