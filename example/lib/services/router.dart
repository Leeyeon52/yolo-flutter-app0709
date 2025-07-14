import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 화면 import
import '/presentation/screens/login_screen.dart';
import '/presentation/screens/register_screen.dart';
import '/presentation/screens/web_placeholder_screen.dart';

import '/presentation/screens/main_scaffold.dart';

import '/presentation/screens/home_screen.dart';
import '/presentation/screens/chatbot_screen.dart';
import '/presentation/screens/mypage_screen.dart';
import '/presentation/screens/upload_screen.dart';
import '/presentation/screens/history_screen.dart';
import '/presentation/screens/clinics_screen.dart';
import '/presentation/screens/camera_inference_screen.dart';

import '/presentation/screens/doctor/d_home_screen.dart';
import '/presentation/screens/doctor/d_alert_list_screen.dart'; // 🆕

// 의사 추가 화면 import
import '/presentation/screens/doctor/d_reservation_screen.dart';
import '/presentation/screens/doctor/d_result_screen.dart';
import '/presentation/screens/doctor/d_calendar_screen.dart';
import '/presentation/screens/doctor/d_patient_list_screen.dart';

GoRouter createRouter(String baseUrl) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(baseUrl: baseUrl),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/web',
        builder: (context, state) => const WebPlaceholderScreen(),
      ),

      // ✅ 의사 홈 (기본으로 알림 리스트 포함)
      GoRoute(
        path: '/d_home',
        builder: (context, state) => const DAlertListScreen(),
      ),

      // 의사용 추가 라우트
      GoRoute(
        path: '/d_reservations',
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>? ?? {};
          return DoctorReservationScreen(
            userId: extraData['userId'] ?? 'guest',
            baseUrl: extraData['baseUrl'] ?? baseUrl,
          );
        },
      ),
      GoRoute(
        path: '/d_results',
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>? ?? {};
          return DoctorResultScreen(
            userId: extraData['userId'] ?? 'guest',
            baseUrl: extraData['baseUrl'] ?? baseUrl,
          );
        },
      ),
      GoRoute(
        path: '/d_calendar',
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>? ?? {};
          return DoctorCalendarScreen(
            userId: extraData['userId'] ?? 'guest',
            baseUrl: extraData['baseUrl'] ?? baseUrl,
          );
        },
      ),
      GoRoute(
        path: '/d_patients',
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>? ?? {};
          return DoctorPatientListScreen(
            userId: extraData['userId'] ?? 'guest',
            baseUrl: extraData['baseUrl'] ?? baseUrl,
          );
        },
      ),

      // ✅ 하단 탭 바 있는 일반 사용자용 ShellRoute
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(
            child: child,
            currentLocation: state.uri.toString(),
          );
        },
        routes: [
          GoRoute(
            path: '/chatbot',
            builder: (context, state) => const ChatbotScreen(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) {
              final authViewModel = state.extra as Map<String, dynamic>? ?? {};
              final userId = authViewModel['userId'] ?? 'guest';
              return HomeScreen(baseUrl: baseUrl, userId: userId);
            },
          ),
          GoRoute(
            path: '/mypage',
            builder: (context, state) => const MyPageScreen(),
          ),
          GoRoute(
            path: '/upload',
            builder: (context, state) {
              final passedBaseUrl = state.extra as String? ?? baseUrl;
              return UploadScreen(baseUrl: passedBaseUrl);
            },
          ),
          GoRoute(
            path: '/diagnosis/realtime',
            builder: (context, state) {
              final data = state.extra as Map<String, dynamic>? ?? {};
              return CameraInferenceScreen(
                baseUrl: data['baseUrl'] ?? '',
                userId: data['userId'] ?? 'guest',
              );
            },
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) {
              final passedBaseUrl = state.extra as String? ?? baseUrl;
              return HistoryScreen(baseUrl: passedBaseUrl);
            },
          ),
          GoRoute(
            path: '/clinics',
            builder: (context, state) => const ClinicsScreen(),
          ),
          GoRoute(
            path: '/camera',
            builder: (context, state) {
              final data = state.extra as Map<String, dynamic>? ?? {};
              return CameraInferenceScreen(
                baseUrl: data['baseUrl'] ?? '',
                userId: data['userId'] ?? 'guest',
              );
            },
          ),
        ],
      ),
    ],
  );
}
