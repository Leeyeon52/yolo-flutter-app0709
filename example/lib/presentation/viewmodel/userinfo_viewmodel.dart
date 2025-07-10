import 'package:flutter/material.dart';
import '/presentation/model/user.dart'; // User 모델 임포트

class UserInfoViewModel extends ChangeNotifier {
  User? _user; // 현재 로그인된 사용자 정보

  User? get user => _user; // 사용자 정보 getter

  // 사용자 정보를 로드 (로그인 성공 시 호출)
  void loadUser(User user) {
    _user = user;
    notifyListeners(); // UI 업데이트 알림
  }

  // 사용자 정보를 지움 (로그아웃 또는 회원 탈퇴 시 호출)
  void clearUser() { // 함수명 변경: clear -> clearUser
    _user = null;
    notifyListeners(); // UI 업데이트 알림
  }
}