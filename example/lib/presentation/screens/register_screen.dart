import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // TextInputFormatter를 위해 추가
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '/presentation/viewmodel/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedGender = 'M';
  final _birthController = TextEditingController();
  final _phoneController = TextEditingController();
  final _registerIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String _selectedRole = 'P'; // 기본값은 환자

  bool _isDuplicate = true;
  bool _isIdChecked = false;

  @override
  void dispose() {
    _nameController.dispose();
    _birthController.dispose();
    _phoneController.dispose();
    _registerIdController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _checkDuplicateId() async {
    final viewModel = context.read<AuthViewModel>();
    final id = _registerIdController.text.trim();

    if (id.length < 4) {
      _showSnack('아이디는 최소 4자 이상이어야 합니다');
      setState(() {
        _isIdChecked = false;
        _isDuplicate = true;
      });
      return;
    }

    // ✅ role을 함께 전달하여 중복 확인
    final exists = await viewModel.checkUserIdDuplicate(id, _selectedRole);
    setState(() {
      _isIdChecked = true;
      _isDuplicate = (exists ?? true);
    });

    if (viewModel.duplicateCheckErrorMessage != null) {
      _showSnack(viewModel.duplicateCheckErrorMessage!);
    } else if (exists == false) {
      _showSnack('사용 가능한 아이디입니다');
    } else {
      _showSnack('이미 사용 중인 아이디입니다');
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      _showSnack('모든 필드를 올바르게 입력해주세요.');
      return;
    }

    if (!_isIdChecked || _isDuplicate) {
      _showSnack('아이디 중복 확인을 완료해주세요.');
      return;
    }

    final userData = {
      'name': _nameController.text.trim(),
      'gender': _selectedGender,
      'birth': _birthController.text.trim(),
      'phone': _phoneController.text.trim(),
      'username': _registerIdController.text.trim(), // ✅ 백엔드에서 'username'으로 받으므로 유지
      'password': _passwordController.text.trim(),
      'role': _selectedRole,
    };

    final viewModel = context.read<AuthViewModel>();
    final error = await viewModel.registerUser(userData);

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
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedRole = value;
                // ✅ 역할 변경 시 아이디 중복 확인 상태 초기화 및 아이디 필드 비우기
                _isIdChecked = false;
                _isDuplicate = true;
                _registerIdController.clear(); // 아이디 입력 필드 초기화
                authViewModel.clearDuplicateCheckErrorMessage(); // AuthViewModel에 이 메서드가 있다고 가정
              });
            },
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
              // ✅ 생년월일 형식 자동 변환 추가
              _buildTextField(_birthController, '생년월일 (YYYY-MM-DD)', keyboardType: TextInputType.datetime, inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                LengthLimitingTextInputFormatter(10),
                _DateFormatter(),
              ]),
              // ✅ 전화번호 형식 자동 변환 추가
              _buildTextField(_phoneController, '전화번호', keyboardType: TextInputType.phone, inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
                _PhoneNumberFormatter(),
              ]),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      _registerIdController,
                      '아이디 (4자 이상)',
                      minLength: 4,
                      onChanged: (_) {
                        setState(() {
                          _isIdChecked = false;
                          _isDuplicate = true;
                          authViewModel.clearDuplicateCheckErrorMessage(); // 에러 메시지 초기화
                        });
                      },
                      errorText: authViewModel.duplicateCheckErrorMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: authViewModel.isCheckingUserId ? null : _checkDuplicateId,
                    child: authViewModel.isCheckingUserId
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('중복확인'),
                  ),
                ],
              ),
              _buildTextField(_passwordController, '비밀번호 (6자 이상)', isPassword: true, minLength: 6),
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
    int? minLength,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
    String? errorText,
    List<TextInputFormatter>? inputFormatters, // ✅ inputFormatters 파라미터 추가
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        onChanged: onChanged,
        inputFormatters: inputFormatters, // ✅ inputFormatters 적용
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
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

// ✅ 생년월일 형식 자동 변환 (YYYY-MM-DD)
class _DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll('-', '');
    if (text.length > 8) {
      return oldValue;
    }
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 3 || i == 5) {
        buffer.write('-');
      }
    }
    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

// ✅ 전화번호 형식 자동 변환 (010-XXXX-XXXX)
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll('-', '');
    if (text.length > 11) {
      return oldValue;
    }
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 2 || i == 6) {
        if (text.length > i + 1) {
          buffer.write('-');
        }
      }
    }
    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
