import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/auth_input_field.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/weddly_app_bar.dart';
import '../../../core/widgets/weddly_footer.dart';

enum _Role { none, groom, bride }

enum _PwStrength { none, weak, medium, strong }

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // ── Controllers
  final _idCtrl    = TextEditingController();
  final _nameCtrl  = TextEditingController();
  final _pwCtrl    = TextEditingController();
  final _pw2Ctrl   = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  // ── State
  bool _pwVisible  = false;
  bool _pw2Visible = false;
  bool _idChecked  = false;

  _Role _role = _Role.none;
  _PwStrength _strength = _PwStrength.none;

  bool _agreeAll       = false;
  bool _agreeService   = false;
  bool _agreePrivacy   = false;
  bool _agreeMarketing = false;

  // ── 필드 메시지
  String _idMsg    = '';
  String _nameMsg  = '';
  String _pwMsg    = '';
  String _pw2Msg   = '';
  String _emailMsg = '';
  String _phoneMsg = '';
  String _roleMsg  = '';

  FieldStatus _idStatus    = FieldStatus.none;
  FieldStatus _nameStatus  = FieldStatus.none;
  FieldStatus _pwStatus    = FieldStatus.none;
  FieldStatus _pw2Status   = FieldStatus.none;
  FieldStatus _emailStatus = FieldStatus.none;
  FieldStatus _phoneStatus = FieldStatus.none;

  @override
  void dispose() {
    _idCtrl.dispose();
    _nameCtrl.dispose();
    _pwCtrl.dispose();
    _pw2Ctrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  // ── 중복 확인
  void _checkId() {
    final id = _idCtrl.text.trim();
    if (id.isEmpty) {
      setState(() {
        _idMsg = '아이디를 입력해주세요.';
        _idStatus = FieldStatus.error;
        _idChecked = false;
      });
      return;
    }
    if (id.length < 4) {
      setState(() {
        _idMsg = '아이디는 4자 이상이어야 합니다.';
        _idStatus = FieldStatus.error;
        _idChecked = false;
      });
      return;
    }
    // 시뮬레이션: 사용 가능
    setState(() {
      _idMsg = '사용 가능한 아이디입니다.';
      _idStatus = FieldStatus.success;
      _idChecked = true;
    });
  }

  // ── 비밀번호 강도 계산
  _PwStrength _calcStrength(String pw) {
    if (pw.isEmpty) return _PwStrength.none;
    int score = 0;
    if (pw.length >= 8) score++;
    if (pw.contains(RegExp(r'[A-Za-z]'))) score++;
    if (pw.contains(RegExp(r'[0-9]'))) score++;
    if (pw.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) score++;
    if (score <= 2) return _PwStrength.weak;
    if (score == 3) return _PwStrength.medium;
    return _PwStrength.strong;
  }

  void _onPwChanged(String value) {
    final s = _calcStrength(value);
    setState(() {
      _strength = s;
      if (value.isEmpty) {
        _pwMsg = '';
        _pwStatus = FieldStatus.none;
      } else if (s == _PwStrength.weak) {
        _pwMsg = '비밀번호가 너무 약합니다. (8자 이상, 영문+숫자+특수문자)';
        _pwStatus = FieldStatus.error;
      } else {
        _pwMsg = '';
        _pwStatus = FieldStatus.success;
      }
      // 비밀번호 확인도 재검증
      if (_pw2Ctrl.text.isNotEmpty) _checkPwMatch();
    });
  }

  void _checkPwMatch() {
    if (_pw2Ctrl.text == _pwCtrl.text) {
      _pw2Msg = '비밀번호가 일치합니다.';
      _pw2Status = FieldStatus.success;
    } else {
      _pw2Msg = '비밀번호가 일치하지 않습니다.';
      _pw2Status = FieldStatus.error;
    }
  }

  void _onPw2Changed(String value) {
    setState(() => _checkPwMatch());
  }

  // ── 전체 동의 토글
  void _toggleAgreeAll(bool? value) {
    final v = value ?? false;
    setState(() {
      _agreeAll       = v;
      _agreeService   = v;
      _agreePrivacy   = v;
      _agreeMarketing = v;
    });
  }

  void _updateAgreeAll() {
    setState(() => _agreeAll = _agreeService && _agreePrivacy && _agreeMarketing);
  }

  // ── 약관 모달
  void _showTermsModal(BuildContext context, String title, String content, String agreeKey) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close, size: 20, color: AppColors.textLight),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.borderLight),
            // 본문
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Text(content,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textMedium, height: 1.7)),
              ),
            ),
            const Divider(height: 1, color: AppColors.borderLight),
            // 푸터
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('닫기',
                          style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GradientButton(
                      text: '동의하고 닫기',
                      height: 44,
                      onPressed: () {
                        setState(() {
                          if (agreeKey == 'service') _agreeService = true;
                          if (agreeKey == 'privacy') _agreePrivacy = true;
                          _updateAgreeAll();
                        });
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 폼 제출
  void _submit() {
    bool valid = true;
    setState(() {
      if (!_idChecked) {
        _idMsg = '아이디 중복 확인을 해주세요.';
        _idStatus = FieldStatus.error;
        valid = false;
      }
      if (_nameCtrl.text.trim().isEmpty) {
        _nameMsg = '이름을 입력해주세요.';
        _nameStatus = FieldStatus.error;
        valid = false;
      }
      if (_strength == _PwStrength.none || _strength == _PwStrength.weak) {
        _pwMsg = '8자 이상, 영문+숫자+특수문자를 포함해주세요.';
        _pwStatus = FieldStatus.error;
        valid = false;
      }
      if (_pw2Ctrl.text != _pwCtrl.text) {
        _pw2Msg = '비밀번호가 일치하지 않습니다.';
        _pw2Status = FieldStatus.error;
        valid = false;
      }
      if (!_emailCtrl.text.contains('@')) {
        _emailMsg = '올바른 이메일 형식을 입력해주세요.';
        _emailStatus = FieldStatus.error;
        valid = false;
      }
      if (_phoneCtrl.text.replaceAll('-', '').length < 10) {
        _phoneMsg = '전화번호를 정확히 입력해주세요.';
        _phoneStatus = FieldStatus.error;
        valid = false;
      }
      if (_role == _Role.none) {
        _roleMsg = '신랑 또는 신부를 선택해주세요.';
        valid = false;
      }
      if (!_agreeService || !_agreePrivacy) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('필수 약관에 동의해주세요.')));
        valid = false;
      }
    });
    if (!valid) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('회원가입 API 연동 예정')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WeddlyAuthAppBar(title: '회원가입'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildStepBar(),
                  const SizedBox(height: 24),
                  _buildIdField(),
                  AuthInputField(
                    label: '이름',
                    isRequired: true,
                    hint: '실명을 입력하세요',
                    controller: _nameCtrl,
                    prefixIcon: Icons.person_outline,
                    maxLength: 10,
                    messageText: _nameMsg,
                    fieldStatus: _nameStatus,
                    onChanged: (_) => setState(() {
                      _nameMsg = '';
                      _nameStatus = FieldStatus.none;
                    }),
                  ),
                  _buildPasswordField(),
                  AuthInputField(
                    label: '비밀번호 확인',
                    isRequired: true,
                    hint: '비밀번호를 다시 입력하세요',
                    controller: _pw2Ctrl,
                    prefixIcon: Icons.shield_outlined,
                    obscureText: !_pw2Visible,
                    maxLength: 30,
                    messageText: _pw2Msg,
                    fieldStatus: _pw2Status,
                    onChanged: _onPw2Changed,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _pw2Visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.textPlaceholder,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _pw2Visible = !_pw2Visible),
                    ),
                  ),
                  AuthInputField(
                    label: '이메일',
                    isRequired: true,
                    hint: 'example@email.com',
                    controller: _emailCtrl,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    messageText: _emailMsg,
                    fieldStatus: _emailStatus,
                    onChanged: (_) => setState(() {
                      _emailMsg = '';
                      _emailStatus = FieldStatus.none;
                    }),
                  ),
                  AuthInputField(
                    label: '전화번호',
                    isRequired: true,
                    hint: '010-0000-0000',
                    controller: _phoneCtrl,
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [PhoneInputFormatter()],
                    maxLength: 13,
                    messageText: _phoneMsg,
                    fieldStatus: _phoneStatus,
                    onChanged: (_) => setState(() {
                      _phoneMsg = '';
                      _phoneStatus = FieldStatus.none;
                    }),
                  ),
                  _buildRoleSelector(),
                  const SizedBox(height: 20),
                  _buildTermsSection(),
                  const SizedBox(height: 24),
                  GradientButton(text: '회원가입', onPressed: _submit),
                  const SizedBox(height: 16),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: '이미 계정이 있으신가요?  ',
                        style: const TextStyle(fontSize: 13, color: AppColors.textLight),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text('로그인',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const WeddlyFooter(),
        ],
      ),
    );
  }

  // ── 스텝 바
  Widget _buildStepBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StepDot(number: 1, label: '계정 정보', isActive: true),
        _StepLine(isActive: true),
        _StepDot(number: 2, label: '개인 정보', isActive: true),
        _StepLine(isActive: false),
        _StepDot(number: 3, label: '완료', isActive: false),
      ],
    );
  }

  // ── 아이디 필드 (중복확인 버튼 포함)
  Widget _buildIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: '아이디',
            style: TextStyle(
                color: AppColors.textMedium, fontSize: 13, fontWeight: FontWeight.w600),
            children: [
              TextSpan(text: ' *', style: TextStyle(color: AppColors.primary)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _idCtrl,
                maxLength: 20,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textDark, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: '아이디 입력 (영문/숫자)',
                  prefixIcon: const Icon(Icons.person_outline,
                      color: AppColors.textPlaceholder, size: 20),
                  counterText: '',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _idStatus == FieldStatus.error
                          ? AppColors.error
                          : _idStatus == FieldStatus.success
                              ? AppColors.success
                              : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _idStatus == FieldStatus.error ? AppColors.error : AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                onChanged: (_) => setState(() {
                  _idMsg = '';
                  _idStatus = FieldStatus.none;
                  _idChecked = false;
                }),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: _checkId,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: _idChecked ? AppColors.success : AppColors.primary,
                    width: 1.5,
                  ),
                  backgroundColor: _idChecked
                      ? const Color(0xFFE8F5E9)
                      : AppColors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: Text(
                  _idChecked ? '확인됨' : '중복확인',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _idChecked ? AppColors.success : AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 18,
          child: Padding(
            padding: const EdgeInsets.only(top: 3, left: 2),
            child: Text(
              _idMsg,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _idStatus == FieldStatus.error ? AppColors.error : AppColors.success,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── 비밀번호 필드 (강도 바 포함)
  Widget _buildPasswordField() {
    final strengthLabel = {
      _PwStrength.none:   '',
      _PwStrength.weak:   '약함 · 8자 이상, 영문+숫자+특수문자를 포함해주세요',
      _PwStrength.medium: '보통 · 특수문자를 추가하면 더 안전합니다',
      _PwStrength.strong: '강함 · 안전한 비밀번호입니다',
    };
    final strengthColor = {
      _PwStrength.none:   Colors.transparent,
      _PwStrength.weak:   AppColors.error,
      _PwStrength.medium: AppColors.warning,
      _PwStrength.strong: AppColors.success,
    };
    final strengthValue = {
      _PwStrength.none:   0.0,
      _PwStrength.weak:   0.33,
      _PwStrength.medium: 0.66,
      _PwStrength.strong: 1.0,
    };

    // 테두리 색상
    final borderColor = _pwStatus == FieldStatus.error
        ? AppColors.error
        : _pwStatus == FieldStatus.success
            ? AppColors.success
            : AppColors.border;
    final focusBorderColor = _pwStatus == FieldStatus.error
        ? AppColors.error
        : _pwStatus == FieldStatus.success
            ? AppColors.success
            : AppColors.primary;

    // 표시 메시지: 타이핑 중 → 강도 레이블 / 제출 에러(빈 필드) → _pwMsg
    final displayMsg = _strength != _PwStrength.none
        ? strengthLabel[_strength]!
        : _pwMsg;
    final displayColor = _strength != _PwStrength.none
        ? strengthColor[_strength]!
        : AppColors.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 라벨
        RichText(
          text: const TextSpan(
            text: '비밀번호',
            style: TextStyle(
                color: AppColors.textMedium, fontSize: 13, fontWeight: FontWeight.w600),
            children: [
              TextSpan(text: ' *', style: TextStyle(color: AppColors.primary)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        // 입력창 (AuthInputField 대신 직접 구성 → 고정 메시지 슬롯 제거)
        TextField(
          controller: _pwCtrl,
          obscureText: !_pwVisible,
          maxLength: 30,
          onChanged: _onPwChanged,
          style: const TextStyle(
              color: AppColors.textDark, fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: '8자 이상, 영문+숫자+특수문자',
            prefixIcon: const Icon(Icons.lock_outline,
                color: AppColors.textPlaceholder, size: 20),
            counterText: '',
            suffixIcon: IconButton(
              icon: Icon(
                _pwVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.textPlaceholder,
                size: 20,
              ),
              onPressed: () => setState(() => _pwVisible = !_pwVisible),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: focusBorderColor, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 6),
        // 강도 레이블: 입력 시 사이에 슬라이드인 (AnimatedSize)
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: displayMsg.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 6, left: 2, bottom: 2),
                  child: Text(
                    displayMsg,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: displayColor,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        // 강도 바 (항상 표시, 텍스트 없을 때는 입력창에 바로 붙음)
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: strengthValue[_strength]!),
            duration: const Duration(milliseconds: 350),
            builder: (_, v, __) => LinearProgressIndicator(
              value: v,
              minHeight: 4,
              backgroundColor: const Color(0xFFEEEEEE),
              valueColor: AlwaysStoppedAnimation<Color>(strengthColor[_strength]!),
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  // ── 역할 선택 카드
  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: '구분',
            style: TextStyle(
                color: AppColors.textMedium, fontSize: 13, fontWeight: FontWeight.w600),
            children: [
              TextSpan(text: ' *', style: TextStyle(color: AppColors.primary)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _RoleCard(
              emoji: '🤵',
              name: '신랑',
              sub: 'Groom',
              selected: _role == _Role.groom,
              onTap: () => setState(() { _role = _Role.groom; _roleMsg = ''; }),
            )),
            const SizedBox(width: 12),
            Expanded(child: _RoleCard(
              emoji: '👰',
              name: '신부',
              sub: 'Bride',
              selected: _role == _Role.bride,
              onTap: () => setState(() { _role = _Role.bride; _roleMsg = ''; }),
            )),
          ],
        ),
        if (_roleMsg.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 2),
            child: Text(_roleMsg,
                style: const TextStyle(fontSize: 12, color: AppColors.error)),
          ),
      ],
    );
  }

  // ── 약관 섹션
  Widget _buildTermsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          // 전체 동의
          _TermsRow(
            checked: _agreeAll,
            label: '전체 동의',
            isAll: true,
            onChanged: _toggleAgreeAll,
          ),
          Container(height: 1, color: AppColors.borderLight, margin: const EdgeInsets.symmetric(vertical: 10)),
          // 필수 서비스
          _TermsRow(
            checked: _agreeService,
            label: '[필수] 서비스 이용약관 동의',
            onChanged: (v) {
              setState(() { _agreeService = v ?? false; _updateAgreeAll(); });
            },
            onViewTap: () => _showTermsModal(
              context,
              '서비스 이용약관',
              _serviceTermsContent,
              'service',
            ),
          ),
          const SizedBox(height: 8),
          // 필수 개인정보
          _TermsRow(
            checked: _agreePrivacy,
            label: '[필수] 개인정보 처리방침 동의',
            onChanged: (v) {
              setState(() { _agreePrivacy = v ?? false; _updateAgreeAll(); });
            },
            onViewTap: () => _showTermsModal(
              context,
              '개인정보 처리방침',
              _privacyContent,
              'privacy',
            ),
          ),
          const SizedBox(height: 8),
          // 선택 마케팅
          _TermsRow(
            checked: _agreeMarketing,
            label: '[선택] 마케팅 정보 수신 동의',
            onChanged: (v) {
              setState(() { _agreeMarketing = v ?? false; _updateAgreeAll(); });
            },
          ),
        ],
      ),
    );
  }

  static const String _serviceTermsContent =
      '제1조 (목적)\n본 약관은 Weddly(이하 "회사")가 제공하는 웨딩 플래닝 서비스의 이용과 관련하여 회사와 회원 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.\n\n'
      '제2조 (정의)\n"회원"이란 회사의 서비스에 접속하여 본 약관에 동의하고 회사와 이용 계약을 체결한 자를 말합니다.\n\n'
      '제3조 (약관의 효력 및 변경)\n본 약관은 서비스 화면에 게시하거나 기타 방법으로 공지함으로써 효력이 발생합니다.\n\n'
      '제4조 (서비스의 제공)\n회사는 웨딩 일정·예산·업체 정보 제공, 신랑·신부 간 정보 공유 서비스 등을 제공합니다.';

  static const String _privacyContent =
      '1. 수집하는 개인정보 항목\n필수 항목: 아이디, 이름, 비밀번호, 이메일, 전화번호, 신랑/신부 구분\n자동 수집: 서비스 이용 기록, 접속 로그, 기기 정보\n\n'
      '2. 개인정보 수집 및 이용 목적\n회원 식별 및 본인 확인, 서비스 제공 및 계약 이행, 고객 상담 및 불만 처리\n\n'
      '3. 개인정보 보유 및 이용 기간\n회원 탈퇴 시까지 보유하며, 관련 법령에 따라 일정 기간 보관합니다.\n\n'
      '4. 개인정보의 제3자 제공\n원칙적으로 외부에 제공하지 않으며, 법령 규정 또는 동의 시 예외입니다.';
}

// ──────────────────────────────────────────
// 스텝 점
// ──────────────────────────────────────────
class _StepDot extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;

  const _StepDot({required this.number, required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : const Color(0xFFEEEEEE),
          ),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isActive ? AppColors.white : AppColors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isActive ? AppColors.primary : AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

// ── 스텝 연결선
class _StepLine extends StatelessWidget {
  final bool isActive;
  const _StepLine({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 2,
      margin: const EdgeInsets.only(bottom: 16),
      color: isActive ? AppColors.primary : const Color(0xFFEEEEEE),
    );
  }
}

// ──────────────────────────────────────────
// 역할 카드
// ──────────────────────────────────────────
class _RoleCard extends StatelessWidget {
  final String emoji;
  final String name;
  final String sub;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.emoji,
    required this.name,
    required this.sub,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: selected ? null : AppColors.backgroundAlt,
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFEEEEEE),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(name,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: selected ? AppColors.white : AppColors.textDark)),
            Text(sub,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: selected ? AppColors.white.withOpacity(0.8) : AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
// 약관 행
// ──────────────────────────────────────────
class _TermsRow extends StatelessWidget {
  final bool checked;
  final String label;
  final bool isAll;
  final ValueChanged<bool?> onChanged;
  final VoidCallback? onViewTap;

  const _TermsRow({
    required this.checked,
    required this.label,
    required this.onChanged,
    this.isAll = false,
    this.onViewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: checked,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isAll ? FontWeight.w700 : FontWeight.w500,
              color: isAll ? AppColors.textDark : AppColors.textMedium,
            ),
          ),
        ),
        if (onViewTap != null) ...[
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onViewTap,
            child: Text('보기',
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary)),
          ),
        ],
      ],
    );
  }
}
