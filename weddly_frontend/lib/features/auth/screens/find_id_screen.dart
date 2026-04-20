import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/weddly_colors.dart';
import '../../../core/widgets/auth_input_field.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/weddly_app_bar.dart';
import '../../../core/widgets/weddly_footer.dart';
import 'reset_pw_screen.dart';

class FindIdScreen extends StatefulWidget {
  const FindIdScreen({super.key});

  @override
  State<FindIdScreen> createState() => _FindIdScreenState();
}

class _FindIdScreenState extends State<FindIdScreen> {
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();

  String _nameMsg  = '';
  String _emailMsg = '';
  FieldStatus _nameStatus  = FieldStatus.none;
  FieldStatus _emailStatus = FieldStatus.none;

  bool _showResult = false;
  String _resultId   = '';
  String _resultDate = '';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    bool valid = true;
    setState(() {
      if (_nameCtrl.text.trim().isEmpty) {
        _nameMsg = '이름을 입력해주세요.';
        _nameStatus = FieldStatus.error;
        valid = false;
      } else {
        _nameMsg = '';
        _nameStatus = FieldStatus.none;
      }
      final email = _emailCtrl.text.trim();
      if (email.isEmpty) {
        _emailMsg = '이메일을 입력해주세요.';
        _emailStatus = FieldStatus.error;
        valid = false;
      } else if (!email.contains('@') || !email.contains('.')) {
        _emailMsg = '올바른 이메일 형식을 입력해주세요.';
        _emailStatus = FieldStatus.error;
        valid = false;
      } else {
        _emailMsg = '';
        _emailStatus = FieldStatus.none;
      }
    });
    if (!valid) return;

    setState(() {
      _resultId   = 'wed***y';
      _resultDate = '가입일: 2025년 1월 15일';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WeddlyAuthAppBar(title: '아이디 찾기'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 16),
              child: Column(
                children: [
                  const SizedBox(height: 28),
                  _buildGuideSection(),
                  const SizedBox(height: 28),
                  AnimatedCrossFade(
                    firstChild: _buildForm(),
                    secondChild: _buildResult(),
                    crossFadeState: _showResult
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                  const SizedBox(height: 24),
                  _buildBottomLinks(),
                ],
              ),
            ),
          ),
          const WeddlyFooter(),
        ],
      ),
    );
  }

  Widget _buildGuideSection() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.1),
          ),
          child: const Icon(Icons.person_search_outlined,
              size: 32, color: AppColors.primary),
        ),
        const SizedBox(height: 16),
        Text(
          '아이디를 잊으셨나요?',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800, color: context.wTextPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          '가입 시 등록한 이름과 이메일 주소를 입력하면\n아이디를 확인할 수 있어요.',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 13,
              color: context.wTextLight,
              height: 1.6,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        AuthInputField(
          label: '이름',
          isRequired: true,
          hint: '이름을 입력하세요',
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
        AuthInputField(
          label: '이메일',
          isRequired: true,
          hint: '가입한 이메일을 입력하세요',
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
        const SizedBox(height: 8),
        GradientButton(text: '아이디 찾기', onPressed: _submit),
      ],
    );
  }

  Widget _buildResult() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: context.wSurfaceAlt,
            border: Border.all(color: context.wPartnerBorder, width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withOpacity(0.1),
                ),
                child: const Icon(Icons.check_circle_outline,
                    size: 28, color: AppColors.success),
              ),
              const SizedBox(height: 14),
              Text('회원님의 아이디',
                  style: TextStyle(
                      fontSize: 13, color: context.wTextLight, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              Text(_resultId,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: context.wTextPrimary,
                      letterSpacing: 1)),
              const SizedBox(height: 6),
              Text(_resultDate,
                  style: TextStyle(fontSize: 12, color: context.wTextMuted)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GradientButton(
          text: '로그인하러 가기',
          onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const ResetPwScreen())),
          child: Text('비밀번호 초기화',
              style: TextStyle(
                  fontSize: 13,
                  color: context.wTextLight,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: context.wTextLight)),
        ),
      ],
    );
  }

  Widget _buildBottomLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _link('로그인', () => Navigator.popUntil(context, (r) => r.isFirst)),
        _divider(),
        _link('회원가입', () => Navigator.pop(context)),
      ],
    );
  }

  Widget _link(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(text,
          style: TextStyle(
              fontSize: 13,
              color: context.wTextLight,
              fontWeight: FontWeight.w500)),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text('|', style: TextStyle(color: context.wTextMuted, fontSize: 12)),
    );
  }
}
