import 'd_patient.dart'; // Patient 모델 임포트

class ConsultationRecord {
  final int id;
  final int patientId;
  final int doctorId;
  final int? appointmentId;
  final String consultationDate;
  final String consultationTime;
  final String? chiefComplaint;
  final String? diagnosis;
  final String? treatmentPlan;
  final String? maskingResult;
  final String? aiResult;
  final String? doctorModifications;
  final Patient? patientInfo; // 진료 기록 조회 시 함께 반환될 환자 정보

  ConsultationRecord({
    required this.id,
    required this.patientId,
    required this.doctorId,
    this.appointmentId,
    required this.consultationDate,
    required this.consultationTime,
    this.chiefComplaint,
    this.diagnosis,
    this.treatmentPlan,
    this.maskingResult,
    this.aiResult,
    this.doctorModifications,
    this.patientInfo,
  });

  factory ConsultationRecord.fromJson(Map<String, dynamic> json) {
    return ConsultationRecord(
      id: json['id'] as int,
      patientId: json['patientId'] as int,
      doctorId: json['doctorId'] as int,
      appointmentId: json['appointmentId'] as int?,
      consultationDate: json['consultationDate'] as String,
      consultationTime: json['consultationTime'] as String,
      chiefComplaint: json['chiefComplaint'] as String?,
      diagnosis: json['diagnosis'] as String?,
      treatmentPlan: json['treatmentPlan'] as String?,
      maskingResult: json['maskingResult'] as String?,
      aiResult: json['aiResult'] as String?,
      doctorModifications: json['doctorModifications'] as String?,
      patientInfo: json['patientInfo'] != null
          ? Patient.fromJson(json['patientInfo'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'appointmentId': appointmentId,
      'consultationDate': consultationDate,
      'consultationTime': consultationTime,
      'chiefComplaint': chiefComplaint,
      'diagnosis': diagnosis,
      'treatmentPlan': treatmentPlan,
      'maskingResult': maskingResult,
      'aiResult': aiResult,
      'doctorModifications': doctorModifications,
      'patientInfo': patientInfo?.toJson(),
    };
  }
}
