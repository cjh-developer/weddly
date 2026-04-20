import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/weddly_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/weddly_footer.dart';
import 'find_id_screen.dart';
import 'reset_pw_screen.dart';
import 'signup_screen.dart';

// -- Social logo SVG constants
const _googleSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">
  <path fill="#EA4335" d="M24 9.5c3.1 0 5.8 1.1 8 2.9l6-6C34.3 3 29.4 1 24 1 14.8 1 7 6.7 3.7 14.6l7 5.4C12.5 13.8 17.8 9.5 24 9.5z"/>
  <path fill="#4285F4" d="M46.5 24.5c0-1.6-.1-3.1-.4-4.5H24v8.5h12.7c-.6 3-2.3 5.5-4.8 7.2l7.4 5.7c4.3-4 6.8-9.9 7.2-16.9z"/>
  <path fill="#FBBC05" d="M10.7 28.5A14.6 14.6 0 0 1 9.5 24c0-1.6.3-3.1.7-4.5l-7-5.4A23.9 23.9 0 0 0 0 24c0 3.9.9 7.5 2.6 10.8l8.1-6.3z"/>
  <path fill="#34A853" d="M24 47c5.4 0 9.9-1.8 13.2-4.8l-7.4-5.7c-1.8 1.2-4.1 2-5.8 2-6.2 0-11.5-4.2-13.4-10l-8.1 6.3C7 42.3 14.8 47 24 47z"/>
</svg>
''';

const _kakaoSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
  <path fill="#3C1E1E" d="M12 3C6.477 3 2 6.477 2 10.667c0 2.667 1.667 5 4.167 6.333L5.5 20.5l4.333-2.833c.714.1 1.44.166 2.167.166 5.523 0 10-3.477 10-7.666C22 6.477 17.523 3 12 3z"/>
</svg>
''';

const _naverSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
  <path fill="#FFFFFF" d="M16.273 12.845L7.376 0H0v24h7.727V11.155L16.624 24H24V0h-7.727z"/>
</svg>
''';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _idCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _pwVisible = false;
  bool _remember = false;

  @override
  void dispose() {
    _idCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_idCtrl.text.trim().isEmpty) {
      _showSnack('아이디를 입력해주세요.');
      return;
    }
    if (_pwCtrl.text.isEmpty) {
      _showSnack('비밀번호를 입력해주세요.');
      return;
    }
    _showSnack('로그인 API 연동 예정');
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLogoSection(),
                    _buildForm(),
                    _buildDivider(),
                    _buildSocialSection(),
                  ],
                ),
              ),
            ),
            const WeddlyFooter(),
          ],
        ),
      ),
    );
  }

  // -- Logo
  Widget _buildLogoSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 56, bottom: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'weddly',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: AppColors.primary,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '당신의 특별한 날을 함께해요',
            style: TextStyle(
              fontSize: 13,
              color: context.wTextLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // -- Form
  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputGroup(
          label: '아이디',
          controller: _idCtrl,
          hint: '아이디를 입력하세요',
          icon: Icons.person_outline,
          onSubmit: (_) => FocusScope.of(context).nextFocus(),
        ),
        const SizedBox(height: 14),
        _buildInputGroup(
          label: '비밀번호',
          controller: _pwCtrl,
          hint: '비밀번호를 입력하세요',
          icon: Icons.lock_outline,
          obscure: !_pwVisible,
          suffix: IconButton(
            icon: Icon(
              _pwVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: context.wTextHint,
              size: 20,
            ),
            onPressed: () => setState(() => _pwVisible = !_pwVisible),
          ),
          onSubmit: (_) => _onLogin(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => setState(() => _remember = !_remember),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCheckbox(_remember, () => setState(() => _remember = !_remember)),
                  const SizedBox(width: 6),
                  Text(
                    '로그인 유지',
                    style: TextStyle(fontSize: 13, color: context.wTextSecondary, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextLink('아이디 찾기',
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FindIdScreen()))),
                Text('  |  ', style: TextStyle(color: context.wTextMuted, fontSize: 12)),
                _buildTextLink('비밀번호 초기화',
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResetPwScreen()))),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        GradientButton(text: '로그인', onPressed: _onLogin),
        const SizedBox(height: 16),
        Center(
          child: RichText(
            text: TextSpan(
              text: '아직 계정이 없으신가요?  ',
              style: TextStyle(fontSize: 13, color: context.wTextLight),
              children: [
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const SignupScreen())),
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  // -- Divider
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: context.wBorderLight)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            '또는 소셜 계정으로 로그인',
            style: TextStyle(fontSize: 12, color: context.wTextMuted, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(child: Container(height: 1, color: context.wBorderLight)),
      ],
    );
  }

  // -- Social login
  Widget _buildSocialSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Column(
        children: [
          _buildSocialButton(
            bgColor: context.wGoogleBg,
            borderColor: context.wGoogleBorder,
            textColor: context.wGoogleText,
            label: 'Google로 로그인',
            badge: SvgPicture.string(_googleSvg, width: 20, height: 20),
            onTap: () => _showSnack('Google 로그인 연동 예정'),
          ),
          const SizedBox(height: 10),
          _buildSocialButton(
            bgColor: AppColors.kakao,
            borderColor: AppColors.kakao,
            textColor: AppColors.kakaoText,
            label: 'Kakao로 로그인',
            badge: SvgPicture.string(_kakaoSvg, width: 20, height: 20),
            onTap: () => _showSnack('Kakao 로그인 연동 예정'),
          ),
          const SizedBox(height: 10),
          _buildSocialButton(
            bgColor: AppColors.naver,
            borderColor: AppColors.naver,
            textColor: AppColors.white,
            label: 'Naver로 로그인',
            badge: SvgPicture.string(_naverSvg, width: 20, height: 20),
            onTap: () => _showSnack('Naver 로그인 연동 예정'),
          ),
        ],
      ),
    );
  }

  // -- Helper widgets

  Widget _buildInputGroup({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    ValueChanged<String>? onSubmit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13, color: context.wTextSecondary, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          onSubmitted: onSubmit,
          style: TextStyle(fontSize: 14, color: context.wTextPrimary, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: context.wTextHint, size: 20),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox(bool value, VoidCallback onChanged) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: value ? AppColors.primary : context.wSurface,
        border: Border.all(
          color: value ? AppColors.primary : context.wBorder,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: value
          ? const Icon(Icons.check, size: 13, color: AppColors.white)
          : null,
    );
  }

  Widget _buildTextLink(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
    required String label,
    required Widget badge,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            badge,
            const SizedBox(width: 10),
            Text(label,
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
          ],
        ),
      ),
    );
  }
}
