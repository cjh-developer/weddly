import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/weddly_colors.dart';
import '../../../core/widgets/auth_input_field.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/weddly_app_bar.dart';
import '../../../core/widgets/weddly_footer.dart';

class ResetPwScreen extends StatefulWidget {
  const ResetPwScreen({super.key});

  @override
  State<ResetPwScreen> createState() => _ResetPwScreenState();
}

class _ResetPwScreenState extends State<ResetPwScreen> {
  final _idCtrl    = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  String _idMsg    = '';
  String _emailMsg = '';
  String _phoneMsg = '';
  FieldStatus _idStatus    = FieldStatus.none;
  FieldStatus _emailStatus = FieldStatus.none;
  FieldStatus _phoneStatus = FieldStatus.none;

  bool _showResult = false;
  String _sentEmail = '';

  @override
  void dispose() {
    _idCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    bool valid = true;
    setState(() {
      if (_idCtrl.text.trim().isEmpty) {
        _idMsg = '아이디를 입력해주세요.';
        _idStatus = FieldStatus.error;
        valid = false;
      } else {
        _idMsg = '';
        _idStatus = FieldStatus.none;
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
      final phone = _phoneCtrl.text.replaceAll('-', '');
      if (phone.length < 10) {
        _phoneMsg = '전화번호를 정확히 입력해주세요.';
        _phoneStatus = FieldStatus.error;
        valid = false;
      } else {
        _phoneMsg = '';
        _phoneStatus = FieldStatus.none;
      }
    });
    if (!valid) return;

    setState(() {
      final email = _emailCtrl.text.trim();
      final at = email.indexOf('@');
      _sentEmail = '${email.substring(0, 2)}***${email.substring(at)}';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WeddlyAuthAppBar(title: '비밀번호 초기화'),
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
          child: const Icon(Icons.lock_reset_outlined,
              size: 32, color: AppColors.primary),
        ),
        const SizedBox(height: 16),
        Text(
          '비밀번호를 잊으셨나요?',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800, color: context.wTextPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          '가입 시 등록한 아이디, 이메일, 전화번호가\n모두 일치하면 비밀번호를 초기화할 수 있어요.',
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
          label: '아이디',
          isRequired: true,
          hint: '아이디를 입력하세요',
          controller: _idCtrl,
          prefixIcon: Icons.person_outline,
          maxLength: 20,
          messageText: _idMsg,
          fieldStatus: _idStatus,
          onChanged: (_) => setState(() {
            _idMsg = '';
            _idStatus = FieldStatus.none;
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
        const SizedBox(height: 8),
        GradientButton(text: '비밀번호 초기화', onPressed: _submit),
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
                  color: AppColors.primary.withOpacity(0.1),
                ),
                child: const Icon(Icons.send_outlined,
                    size: 26, color: AppColors.primary),
              ),
              const SizedBox(height: 14),
              Text('임시 비밀번호 발송 완료',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: context.wTextPrimary)),
              const SizedBox(height: 8),
              Text(_sentEmail,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
              const SizedBox(height: 10),
              Text(
                '임시 비밀번호로 로그인 후\n반드시 비밀번호를 변경해주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    color: context.wTextLight,
                    height: 1.6,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GradientButton(
          text: '로그인하러 가기',
          onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
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
        _link('아이디 찾기', () => Navigator.pop(context)),
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
