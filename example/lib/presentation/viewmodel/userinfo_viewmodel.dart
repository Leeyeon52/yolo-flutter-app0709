import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '/presentation/model/user.dart';

class UserInfoViewModel with ChangeNotifier {
  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final String _baseUrl; // ✅ 반드시 외부에서 주입

  UserInfoViewModel({required String baseUrl}) : _baseUrl = baseUrl;

  /// 사용자 프로필 정보 가져오기
  Future<void> fetchUserProfile(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/users/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _user = User.fromJson(data); // ✅ JSON → User 파싱
      } else {
        final data = jsonDecode(res.body);
        _errorMessage = data['message'] ?? '프로필 정보를 가져오는 데 실패했습니다.';
        if (kDebugMode) {
          print('프로필 가져오기 오류: ${res.statusCode}, ${res.body}');
        }
      }
    } catch (e) {
      _errorMessage = '네트워크 오류: 서버에 연결할 수 없습니다.';
      if (kDebugMode) {
        print('네트워크 예외 발생: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 사용자 프로필 정보 업데이트
  Future<String?> updateUserProfile(int userId, Map<String, dynamic> updatedData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await http.put(
        Uri.parse('$_baseUrl/users/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedData),
      );

      if (res.statusCode == 200) {
        await fetchUserProfile(userId); // 변경 후 최신 정보 재로드
        return null;
      } else {
        final data = jsonDecode(res.body);
        _errorMessage = data['message'] ?? '프로필 업데이트 실패';
        return _errorMessage;
      }
    } catch (e) {
      _errorMessage = '서버 연결 실패';
      return _errorMessage;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
    if (kDebugMode) print('유저 정보 초기화됨');
  }

  void loadUser(User user) {
    _user = user;
    notifyListeners();
    if (kDebugMode) print('유저 로드됨: ${user.username}');
  }
}