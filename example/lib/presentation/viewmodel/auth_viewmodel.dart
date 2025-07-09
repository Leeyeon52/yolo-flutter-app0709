import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kDebugMode;
import '/presentation/model/user.dart';

class AuthViewModel with ChangeNotifier {
  final String _baseUrl;
  String? _errorMessage;
  String? duplicateCheckErrorMessage; // ✅ 추가
  bool isCheckingUserId = false; // ✅ 추가
  User? _currentUser;

  AuthViewModel({required String baseUrl}) : _baseUrl = baseUrl;

  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  // ✅ 아이디 중복 확인 추가
  Future<bool?> checkUserIdDuplicate(String userId) async {
    isCheckingUserId = true;
    duplicateCheckErrorMessage = null;
    notifyListeners();

    try {
      final res = await http.get(Uri.parse('$_baseUrl/doctor/exists?email=$userId'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['exists'] == true;
      } else {
        duplicateCheckErrorMessage = '서버 응답 오류 (${res.statusCode})';
        return null;
      }
    } catch (e) {
      duplicateCheckErrorMessage = '중복 확인 실패: ${e.toString()}';
      return null;
    } finally {
      isCheckingUserId = false;
      notifyListeners();
    }
  }

  // ✅ 기존 registerUser 재정의
  Future<String?> registerUser(Map<String, dynamic> userData) async {
    _errorMessage = null;

    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/doctor/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (res.statusCode == 201) {
        notifyListeners();
        return null; // 성공
      } else {
        final decodedBody = json.decode(res.body);
        final message = decodedBody['message'] ?? '회원가입 실패 (${res.statusCode})';
        return message;
      }
    } catch (e) {
      return '회원가입 실패: ${e.toString()}';
    }
  }

  Future<User?> loginUser(String email, String password) async {
    _errorMessage = null;
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/doctor/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (res.statusCode == 200) {
        final decodedBody = jsonDecode(res.body);
        if (decodedBody is Map && decodedBody['user'] != null) {
          _currentUser = User.fromJson(decodedBody['user']);
          notifyListeners();
          return _currentUser;
        } else {
          _errorMessage = '로그인 실패: 응답 형식 오류';
          return null;
        }
      } else {
        final decodedBody = json.decode(res.body);
        _errorMessage = decodedBody['message'] ?? '로그인 실패 (${res.statusCode})';
        return null;
      }
    } catch (e) {
      _errorMessage = '로그인 실패: ${e.toString()}';
      return null;
    }
  }

  Future<String?> deleteUser(String email, String password) async {
    try {
      final res = await http.delete(
        Uri.parse('$_baseUrl/doctor/delete_account'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (res.statusCode == 200) {
        notifyListeners();
        return null;
      } else {
        final decodedBody = json.decode(res.body);
        return decodedBody['message'] ?? '회원 탈퇴 실패 (${res.statusCode})';
      }
    } catch (e) {
      return '회원 탈퇴 실패: ${e.toString()}';
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
