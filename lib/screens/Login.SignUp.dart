import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import '../models/User.dart';

class User {
  final int id;
  final String name;
  final String account;
  final String? img;

  User({required this.id, required this.name, required this.account, this.img});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      account: json['account'] as String,
      img: json['img'] as String?,
    );
  }

  static User empty() => User(id: 0, name: '', account: '');
}

class LosingSignUp extends StatefulWidget {
  const LosingSignUp({super.key});

  @override
  State<LosingSignUp> createState() => _LosingSignUpState();
}

class _LosingSignUpState extends State<LosingSignUp> {
  // TextEditingController는 React의 useRef와 유사하게 입력 필드의 값을 제어합니다.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // 상태 변수들
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;
  bool _acceptTerms = false;
  String _passwordMismatchMessage = ''; // 비밀번호 불일치 메시지

  @override
  void initState() {
    super.initState();
    // 비밀번호 필드 변경 감지 및 불일치 메시지 업데이트 (React의 useEffect와 유사)
    _passwordController.addListener(_validatePasswords);
    _confirmPasswordController.addListener(_validatePasswords);
  }

  @override
  void dispose() {
    // 컨트롤러는 위젯이 dispose될 때 반드시 해제해야 메모리 누수를 방지합니다.
    _nameController.dispose();
    _accountController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePasswords() {
    setState(() {
      if (_confirmPasswordController.text.isNotEmpty &&
          _passwordController.text != _confirmPasswordController.text) {
        _passwordMismatchMessage = '비밀번호가 일치하지 않습니다.';
      } else {
        _passwordMismatchMessage = '';
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_acceptTerms) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('회원가입 오류'),
            content: const Text('이용약관 및 개인정보 처리방침에 동의해야 합니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
      return;
    }
    if (!_passwordMismatchMessage.isNotEmpty && _passwordController.text.isEmpty) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('회원가입 오류'),
            content: Text("비밀번호가 일치하지 않거나, 비밀번호를 입력하지 않았습니다."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
      return;
    }
    setState(() {
      _isLoading = true; // 로딩 상태 시작
    });
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8888/api/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text,
          'account': _accountController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      final responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('회원 가입 완료!'),
              content: const Text('이메일 인증을 해주세요.\n이메일 인증 후 로그인 가능합니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go('/login'); // 로그인 페이지로 이동
                  },
                  child: const Text('확인'),
                ),
              ],
            ),
          );
        }
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('회원가입 실패'),
              content: Text(response.body),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('확인'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('오류 발생'),
            content: Text('네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 제목 및 설명
                Column(
                  children: [
                    const Text(
                      '회원가입',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'MusicShare와 함께 음악을 공유하세요',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // 회원가입 폼 카드
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 이름 입력 필드
                        _buildTextField(
                          controller: _nameController,
                          labelText: '이름',
                          hintText: '이름을 입력하세요',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),

                        // 아이디 입력 필드
                        _buildTextField(
                          controller: _accountController,
                          labelText: '아이디',
                          hintText: '아이디를 입력하세요',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),

                        // 이메일 입력 필드
                        _buildTextField(
                          controller: _emailController,
                          labelText: '이메일',
                          hintText: '이메일을 입력하세요',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),

                        // 비밀번호 입력 필드
                        _buildPasswordField(
                          controller: _passwordController,
                          labelText: '비밀번호',
                          hintText: '비밀번호를 입력하세요',
                          showPassword: _showPassword,
                          onToggleVisibility: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // 비밀번호 확인 입력 필드
                        _buildPasswordField(
                          controller: _confirmPasswordController,
                          labelText: '비밀번호 확인',
                          hintText: '비밀번호를 다시 입력하세요',
                          showPassword: _showConfirmPassword,
                          onToggleVisibility: () {
                            setState(() {
                              _showConfirmPassword = !_showConfirmPassword;
                            });
                          },
                        ),
                        if (_passwordMismatchMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _passwordMismatchMessage,
                              style: const TextStyle(color: Colors.red, fontSize: 13),
                            ),
                          ),
                        const SizedBox(height: 24),

                        // 약관 동의 체크박스
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 24, // Checkbox 크기 조절
                              height: 24,
                              child: Checkbox(
                                value: _acceptTerms,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _acceptTerms = newValue ?? false;
                                  });
                                },
                                activeColor: Colors.blue[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '이용약관과 개인정보 처리방침에 동의합니다.',
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // 회원가입 버튼
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            '회원가입',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // 이미 계정이 있으신가요? 링크
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '이미 계정이 있으신가요? ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        context.go('/login'); // 로그인 페이지로 이동
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        '로그인',
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 재사용 가능한 TextField 위젯 빌더
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue.shade500, width: 2),
            ),
          ),
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  // 재사용 가능한 비밀번호 TextField 위젯 빌더
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required bool showPassword,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            TextField(
              controller: controller,
              obscureText: !showPassword,
              decoration: InputDecoration(
                hintText: hintText,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue.shade500, width: 2),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            IconButton(
              icon: Icon(
                showPassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
              onPressed: onToggleVisibility,
            ),
          ],
        ),
      ],
    );
  }
}