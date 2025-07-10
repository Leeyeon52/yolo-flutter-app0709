import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '/presentation/viewmodel/auth_viewmodel.dart';
import '/presentation/viewmodel/userinfo_viewmodel.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  // 스낵바 표시 유틸리티 함수
  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(15),
      ),
    );
  }

  // 회원 탈퇴 확인 다이얼로그 표시
  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final userInfoViewModel = context.read<UserInfoViewModel>();
    final authViewModel = context.read<AuthViewModel>();

    if (userInfoViewModel.user == null) {
      _showSnack(context, '로그인 정보가 없습니다.');
      return;
    }

    final passwordController = TextEditingController();

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            '회원 탈퇴',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '정말로 회원 탈퇴하시겠습니까?',
                style: TextStyle(fontSize: 15),
              ),
              const Text(
                '모든 데이터가 삭제되며 복구할 수 없습니다.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호를 다시 입력해주세요',
                  hintText: '비밀번호 입력',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('취소', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                // ✅ username 대신 registerId 사용
                final registerId = userInfoViewModel.user!.registerId;
                final password = passwordController.text;
                final role = userInfoViewModel.user!.role; // 역할도 함께 전달

                if (password.isEmpty) {
                  _showSnack(dialogContext, '비밀번호를 입력해주세요.');
                  return;
                }

                // deleteUser 함수 호출 시 registerId와 role을 함께 전달
                final error = await authViewModel.deleteUser(registerId, password, role);

                if (error == null) {
                  Navigator.of(dialogContext).pop(true);
                } else {
                  _showSnack(dialogContext, error);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text('탈퇴', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      userInfoViewModel.clearUser();
      _showSnack(context, '회원 탈퇴가 완료되었습니다.');
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfoViewModel = context.watch<UserInfoViewModel>();
    final user = userInfoViewModel.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '마이페이지',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용자 정보 섹션
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              margin: const EdgeInsets.only(bottom: 30),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '내 정보',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const Divider(height: 20, thickness: 1),
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.grey, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          '이름: ${user?.name ?? '로그인 필요'}',
                          style: const TextStyle(fontSize: 17, color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.email, color: Colors.grey, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          // ✅ username 대신 registerId 사용
                          '아이디: ${user?.registerId ?? '로그인 필요'}',
                          style: const TextStyle(fontSize: 17, color: Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 계정 설정 섹션
            const Text(
              '계정 설정',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            // 개인정보 수정 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.go('/mypage/edit'); // ✅ EditProfileScreen으로 이동
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  '개인정보 수정',
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // 로그아웃 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  userInfoViewModel.clearUser();
                  _showSnack(context, '로그아웃 되었습니다.');
                  context.go('/login');
                },
                icon: const Icon(Icons.logout, color: Colors.black87),
                label: const Text(
                  '로그아웃',
                  style: TextStyle(fontSize: 17, color: Colors.black87),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // 회원탈퇴 버튼
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showDeleteConfirmationDialog(context),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text(
                  '회원탈퇴',
                  style: TextStyle(fontSize: 17, color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
