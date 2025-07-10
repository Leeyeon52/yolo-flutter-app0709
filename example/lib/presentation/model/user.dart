class User {
  final int id; // 백엔드의 id에 해당
  final String username;
  final String? name; // nullable String
  final String? gender; // nullable String
  final String? birth; // nullable String
  final String? phone; // nullable String
  final String? address; // nullable String
  final String? role; // ✅ 추가된 역할 필드 ('P' 또는 'D')

  User({
    required this.id,
    required this.username,
    this.name,
    this.gender,
    this.birth,
    this.phone,
    this.address,
    this.role, // ✅ 추가
  });

  // JSON 데이터로부터 User 객체를 생성하는 팩토리 생성자
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      birth: json['birth'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      role: json['role'] as String?, // ✅ 추가
    );
  }

  // User 객체를 JSON으로 변환하는 메서드 (필요시)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'gender': gender,
      'birth': birth,
      'phone': phone,
      'address': address,
      'role': role, // ✅ 추가
    };
  }
}
