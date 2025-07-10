import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// ✅ 현재 프로젝트의 새 경로에 맞게 임포트
import '../../viewmodel/doctor/d_patient_viewmodel.dart'; // DPatientViewModel 임포트
import '../../viewmodel/auth_viewmodel.dart'; // ✅ DAuthViewModel 대신 AuthViewModel 임포트
import '../doctor/d_patient_detail_screen.dart'; // DPatientDetailScreen 임포트
import '../../model/doctor/d_patient.dart'; // DPatient 모델 임포트


class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPatients();
    });
  }

  Future<void> _loadPatients() async {
    // ✅ AuthViewModel과 DPatientViewModel 사용
    final authViewModel = context.read<AuthViewModel>();
    final patientViewModel = context.read<DPatientViewModel>();

    // ✅ user.id가 nullable이므로 null 체크 추가
    if (authViewModel.currentUser != null && authViewModel.currentUser!.isDoctor && authViewModel.currentUser!.id != null) {
      await patientViewModel.fetchPatients(authViewModel.currentUser!.id!); // ✅ non-nullable로 사용
      if (patientViewModel.errorMessage != null) {
        _showSnack('환자 목록 로드 오류: ${patientViewModel.errorMessage}');
      }
    } else {
      _showSnack('의사 계정으로 로그인해야 환자 목록을 볼 수 있습니다.');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(15),
        backgroundColor: Colors.blueGrey[700],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ DPatientViewModel과 AuthViewModel 사용
    final patientViewModel = context.watch<DPatientViewModel>();
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('환자 목록', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddPatientDialog(context, authViewModel.currentUser?.id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadPatients(),
          ),
        ],
      ),
      body: patientViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : patientViewModel.errorMessage != null
              ? Center(child: Text('오류: ${patientViewModel.errorMessage}'))
              : patientViewModel.patients.isEmpty
                  ? const Center(child: Text('등록된 환자가 없습니다.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: patientViewModel.patients.length,
                      itemBuilder: (context, index) {
                        final patient = patientViewModel.patients[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueAccent.withOpacity(0.1),
                              child: const Icon(Icons.person, color: Colors.blueAccent),
                            ),
                            title: Text(
                              patient.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('생년월일: ${patient.dateOfBirth}'),
                                Text('성별: ${patient.gender}'),
                                if (patient.phoneNumber != null && patient.phoneNumber!.isNotEmpty)
                                  Text('연락처: ${patient.phoneNumber}'),
                                if (patient.address != null && patient.address!.isNotEmpty)
                                  Text('주소: ${patient.address}'),
                              ],
                            ),
                            onTap: () {
                              // ✅ PatientDetailScreen으로 이동하며 patientId 전달 (null 체크 추가)
                              if (patient.id != null) {
                                context.go('/patient_detail/${patient.id}');
                              } else {
                                _showSnack('환자 ID를 찾을 수 없습니다.');
                              }
                            },
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.grey),
                              onPressed: () {
                                _showSnack('${patient.name} 환자 정보 수정 (미구현)');
                              },
                            ),
                          ),
                        );
                      },
                    ),
    );
  }

  void _showAddPatientDialog(BuildContext context, int? doctorId) {
    if (doctorId == null) {
      _showSnack('의사 ID를 찾을 수 없습니다. 다시 로그인해주세요.');
      return;
    }

    final _nameController = TextEditingController();
    final _dobController = TextEditingController();
    final _genderController = TextEditingController();
    final _phoneController = TextEditingController();
    final _addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('새 환자 추가'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: '이름'),
                ),
                TextField(
                  controller: _dobController,
                  decoration: const InputDecoration(labelText: '생년월일 (YYYY-MM-DD)'),
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  controller: _genderController,
                  decoration: const InputDecoration(labelText: '성별 (Male/Female/Other)'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: '핸드폰 번호'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: '주소'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () async {
                final patientViewModel = context.read<DPatientViewModel>();
                final success = await patientViewModel.addPatient(
                  doctorId: doctorId,
                  name: _nameController.text,
                  dateOfBirth: _dobController.text,
                  gender: _genderController.text,
                  phoneNumber: _phoneController.text.isNotEmpty ? _phoneController.text : null,
                  address: _addressController.text.isNotEmpty ? _addressController.text : null,
                );

                if (Navigator.of(dialogContext).canPop()) {
                  Navigator.of(dialogContext).pop();
                }

                if (success) {
                  _showSnack('환자가 성공적으로 추가되었습니다!');
                  _loadPatients(); // 환자 추가 후 목록 새로고침
                } else {
                  _showSnack('환자 추가 실패: ${patientViewModel.errorMessage}');
                }
              },
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }
}
