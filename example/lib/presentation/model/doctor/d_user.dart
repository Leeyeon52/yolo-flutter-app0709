// lib/presentation/model/doctor/d_user.dart

class User {
  final int? id; // user_id 또는 doctor_id
  final String registerId;
  final String? name;
  final String? gender;
  final String? birth;
  final String? phone;
  final String? role;

  User({
    required this.id,
    required this.registerId,
    this.name,
    this.gender,
    this.birth,
    this.phone,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'] as int? ?? json['doctor_id'] as int?,
      registerId: json['register_id'],
      name: json['name'],
      gender: json['gender'],
      birth: json['birth'],
      phone: json['phone'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'register_id': registerId,
      'name': name,
      'gender': gender,
      'birth': birth,
      'phone': phone,
      'role': role,
    };
  }

  // Doctor 여부를 확인하는 편의 getter
  bool get isDoctor => role == 'D';
}
