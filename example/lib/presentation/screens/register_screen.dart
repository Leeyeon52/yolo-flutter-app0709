import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart'; // ✅ 제거: Provider 사용하지 않음
// import 'package:ultralytics_yolo_example/features/doctor_portal/viewmodel/doctor_auth_viewmodel.dart'; // ✅ 제거: 해당 파일 사용하지 않음

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthController = TextEditingController();
  final _phoneController = TextEditingController();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _guardianPhoneController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedGender = 'M';
  String _selectedRole = 'P';

  bool _isDuplicate = true;
  bool _isIdChecked = false;
  bool _isCheckingId = false; // ✅ 추가: 중복 확인 로딩 상태를 위한 변수 (ViewModel 대체)
  String? _duplicateCheckErrorMessage; // ✅ 추가: 중복 확인 오류 메시지 (ViewModel 대체)

  @override
  void dispose() {
    _nameController.dispose();
    _birthController.dispose();
    _phoneController.dispose();
    _userIdController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _hospitalController.dispose();
    _guardianPhoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _checkDuplicateId() async {
    final id = _userIdController.text.trim();

    if (id.length < 4) {
      _showSnack('아이디는 최소 4자 이상이어야 합니다');
      setState(() {
        _isIdChecked = false;
        _isDuplicate = true;
        _duplicateCheckErrorMessage = '아이디는 최소 4자 이상이어야 합니다';
      });
      return;
    }

    setState(() {
      _isCheckingId = true; // 로딩 시작
      _duplicateCheckErrorMessage = null; // 이전 오류 메시지 초기화
    });

    // ✅ 가상 중복 확인 로직 (실제 서버 통신 없음)
    // 실제 앱에서는 여기에 서버 통신 로직이 들어갑니다.
    await Future.delayed(const Duration(seconds: 1)); // 1초 대기 (네트워크 지연 시뮬레이션)
    final bool exists = (id == 'testuser'); // 'testuser'는 이미 사용 중인 아이디라고 가정

    setState(() {
      _isCheckingId = false; // 로딩 종료
      _isIdChecked = true;
      _isDuplicate = exists;
    });

    if (exists) {
      _showSnack('이미 사용 중인 아이디입니다');
      setState(() {
        _duplicateCheckErrorMessage = '이미 사용 중인 아이디입니다';
      });
    } else {
      _showSnack('사용 가능한 아이디입니다');
      setState(() {
        _duplicateCheckErrorMessage = null;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      _showSnack('모든 필드를 올바르게 입력해주세요.');
      return;
    }

    if (!_isIdChecked) {
      _showSnack('아이디 중복 확인이 필요합니다.');
      return;
    }

    if (_isDuplicate) {
      _showSnack('이미 사용 중인 아이디입니다. 다른 아이디를 사용해주세요.');
      return;
    }

    final userData = {
      'name': _nameController.text.trim(),
      'gender': _selectedGender,
      'birth': _birthController.text.trim(),
      'phone': _phoneController.text.trim(),
      'register_id': _userIdController.text.trim(),
      'password': _passwordController.text.trim(),
      'email': 'temp_email_${DateTime.now().millisecondsSinceEpoch}@example.com',
      'role': _selectedRole,
      if (_selectedRole == 'D') 'hospital': _hospitalController.text.trim(),
      if (_selectedRole == 'P') 'address': _addressController.text.trim(),
    };

    // ✅ 가상 회원가입 로직 (실제 서버 통신 없음)
    // 실제 앱에서는 여기에 회원가입 서버 통신 로직이 들어갑니다.
    await Future.delayed(const Duration(seconds: 1)); // 1초 대기 (네트워크 지연 시뮬레이션)
    final String? error = null; // 일단 오류가 없다고 가정 (성공 시뮬레이션)

    if (error == null) {
      _showSnack('회원가입 성공!');
      context.go('/login');
    } else {
      _showSnack(error);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    // final authViewModel = Provider.of<DoctorAuthViewModel>(context); // ✅ 제거: ViewModel 사용하지 않음

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => setState(() {
              _selectedRole = value;
              _hospitalController.clear();
              _guardianPhoneController.clear();
              _addressController.clear();
            }),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'P', child: Text('환자')),
              const PopupMenuItem(value: 'D', child: Text('의사')),
            ],
            icon: const Icon(Icons.account_circle),
            tooltip: '사용자 유형 선택',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              _buildTextField(_nameController, '이름 (한글만)', keyboardType: TextInputType.name),
              _buildGenderSelector(),
              _buildTextField(
                _birthController,
                '생년월일 (YYYY-MM-DD)',
                maxLength: 10,
                keyboardType: TextInputType.number,
                inputFormatters: [DateInputFormatter()],
              ),
              _buildTextField(
                _phoneController,
                '전화번호 (숫자만)',
                maxLength: 11,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              if (_selectedRole == 'D') _buildTextField(_hospitalController, '소속 병원명'),
              if (_selectedRole == 'P')
                _buildTextField(
                  _addressController,
                  '주소',
                  keyboardType: TextInputType.text,
                ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      _userIdController,
                      '아이디 (최소 4자, 최대 20자)',
                      minLength: 4,
                      maxLength: 20,
                      onChanged: (_) {
                        setState(() {
                          _isIdChecked = false;
                          _isDuplicate = true;
                          _duplicateCheckErrorMessage = null; // 아이디 변경 시 메시지 초기화
                        });
                      },
                      errorText: _duplicateCheckErrorMessage, // ✅ 수정: ViewModel 대신 내부 변수 사용
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isCheckingId ? null : _checkDuplicateId, // ✅ 수정: ViewModel 대신 내부 변수 사용
                    child: _isCheckingId // ✅ 수정: ViewModel 대신 내부 변수 사용
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('중복확인'),
                  ),
                ],
              ),
              _buildTextField(_passwordController, '비밀번호 (최소 6자)', isPassword: true, minLength: 6),
              _buildTextField(_confirmController, '비밀번호 확인', isPassword: true),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text('회원가입 완료')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isPassword = false,
    int? maxLength,
    int? minLength,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
    List<TextInputFormatter>? inputFormatters,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        maxLength: maxLength,
        keyboardType: keyboardType,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          counterText: '',
          errorText: errorText,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return '$label을 입력해주세요';
          if (minLength != null && value.trim().length < minLength) {
            return '$label은 ${minLength}자 이상이어야 합니다';
          }
          if (label == '비밀번호 확인' && value != _passwordController.text) {
            return '비밀번호가 일치하지 않습니다';
          }
          if (label == '이름 (한글만)' && !RegExp(r'^[가-힣]+$').hasMatch(value)) {
            return '이름은 한글만 입력 가능합니다';
          }
          if (label == '전화번호 (숫자만)' && !RegExp(r'^\d{10,11}$').hasMatch(value)) {
            return '유효한 전화번호를 입력하세요 (숫자 10-11자리)';
          }
          if (label == '생년월일 (YYYY-MM-DD)') {
            final RegExp dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
            if (!dateRegex.hasMatch(value)) return '형식은 YYYY-MM-DD로 입력해주세요';

            try {
              final parts = value.split('-');
              final year = int.parse(parts[0]);
              final month = int.parse(parts[1]);
              final day = int.parse(parts[2]);

              final now = DateTime.now();
              final minYear = now.year - 150;
              final maxYear = now.year;

              if (year < minYear || year > maxYear) {
                return '생년월일은 ${minYear}년부터 ${maxYear}년까지만 입력 가능합니다';
              }
              if (month < 1 || month > 12) {
                return '월은 1~12 사이여야 합니다';
              }

              final date = DateTime(year, month, day);
              if (date.month != month || date.day != day) {
                return '존재하지 않는 날짜입니다';
              }

              if (date.isAfter(now)) {
                return '생년월일은 오늘 이후일 수 없습니다';
              }
            } catch (_) {
              return '올바른 생년월일을 입력해주세요';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Text('성별', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 16),
          Expanded(
            child: RadioListTile<String>(
              title: const Text('남'),
              value: 'M',
              groupValue: _selectedGender,
              onChanged: (value) => setState(() => _selectedGender = value!),
            ),
          ),
          Expanded(
            child: RadioListTile<String>(
              title: const Text('여'),
              value: 'F',
              groupValue: _selectedGender,
              onChanged: (value) => setState(() => _selectedGender = value!),
            ),
          ),
        ],
      ),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');
    String newText = '';

    for (int i = 0; i < text.length && i < 8; i++) {
      if (i == 4 || i == 6) newText += '-';
      newText += text[i];
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}