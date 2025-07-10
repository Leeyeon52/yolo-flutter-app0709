import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // GoRouter 임포트 확인
import 'package:provider/provider.dart';
import 'presentation/viewmodel/userinfo_viewmodel.dart'; // 🔁 이 import도 필요
import 'presentation/viewmodel/auth_viewmodel.dart';
import 'services/router.dart'; // router.dart 파일 임포트

void main() {
  // 앱 전체에서 사용할 기본 URL을 정의합니다.
  const String globalBaseUrl = "http://192.168.0.19:5000/api";

  // MultiProvider를 사용하여 앱 전체에서 AuthViewModel을 사용할 수 있도록 설정합니다.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(baseUrl: globalBaseUrl),
        ),
        ChangeNotifierProvider(
          create: (_) => UserInfoViewModel(), // ✅ 추가
        ),
      ],
      // YOLOExampleApp을 실행하며 baseUrl을 전달합니다.
      child: YOLOExampleApp(baseUrl: globalBaseUrl),
    ),
  );
}

class YOLOExampleApp extends StatelessWidget {
  final String baseUrl; // baseUrl을 전달받기 위한 변수

  const YOLOExampleApp({super.key, required this.baseUrl});

  @override
  Widget build(BuildContext context) {
    // MaterialApp.router를 사용하여 GoRouter와 통합합니다.
    return MaterialApp.router(
      title: 'YOLO Plugin Example', // 앱 제목
      debugShowCheckedModeBanner: false, // 디버그 배너 숨기기
      routerConfig: createRouter(baseUrl), // services/router.dart에서 정의된 라우터 설정을 사용합니다.
      theme: ThemeData(
        primaryColor: const Color(0xFF42A5F5), // 앱의 주 색상 설정 (예시: 밝은 파랑)
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF42A5F5), // 앱바 배경색을 주 색상으로 설정
        ),
        // 다른 테마 설정도 여기에 추가할 수 있습니다.
      ),
    );
  }
}
