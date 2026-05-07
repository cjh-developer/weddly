import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_notifier.dart';
import '../../../core/theme/weddly_colors.dart';

// ══════════════════════════════════════════
// Enums & Models
// ══════════════════════════════════════════

enum CeremonyItemType {
  simple,
  video,
  groomEntNo,
  brideEntNo,
  groomEntYes,
  brideEntYes,
  officiantMsg,
  custom,
}

class CeremonyItem {
  final String id;
  final String emoji;
  String title;
  final CeremonyItemType type;
  final bool isCustom;
  bool isSkipped;
  bool isExpanded;

  // type=video
  String videoTitle;
  String videoLength;
  // type=groomEnt / brideEnt
  String music;
  String playTime;
  bool fatherTogether;
  // type=officiantMsg
  String officiantName;
  // type=custom
  String customContent;

  CeremonyItem({
    required this.id,
    required this.emoji,
    required this.title,
    required this.type,
    this.isCustom = false,
    this.isSkipped = false,
    this.isExpanded = true,
    this.videoTitle = '',
    this.videoLength = '',
    this.music = '',
    this.playTime = '',
    this.fatherTogether = false,
    this.officiantName = '',
    this.customContent = '',
  });
}

// ── Default data ──────────────────────────

List<CeremonyItem> _defaultNoItems() => [
      CeremonyItem(id: 'no_pre_video',    emoji: '🎬', title: '식전 영상',       type: CeremonyItemType.video),
      CeremonyItem(id: 'no_parents_in',   emoji: '👨‍👩‍👧', title: '부모님 입장',   type: CeremonyItemType.simple),
      CeremonyItem(id: 'no_candle',       emoji: '🕯️', title: '화촉점화',        type: CeremonyItemType.simple),
      CeremonyItem(id: 'no_groom_in',     emoji: '🤵', title: '신랑 입장',       type: CeremonyItemType.groomEntNo),
      CeremonyItem(id: 'no_bride_in',     emoji: '👰', title: '신부 입장',       type: CeremonyItemType.brideEntNo),
      CeremonyItem(id: 'no_bow',          emoji: '🙏', title: '신랑 신부 맞절',  type: CeremonyItemType.simple),
      CeremonyItem(id: 'no_rings',        emoji: '💍', title: '예물 교환',       type: CeremonyItemType.simple),
      CeremonyItem(id: 'no_vow',          emoji: '📜', title: '혼인 서약',       type: CeremonyItemType.simple),
      CeremonyItem(id: 'no_declaration',  emoji: '✨', title: '성혼 선언',       type: CeremonyItemType.simple),
      CeremonyItem(id: 'no_parents_wish', emoji: '💝', title: '부모님 덕담',     type: CeremonyItemType.simple),
      CeremonyItem(id: 'no_mid_video',    emoji: '🎬', title: '식중 영상',       type: CeremonyItemType.video),
      CeremonyItem(id: 'no_speech',       emoji: '🎤', title: '축사',            type: CeremonyItemType.simple),
      CeremonyItem(id: 'no_song',         emoji: '🎵', title: '축가',            type: CeremonyItemType.simple),
      CeremonyItem(id: 'no_greet',        emoji: '👋', title: '부모님 및 하객 인사', type: CeremonyItemType.simple),
      CeremonyItem(id: 'no_march',        emoji: '🚶', title: '행진',            type: CeremonyItemType.simple),
    ];

List<CeremonyItem> _defaultYesItems() => [
      CeremonyItem(id: 'yes_pre_video',   emoji: '🎬', title: '식전 영상',       type: CeremonyItemType.video),
      CeremonyItem(id: 'yes_parents_in',  emoji: '👨‍👩‍👧', title: '부모님 입장',   type: CeremonyItemType.simple),
      CeremonyItem(id: 'yes_groom_in',    emoji: '🤵', title: '신랑 입장',       type: CeremonyItemType.groomEntYes),
      CeremonyItem(id: 'yes_bride_in',    emoji: '👰', title: '신부 입장',       type: CeremonyItemType.brideEntYes),
      CeremonyItem(id: 'yes_bow',         emoji: '🙏', title: '신랑 신부 맞절',  type: CeremonyItemType.simple),
      CeremonyItem(id: 'yes_vow',         emoji: '📜', title: '혼인 서약',       type: CeremonyItemType.simple),
      CeremonyItem(id: 'yes_declaration', emoji: '✨', title: '성혼 선언',       type: CeremonyItemType.simple),
      CeremonyItem(id: 'yes_officiant',   emoji: '📖', title: '주례사',          type: CeremonyItemType.officiantMsg),
      CeremonyItem(id: 'yes_song',        emoji: '🎵', title: '축가',            type: CeremonyItemType.simple),
      CeremonyItem(id: 'yes_greet',       emoji: '👋', title: '부모님 및 하객 인사', type: CeremonyItemType.simple),
      CeremonyItem(id: 'yes_march',       emoji: '🚶', title: '행진',            type: CeremonyItemType.simple),
    ];

// ══════════════════════════════════════════
// Screen
// ══════════════════════════════════════════

class CeremonyOrderScreen extends StatefulWidget {
  const CeremonyOrderScreen({super.key});

  @override
  State<CeremonyOrderScreen> createState() => _CeremonyOrderScreenState();
}

class _CeremonyOrderScreenState extends State<CeremonyOrderScreen> {
  bool _hasOfficiant = false;
  bool _saved = false;

  late List<CeremonyItem> _noItems;
  late List<CeremonyItem> _yesItems;

  List<CeremonyItem> get _currentItems =>
      _hasOfficiant ? _yesItems : _noItems;

  @override
  void initState() {
    super.initState();
    _noItems  = _defaultNoItems();
    _yesItems = _defaultYesItems();
  }

  void _toggleOfficiant(bool v) {
    setState(() => _hasOfficiant = v);
  }

  void _toggleSkip(CeremonyItem item) {
    setState(() => item.isSkipped = !item.isSkipped);
  }

  void _toggleExpand(CeremonyItem item) {
    setState(() => item.isExpanded = !item.isExpanded);
  }

  void _deleteItem(CeremonyItem item) {
    setState(() {
      if (_hasOfficiant) {
        _yesItems.remove(item);
      } else {
        _noItems.remove(item);
      }
    });
  }

  void _addItem(String title, String scenario) {
    final newItem = CeremonyItem(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      emoji: '📌',
      title: title,
      type: CeremonyItemType.custom,
      isCustom: true,
    );
    setState(() {
      if (scenario == 'yes') {
        _yesItems.add(newItem);
      } else {
        _noItems.add(newItem);
      }
    });
  }

  void _save() {
    setState(() => _saved = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _saved = false);
    });
  }

  // ── Modals ───────────────────────────────

  void _showAddModal() {
    final titleCtrl   = TextEditingController();
    final contentCtrl = TextEditingController();
    String scenario   = _hasOfficiant ? 'yes' : 'no';

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: context.wModalBg,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('식순 추가',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: context.wTextPrimary)),
                    _closeBtn(ctx),
                  ],
                ),
                const SizedBox(height: 18),
                // 적용 대상
                _modalLabel('적용 대상'),
                const SizedBox(height: 6),
                _modalDropdown(
                  value: scenario,
                  items: const [
                    DropdownMenuItem(value: 'no',  child: Text('주례 없음 ❌')),
                    DropdownMenuItem(value: 'yes', child: Text('주례 있음 ✅')),
                  ],
                  onChanged: (v) => setS(() => scenario = v ?? scenario),
                ),
                const SizedBox(height: 14),
                // 제목
                _modalLabel('제목 *'),
                const SizedBox(height: 6),
                _modalTextField(
                  controller: titleCtrl,
                  hint: '식순 제목을 입력하세요',
                  maxLength: 20,
                ),
                const SizedBox(height: 14),
                // 내용
                _modalLabel('내용 (선택)'),
                const SizedBox(height: 6),
                _modalTextField(
                  controller: contentCtrl,
                  hint: '세부 내용을 입력하세요',
                  maxLines: 3,
                ),
                const SizedBox(height: 18),
                // actions
                Row(
                  children: [
                    Expanded(
                      child: _modalCancelBtn('취소', () => Navigator.pop(ctx)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: _modalConfirmBtn('추가', () {
                        if (titleCtrl.text.trim().isNotEmpty) {
                          _addItem(titleCtrl.text.trim(), scenario);
                          Navigator.pop(ctx);
                        }
                      }),
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

  void _showEditModal(CeremonyItem item) {
    final titleCtrl = TextEditingController(text: item.title);

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: context.wModalBg,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('식순 수정',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: context.wTextPrimary)),
                  _closeBtn(ctx),
                ],
              ),
              const SizedBox(height: 18),
              _modalLabel('제목 *'),
              const SizedBox(height: 6),
              _modalTextField(
                controller: titleCtrl,
                hint: '식순 제목을 입력하세요',
                maxLength: 20,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _modalCancelBtn('취소', () => Navigator.pop(ctx)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: _modalConfirmBtn('수정', () {
                      if (titleCtrl.text.trim().isNotEmpty) {
                        setState(() => item.title = titleCtrl.text.trim());
                        Navigator.pop(ctx);
                      }
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteModal(CeremonyItem item) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: context.wModalBg,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🗑️', style: TextStyle(fontSize: 36)),
              const SizedBox(height: 12),
              Text('식순 삭제',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: context.wTextPrimary)),
              const SizedBox(height: 8),
              Text(
                '이 식순 항목을 삭제할까요?\n삭제 후 복구할 수 없습니다.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: context.wTextSecondary, height: 1.6),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _modalCancelBtn('취소', () => Navigator.pop(ctx)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: TextButton(
                      onPressed: () {
                        _deleteItem(item);
                        Navigator.pop(ctx);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('삭제',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Modal helpers ─────────────────────────

  Widget _closeBtn(BuildContext ctx) => GestureDetector(
        onTap: () => Navigator.pop(ctx),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: context.wIconBtnBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.close, size: 16, color: context.wTextLight),
        ),
      );

  Widget _modalLabel(String text) => Text(
        text,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.wTextLight),
      );

  Widget _modalDropdown({
    required String value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: context.wInputBg,
          border: Border.all(color: context.wBorder),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            items: items,
            onChanged: onChanged,
            style: TextStyle(
                fontSize: 13, color: context.wTextPrimary, fontFamily: 'pretendard'),
            dropdownColor: context.wModalBg,
            isExpanded: true,
          ),
        ),
      );

  Widget _modalTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    int? maxLength,
  }) =>
      TextField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        style: TextStyle(fontSize: 13, color: context.wTextPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: context.wTextHint, fontSize: 13),
          filled: true,
          fillColor: context.wInputBg,
          counterText: '',
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: context.wBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: context.wBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      );

  Widget _modalCancelBtn(String label, VoidCallback onTap) => TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: context.wIconBtnBg,
          padding: const EdgeInsets.symmetric(vertical: 11),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(label,
            style: TextStyle(
                color: context.wTextLight,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
      );

  Widget _modalConfirmBtn(String label, VoidCallback onTap) => TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 11),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ).copyWith(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
          ),
        ),
      );

  // ══════════════════════════════════════════
  // Build
  // ══════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.wBg,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPageTitle(),
                      const SizedBox(height: 12),
                      _buildOfficiantCard(),
                      const SizedBox(height: 8),
                      _buildSectionHeader(),
                      const SizedBox(height: 8),
                      _buildItemList(),
                      const SizedBox(height: 12),
                      _buildSaveButton(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // FAB
          Positioned(
            bottom: 90,
            right: 20,
            child: _buildFab(),
          ),
          // Bottom Nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNav(),
          ),
        ],
      ),
    );
  }

  // ── Header ───────────────────────────────

  Widget _buildHeader() {
    return Container(
      color: context.wHeaderBg,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: context.wBorderLight)),
          ),
          child: Row(
            children: [
              // back
              _iconBtn(
                Icons.arrow_back_ios_new_rounded,
                () => Navigator.maybePop(context),
              ),
              const SizedBox(width: 8),
              // logo
              const Text('weddly',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                      color: AppColors.primary,
                      letterSpacing: -0.5)),
              const Spacer(),
              // dark mode
              _iconBtn(
                context.isDark ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
                () => themeNotifier.toggle(),
              ),
              const SizedBox(width: 6),
              // notification
              Stack(
                children: [
                  _iconBtn(Icons.notifications_none_rounded, () {}),
                  Positioned(
                    top: 7,
                    right: 7,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 6),
              // profile
              _iconBtn(Icons.account_circle_outlined, () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: context.wIconBtnBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: context.wIconBtnColor),
        ),
      );

  // ── Page title ───────────────────────────

  Widget _buildPageTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📋 식순 관리',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: context.wTextPrimary)),
          const SizedBox(height: 3),
          Text('드래그로 순서를 변경하고 저장하세요',
              style: TextStyle(fontSize: 12, color: context.wTextHint)),
        ],
      ),
    );
  }

  // ── Officiant toggle card ─────────────────

  Widget _buildOfficiantCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.wSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.wPartnerBorder, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // left
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('주례 여부',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: context.wTextPrimary)),
                  const SizedBox(height: 2),
                  Text('토글로 주례 유무를 선택하세요',
                      style: TextStyle(fontSize: 11, color: context.wTextHint)),
                  const SizedBox(height: 6),
                  _officiantBadge(),
                ],
              ),
            ),
            // toggle
            Switch(
              value: _hasOfficiant,
              onChanged: _toggleOfficiant,
              activeColor: AppColors.primary,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: context.wBorder,
              thumbColor: WidgetStateProperty.all(Colors.white),
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _officiantBadge() {
    if (_hasOfficiant) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8EF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text('✅ 주례 있음',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary)),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text('❌ 주례 없음',
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5B9BD5))),
    );
  }

  // ── Section header ───────────────────────

  Widget _buildSectionHeader() {
    final count = _currentItems.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('식순 목록',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: context.wTextLight)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5E6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('$count개',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ── Item list ────────────────────────────

  Widget _buildItemList() {
    final items = _currentItems;
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 36),
          child: Text(
            '식순이 없습니다.\n+ 버튼으로 추가해보세요.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12,
                color: context.wTextHint,
                height: 1.8),
          ),
        ),
      );
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      buildDefaultDragHandles: false,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) newIndex--;
          final item = items.removeAt(oldIndex);
          items.insert(newIndex, item);
        });
      },
      itemBuilder: (_, i) {
        final item = items[i];
        return Padding(
          key: ValueKey(item.id),
          padding: const EdgeInsets.only(bottom: 8),
          child: _CeremonyCard(
            item: item,
            index: i,
            onToggleSkip: () => _toggleSkip(item),
            onToggleExpand: () => _toggleExpand(item),
            onEdit: item.isCustom ? () => _showEditModal(item) : null,
            onDelete: item.isCustom ? () => _showDeleteModal(item) : null,
          ),
        );
      },
    );
  }

  // ── Save button ──────────────────────────

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: _save,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _saved
                  ? [const Color(0xFF6BBD6E), const Color(0xFF4A9D4D)]
                  : AppColors.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: (_saved ? const Color(0xFF6BBD6E) : AppColors.primary)
                    .withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _saved ? '✅ 저장됨' : '💾 저장하기',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }

  // ── FAB ──────────────────────────────────

  Widget _buildFab() => GestureDetector(
        onTap: _showAddModal,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.45),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
        ),
      );

  // ── Bottom nav ───────────────────────────

  Widget _buildBottomNav() {
    return ClipRect(
      child: Container(
        height: 64 + MediaQuery.of(context).padding.bottom,
        decoration: BoxDecoration(
          color: context.wNavBg,
          border: Border(top: BorderSide(color: context.wBorderLight)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              _navItem(icon: Icons.favorite_border_rounded, label: '홈', active: true),
              _navItem(icon: Icons.account_balance_wallet_outlined, label: '예산'),
              _navItem(icon: Icons.home_outlined, label: '메인', isCenter: true),
              _navItem(icon: Icons.chat_bubble_outline_rounded, label: '커뮤니티'),
              _navItem(icon: Icons.settings_outlined, label: '설정'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    bool active = false,
    bool isCenter = false,
  }) {
    final color = active ? AppColors.primary : context.wTextMuted;
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color,
                    letterSpacing: -0.2)),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════
// Ceremony Card Widget
// ══════════════════════════════════════════

class _CeremonyCard extends StatelessWidget {
  const _CeremonyCard({
    required this.item,
    required this.index,
    required this.onToggleSkip,
    required this.onToggleExpand,
    this.onEdit,
    this.onDelete,
  });

  final CeremonyItem item;
  final int index;
  final VoidCallback onToggleSkip;
  final VoidCallback onToggleExpand;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  bool get _hasFields =>
      item.type != CeremonyItemType.simple && !item.isSkipped;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: item.isSkipped ? 0.4 : 1.0,
      child: Container(
            decoration: BoxDecoration(
              color: context.isDark
                  ? const Color(0xFF1E1A14)
                  : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: context.isDark
                    ? const Color(0xFF2E2818)
                    : const Color(0xFFF0EEEB),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(context.isDark ? 0.18 : 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
              // Header
            InkWell(
              onTap: _hasFields || item.type == CeremonyItemType.simple
                  ? onToggleExpand
                  : onToggleExpand,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 11, 8, 11),
                child: Row(
                  children: [
                    // drag handle (decoration only — reorder handled by ReorderableListView)
                    const Text('⠿',
                        style: TextStyle(fontSize: 16, color: Color(0xFFCCCCCC))),
                    const SizedBox(width: 6),
                    // number circle
                    _numCircle(context),
                    const SizedBox(width: 8),
                    // emoji
                    Text(item.emoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    // title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: item.isSkipped
                                        ? const Color(0xFFBBBBBB)
                                        : context.wTextPrimary,
                                    decoration: item.isSkipped
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              if (item.isCustom) ...[
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF5E6),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('커스텀',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary)),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    // expand indicator (for non-simple)
                    if (_hasFields || !item.isSkipped && item.type != CeremonyItemType.simple)
                      Icon(
                        item.isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: context.wTextLight,
                      ),
                    const SizedBox(width: 4),
                    // skip button
                    _skipBtn(context),
                    if (item.isCustom) ...[
                      const SizedBox(width: 4),
                      // edit button
                      _actionBtn(
                        icon: Icons.edit_outlined,
                        color: AppColors.primary,
                        onTap: onEdit ?? () {},
                      ),
                      const SizedBox(width: 2),
                      // delete button
                      _actionBtn(
                        icon: Icons.delete_outline_rounded,
                        color: AppColors.error,
                        onTap: onDelete ?? () {},
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Expandable fields
            if (!item.isSkipped && item.isExpanded && item.type != CeremonyItemType.simple)
              _buildFields(context),
              ],
            ),   // Column
          ),     // Container
    );           // AnimatedOpacity
  }

  Widget _numCircle(BuildContext context) => Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: item.isSkipped
              ? const Color(0xFFF0F0F0)
              : const Color(0xFFFFF5E6),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '${index + 1}',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: item.isSkipped
                ? const Color(0xFFBBBBBB)
                : AppColors.primary,
          ),
        ),
      );

  Widget _skipBtn(BuildContext context) {
    return GestureDetector(
      onTap: onToggleSkip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: item.isSkipped
              ? const Color(0xFFFFF0F0)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: item.isSkipped
                ? const Color(0xFFF5A0A0)
                : const Color(0xFFE8E0D8),
            width: 1.5,
          ),
        ),
        child: Text(
          item.isSkipped ? '생략됨' : '생략',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: item.isSkipped
                ? const Color(0xFFE55555)
                : const Color(0xFFBBBBBB),
          ),
        ),
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: color),
        ),
      );

  // ── Fields ───────────────────────────────

  Widget _buildFields(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFFF0ECE6),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildFieldWidgets(context),
      ),
    );
  }

  List<Widget> _buildFieldWidgets(BuildContext context) {
    switch (item.type) {
      case CeremonyItemType.video:
        return [
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(child: _fieldInput(context, '영상 제목', item.videoTitle,
                  (v) => item.videoTitle = v)),
              const SizedBox(width: 8),
              Expanded(child: _fieldInput(context, '영상 길이', item.videoLength,
                  (v) => item.videoLength = v,
                  hint: '예) 3분 20초')),
            ],
          ),
        ];

      case CeremonyItemType.groomEntNo:
      case CeremonyItemType.groomEntYes:
        return [
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                  child: _fieldInput(context, '음원', item.music,
                      (v) => item.music = v)),
              const SizedBox(width: 8),
              Expanded(
                  child: _fieldInput(context, '재생 시간', item.playTime,
                      (v) => item.playTime = v,
                      hint: '예) 2분 30초')),
            ],
          ),
        ];

      case CeremonyItemType.brideEntNo:
      case CeremonyItemType.brideEntYes:
        return [
          const SizedBox(height: 9),
          _checkField(context, '아버지 동시 입장', item.fatherTogether,
              (v) => item.fatherTogether = v ?? false),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  child: _fieldInput(context, '음원', item.music,
                      (v) => item.music = v)),
              const SizedBox(width: 8),
              Expanded(
                  child: _fieldInput(context, '재생 시간', item.playTime,
                      (v) => item.playTime = v,
                      hint: '예) 2분 30초')),
            ],
          ),
        ];

      case CeremonyItemType.officiantMsg:
        return [
          const SizedBox(height: 9),
          _fieldInput(context, '주례자', item.officiantName,
              (v) => item.officiantName = v),
        ];

      case CeremonyItemType.custom:
        return [
          const SizedBox(height: 9),
          _fieldInput(context, '내용', item.customContent,
              (v) => item.customContent = v,
              hint: '세부 내용을 입력하세요'),
        ];

      default:
        return [];
    }
  }

  Widget _fieldInput(
    BuildContext context,
    String label,
    String value,
    ValueChanged<String> onChanged, {
    String hint = '',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 11,
                color: context.wTextHint,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2)),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          style: TextStyle(fontSize: 12, color: context.wTextPrimary),
          decoration: InputDecoration(
            hintText: hint.isNotEmpty ? hint : label,
            hintStyle: TextStyle(color: context.wTextHint, fontSize: 12),
            filled: true,
            fillColor: context.wSurfaceAlt,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Color(0xFFEDE9E3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Color(0xFFEDE9E3), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _checkField(
    BuildContext context,
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: TextStyle(fontSize: 12, color: context.wTextSecondary)),
      ],
    );
  }
}
