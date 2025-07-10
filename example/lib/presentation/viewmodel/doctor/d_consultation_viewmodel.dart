import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kDebugMode;
import '/presentation/model/doctor/d_consultation_record.dart'; // d_consultation_record.dart 모델 임포트

class DConsultationViewModel with ChangeNotifier {
  final String _baseUrl;
  List<ConsultationRecord> _patientConsultations = [];
  String? _errorMessage;
  bool _isLoading = false;

  // ✅ 생성자에 required String baseUrl 추가
  DConsultationViewModel({required String baseUrl}) : _baseUrl = baseUrl;

  List<ConsultationRecord> get patientConsultations => _patientConsultations;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchConsultationRecordsByPatient(int patientId, int doctorId) async {
    _setLoading(true);
    _setErrorMessage(null);
    _patientConsultations = []; // 이전 데이터 초기화

    try {
      // 백엔드 API 엔드포인트에 맞게 URL 조정 필요
      final res = await http.get(Uri.parse('$_baseUrl/consultations/patient/$patientId/doctor/$doctorId'));

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        _patientConsultations = data.map((json) => ConsultationRecord.fromJson(json)).toList();
      } else {
        String message = '진료 기록 불러오기 실패 (Status: ${res.statusCode})';
        try {
          final decodedBody = json.decode(res.body);
          if (decodedBody is Map && decodedBody.containsKey('message')) {
            message = decodedBody['message'] as String;
          }
        } catch (e) {
          // Body was not valid JSON
        }
        _setErrorMessage(message);
      }
    } catch (e) {
      _setErrorMessage('네트워크 오류: ${e.toString()}');
      if (kDebugMode) {
        print('진료 기록 불러오기 중 네트워크 오류: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  // 여기에 진료 기록 추가, 수정, 삭제 등의 메서드를 추가할 수 있습니다.
}
