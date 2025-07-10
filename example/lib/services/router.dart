import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 필요한 화면들을 임포트합니다.
// 실제 파일 경로에 맞게 수정해주세요.
import '/presentation/screens/d_home_screen.dart'; // ✅ 추가
import '/presentation/screens/main_scaffold.dart';
import '/presentation/screens/login_screen.dart';
import '/presentation/screens/register_screen.dart';
import '/presentation/screens/home_screen.dart'; // HomeScreen 임포트
import '/presentation/screens/camera_inference_screen.dart';
import '/presentation/screens/web_placeholder_screen.dart';

// 하단 탭 바에 연결될 화면들 (필요시 추가/수정)
import '/presentation/screens/chatbot_screen.dart'; // 이 파일은 직접 생성해야 할 수 있습니다.
import '/presentation/screens/mypage_screen.dart'; // 이 파일은 직접 생성해야 할 수 있습니다.
import '/presentation/screens/upload_screen.dart'; // 사진으로 예측하기 화면
import '/presentation/screens/history_screen.dart'; // 이전결과 보기 화면
import '/presentation/screens/clinics_screen.dart'; // 주변 치과 화면
// import 'package:example/presentation/screens/result_screen.dart'; // 진단 결과 화면 (필요시)

GoRouter createRouter(String baseUrl) {
  return GoRouter(
    initialLocation: '/login', // 앱 시작 시 로그인 화면으로 이동
    routes: [
      // 로그인 및 회원가입 화면은 하단 탭 바가 필요 없으므로 ShellRoute 외부에 둡니다.
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(baseUrl: baseUrl),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(), // 회원가입 화면 연결
      ),
      GoRoute(
        path: '/web', // 웹 전용 플레이스홀더 화면 (하단 탭 바 없음)
        builder: (context, state) => const WebPlaceholderScreen(),
      ),
      GoRoute(
        path: '/d_home',
        builder: (context, state) => const DoctorHomeScreen(),
      ),

      // ShellRoute를 사용하여 BottomNavigationBar를 포함하는 공통 레이아웃을 정의합니다.
      // 이 ShellRoute 내의 모든 경로는 MainScaffold의 하단 탭 바를 공유합니다.
      ShellRoute(
        // builder는 현재 라우트의 위젯(child)과 현재 상태(state)를 받아 MainScaffold를 반환합니다.
        builder: (context, state, child) {
          // MainScaffold에 현재 라우트의 위젯과 경로를 전달하여 하단 탭 바의 선택 상태를 관리합니다.
          return MainScaffold(child: child, currentLocation: state.uri.toString());
        },
        routes: [
          // 하단 탭 바가 필요한 모든 경로들을 여기에 정의합니다.

          // 챗봇 탭에 해당하는 경로
          GoRoute(
            path: '/chatbot',
            builder: (context, state) => const ChatbotScreen(),
          ),

          // 홈 탭에 해당하는 경로
          GoRoute(
            path: '/home',
            builder: (context, state) {
              // 로그인 후 전달받은 userId 등을 HomeScreen에 전달할 수 있습니다.
              // 여기서는 AuthViewModel에서 userId를 가져오거나, 로그인 시점에 전달받은 값을 사용해야 합니다.
              // 예시로 'dummyUserId'를 사용하며, 실제 앱에서는 Provider.of 등을 통해 가져와야 합니다.
              final authViewModel = state.extra as Map<String, dynamic>?;
              final userId = authViewModel?['userId'] ?? 'guest';

              return HomeScreen(
                baseUrl: baseUrl,
                userId: userId, // 실제 사용자 ID로 교체 필요
              );
            },
          ),

          // 마이페이지 탭에 해당하는 경로
          GoRoute(
            path: '/mypage',
            builder: (context, state) => const MyPageScreen(),
          ),

          // 홈 탭 내에서 이동할 수 있는 다른 화면들 (하단 탭 바는 유지됩니다)
          GoRoute(
            path: '/upload', // 사진으로 예측하기 화면
            builder: (context, state) => const UploadScreen(),
          ),
          GoRoute(
            path: '/diagnosis/realtime', // 실시간 예측하기 화면
            builder: (context, state) {
              final data = state.extra as Map<String, dynamic>? ?? {};
              return CameraInferenceScreen(
                baseUrl: data['baseUrl'] ?? '',
                userId: data['userId'] ?? 'guest',
              );
            },
          ),
          GoRoute(
            path: '/history', // 이전결과 보기 화면
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/clinics', // 주변 치과 화면
            builder: (context, state) => const ClinicsScreen(),
          ),
          GoRoute(
            path: '/camera', // 기존 /camera 경로도 ShellRoute 안에 포함하여 하단 탭 바를 유지
            builder: (context, state) {
              final data = state.extra as Map<String, dynamic>? ?? {};
              return CameraInferenceScreen(
                baseUrl: data['baseUrl'] ?? '',
                userId: data['userId'] ?? 'guest',
              );
            },
          ),
          // 만약 결과 화면이 별도의 경로를 가진다면 여기에 추가합니다.
          // GoRoute(
          //   path: '/result',
          //   builder: (context, state) => const ResultScreen(),
          // ),
        ],
      ),
    ],
  );
}

// 중요: 위에 임포트된 모든 화면 파일들이 실제로 프로젝트에 존재해야 합니다.
// 만약 존재하지 않는다면, 아래와 같이 간단한 더미 위젯으로 파일을 생성하여 오류를 방지할 수 있습니다.
/*

// presentation/screens/upload_screen.dart
import 'package:flutter/material.dart';
class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('사진으로 예측하기')),
      body: const Center(child: Text('사진 업로드 기능 구현 예정')),
    );
  }
}


// presentation/screens/clinics_screen.dart
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
*/