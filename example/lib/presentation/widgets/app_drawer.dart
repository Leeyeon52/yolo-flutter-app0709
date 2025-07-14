import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '/presentation/viewmodel/auth_viewmodel.dart';
import '/presentation/viewmodel/userinfo_viewmodel.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = context.read<AuthViewModel>();
    final userInfoVM = context.read<UserInfoViewModel>();

    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF42A5F5)),
            alignment: Alignment.bottomLeft,
            child: Text(
              'TOOTH AI 닥터 메뉴',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(context, '🛎️ 비대면 진료 신청', '/d_home'),
                _drawerItem(context, '📅 예약 현황', '/d_reservations'),
                _drawerItem(context, '🔍 진단 결과', '/d_results'),
                _drawerItem(context, '📆 진료 캘린더', '/d_calendar'),
                _drawerItem(context, '👩‍⚕️ 환자 목록', '/d_patients'),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('로그아웃'),
            onTap: () {
              Navigator.pop(context);     // Drawer 닫기
              authVM.logout();
              userInfoVM.clearUser();
              context.go('/login');       // 로그인 화면으로 이동
            },
          ),
        ],
      ),
    );
  }

  ListTile _drawerItem(BuildContext ctx, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(ctx);    // Drawer 닫기
        ctx.push(route);       // push로 이동 → AppBar에 ← 버튼 생김
      },
    );
  }
}
