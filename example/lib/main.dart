import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'presentation/viewmodel/auth_viewmodel.dart';
import 'services/router.dart';

void main() {
  const String globalBaseUrl = "https://d9988bfda490.ngrok-free.app";
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(baseUrl: globalBaseUrl),
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
    );
  }
}
