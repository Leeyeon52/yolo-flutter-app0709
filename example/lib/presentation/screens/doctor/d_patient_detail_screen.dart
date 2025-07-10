import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// ✅ 현재 프로젝트 경로에 맞게 임포트
import '/presentation/viewmodel/auth_viewmodel.dart'; // ✅ DAuthViewModel 대신 AuthViewModel 임포트
import '/presentation/viewmodel/doctor/d_patient_viewmodel.dart'; // DPatientViewModel 임포트
import '/presentation/viewmodel/doctor/d_consultation_viewmodel.dart'; // DConsultationViewModel 임포트
import '/presentation/model/doctor/d_patient.dart'; // DPatient 모델 임포트
import '/presentation/model/doctor/d_consultation_record.dart'; // DConsultationRecord 모델 임포트


class PatientDetailScreen extends StatefulWidget {
  final int patientId;

  const PatientDetailScreen({required this.patientId, super.key});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  Patient? _patient;
  List<ConsultationRecord> _consultations = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPatientAndConsultations();
    });
  }

  Future<void> _fetchPatientAndConsultations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // ✅ ViewModel 타입을 AuthViewModel로 변경
    final patientViewModel = context.read<DPatientViewModel>();
    final consultationViewModel = context.read<DConsultationViewModel>();
    final authViewModel = context.read<AuthViewModel>(); // AuthViewModel 사용

    try {
      // 1. 환자 정보 가져오기
      await patientViewModel.fetchPatient(widget.patientId);
      if (patientViewModel.errorMessage != null) {
        throw Exception(patientViewModel.errorMessage);
      }
      _patient = patientViewModel.currentPatient;

      // 2. 해당 환자의 진료 기록 가져오기
      if (authViewModel.currentUser != null && authViewModel.currentUser!.isDoctor && authViewModel.currentUser!.id != null) {
        await consultationViewModel.fetchConsultationRecordsByPatient(
            widget.patientId, authViewModel.currentUser!.id!);
        if (consultationViewModel.errorMessage != null) {
          throw Exception(consultationViewModel.errorMessage);
        }
        _consultations = consultationViewModel.patientConsultations;
      } else {
        throw Exception('의사 계정으로 로그인해야 환자 진료 기록을 볼 수 있습니다.');
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black54))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('환자 상세 정보')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('환자 상세 정보')),
        body: Center(child: Text('오류: $_errorMessage')),
      );
    }

    if (_patient == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('환자 상세 정보')),
        body: const Center(child: Text('환자 정보를 찾을 수 없습니다.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${_patient!.name} 환자 상세 정보', style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 환자 기본 정보 섹션
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('환자 기본 정보', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 10),
                    _buildInfoRow('이름', _patient!.name),
                    _buildInfoRow('생년월일', _patient!.dateOfBirth),
                    _buildInfoRow('성별', _patient!.gender),
                    _buildInfoRow('연락처', _patient!.phoneNumber ?? 'N/A'),
                    _buildInfoRow('주소', _patient!.address ?? 'N/A'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('진료 기록', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            _consultations.isEmpty
                ? const Center(child: Text('등록된 진료 기록이 없습니다.'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _consultations.length,
                    itemBuilder: (context, index) {
                      final record = _consultations[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: Text('${record.consultationDate} ${record.consultationTime}'),
                          subtitle: Text('주소: ${record.chiefComplaint ?? '없음'}'),
                          onTap: () {
                            context.go('/telemedicine_detail/${record.id}');
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
