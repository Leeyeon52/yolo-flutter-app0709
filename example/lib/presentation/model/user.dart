class User {
  final int id; // 백엔드의 id에 해당
  final String username;
  final String? name; // nullable String
  final String? gender; // nullable String
  final String? birth; // nullable String
  final String? phone; // nullable String
  final String? address; // nullable String

  User({
    required this.id,
    required this.username,
    this.name,
    this.gender,
    this.birth,
    this.phone,
    this.address,
  });

  // JSON 데이터로부터 User 객체를 생성하는 팩토리 생성자
  factory User.fromJson(Map<String, dynamic> json) {
    // 백엔드 응답이 {"id": ..., "username": ...} 형태이므로,
    // json['id']와 json['username']을 직접 참조해야 합니다.
    return User(
      id: json['id'] as int, // ✅ 이 부분이 json['userId']가 아닌 json['id']여야 합니다.
      username: json['username'] as String, // 백엔드 응답의 'username'을 String 타입으로 파싱
      // 로그인 응답에 없는 필드들은 null-safe하게 처리
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      birth: json['birth'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
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
    };
  }
}