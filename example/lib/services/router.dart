import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/presentation/screens/login_screen.dart';
import '/presentation/screens/home_screen.dart';
import '/presentation/screens/camera_inference_screen.dart';
import '/presentation/screens/web_placeholder_screen.dart';
import '/presentation/screens/register_screen.dart'; // ✅ 추가

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
        builder: (context, state) => const RegisterScreen(), // ✅ 회원가입 화면 연결
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return HomeScreen(
            baseUrl: data['baseUrl'] ?? '',
            userId: data['userId'] ?? 'guest',
          );
        },
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
      GoRoute(
        path: '/web',
        builder: (context, state) => const WebPlaceholderScreen(),
      ),
    ],
  );
}