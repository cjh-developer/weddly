import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_notifier.dart';
import '../../../core/theme/weddly_colors.dart';

// ══════════════════════════════════════════
// Models
// ══════════════════════════════════════════

class RoadmapTab {
  final String id;
  String name;
  RoadmapTab({required this.id, required this.name});
}

class RoadmapItem {
  final String id;
  String title;
  String category;
  String categoryEmoji;
  Color categoryColor;
  String monthLabel;
  bool isDone;
  String memo;
  String tabId;

  RoadmapItem({
    required this.id,
    required this.title,
    required this.category,
    required this.categoryEmoji,
    required this.categoryColor,
    required this.monthLabel,
    this.isDone = false,
    this.memo = '',
    required this.tabId,
  });
}

// ── 월 순서 ──────────────────────────────
const _monthOrder = [
  '12개월 전', '11개월 전', '10개월 전', '9개월 전', '8개월 전',
  '7개월 전', '6개월 전', '5개월 전', '4개월 전', '3개월 전',
  '2개월 전', '1개월 전', '1주일 전', '당일', '이후',
];

// ── 카테고리 컬러 팔레트 ──────────────────
const _palette = [
  Color(0xFFD4A96A),
  Color(0xFF5B9BD5),
  Color(0xFFE8857A),
  Color(0xFFE89B5B),
  Color(0xFF5BBDB8),
  Color(0xFF6BBD6E),
  Color(0xFFC47FC4),
  Color(0xFF888888),
];

// ── 기본 데이터 ───────────────────────────
List<RoadmapItem> _defaultItems(String tabId) => [
  RoadmapItem(id: 'r1',  title: '결혼 예산 설정',     category: '결혼 예산', categoryEmoji: '💰', categoryColor: const Color(0xFFD4A96A), monthLabel: '12개월 전', tabId: tabId),
  RoadmapItem(id: 'r2',  title: '웨딩홀 투어',        category: '웨딩홀 투어', categoryEmoji: '🗺️', categoryColor: const Color(0xFF5B9BD5), monthLabel: '12개월 전', tabId: tabId),
  RoadmapItem(id: 'r3',  title: '웨딩홀 예약',        category: '웨딩홀', categoryEmoji: '🏛️', categoryColor: const Color(0xFF5B9BD5), monthLabel: '12개월 전', tabId: tabId),
  RoadmapItem(id: 'r4',  title: '플래너 예약',        category: '플래너', categoryEmoji: '📋', categoryColor: const Color(0xFFC47FC4), monthLabel: '11개월 전', tabId: tabId),
  RoadmapItem(id: 'r5',  title: '스튜디오 예약',      category: '스튜디오', categoryEmoji: '📸', categoryColor: const Color(0xFFE8857A), monthLabel: '11개월 전', tabId: tabId),
  RoadmapItem(id: 'r6',  title: '드레스 예약',        category: '드레스', categoryEmoji: '👗', categoryColor: const Color(0xFFE8857A), monthLabel: '11개월 전', tabId: tabId),
  RoadmapItem(id: 'r7',  title: '메이크업 예약',      category: '메이크업', categoryEmoji: '💄', categoryColor: const Color(0xFFE89B5B), monthLabel: '11개월 전', tabId: tabId),
  RoadmapItem(id: 'r8',  title: '예물 준비',          category: '예물', categoryEmoji: '💍', categoryColor: const Color(0xFFD4A96A), monthLabel: '9개월 전', tabId: tabId),
  RoadmapItem(id: 'r9',  title: '드레스 투어 시작',   category: '드레스', categoryEmoji: '👗', categoryColor: const Color(0xFFE8857A), monthLabel: '9개월 전', tabId: tabId),
  RoadmapItem(id: 'r10', title: '스튜디오 촬영',      category: '스튜디오', categoryEmoji: '📸', categoryColor: const Color(0xFFE8857A), monthLabel: '7개월 전', tabId: tabId),
  RoadmapItem(id: 'r11', title: '신혼여행 계획',      category: '신혼여행', categoryEmoji: '✈️', categoryColor: const Color(0xFF5BBDB8), monthLabel: '7개월 전', tabId: tabId),
  RoadmapItem(id: 'r12', title: '신혼여행 예약',      category: '신혼여행', categoryEmoji: '✈️', categoryColor: const Color(0xFF5BBDB8), monthLabel: '7개월 전', tabId: tabId),
  RoadmapItem(id: 'r13', title: '신혼집 알아보기',    category: '신혼집', categoryEmoji: '🏡', categoryColor: const Color(0xFF6BBD6E), monthLabel: '7개월 전', tabId: tabId),
  RoadmapItem(id: 'r14', title: '혼주 메이크업 예약', category: '메이크업', categoryEmoji: '💄', categoryColor: const Color(0xFFE89B5B), monthLabel: '5개월 전', tabId: tabId),
  RoadmapItem(id: 'r15', title: '혼주 한복 예약',     category: '한복', categoryEmoji: '👘', categoryColor: const Color(0xFFC47FC4), monthLabel: '5개월 전', tabId: tabId),
  RoadmapItem(id: 'r16', title: '상견례',             category: '상견례', categoryEmoji: '🥂', categoryColor: const Color(0xFFD4A96A), monthLabel: '5개월 전', tabId: tabId),
  RoadmapItem(id: 'r17', title: '웨딩 촬영 예약',     category: '스튜디오', categoryEmoji: '📸', categoryColor: const Color(0xFFE8857A), monthLabel: '5개월 전', tabId: tabId),
  RoadmapItem(id: 'r18', title: '촬영본 수령',        category: '사진', categoryEmoji: '🖼️', categoryColor: const Color(0xFF5B9BD5), monthLabel: '4개월 전', tabId: tabId),
  RoadmapItem(id: 'r19', title: '부케 예약',          category: '부케', categoryEmoji: '💐', categoryColor: const Color(0xFFE8857A), monthLabel: '4개월 전', tabId: tabId),
  RoadmapItem(id: 'r20', title: '축가 요청',          category: '축가', categoryEmoji: '🎵', categoryColor: const Color(0xFF6BBD6E), monthLabel: '4개월 전', tabId: tabId),
  RoadmapItem(id: 'r21', title: '축사 요청',          category: '축사', categoryEmoji: '🎤', categoryColor: const Color(0xFF6BBD6E), monthLabel: '4개월 전', tabId: tabId),
  RoadmapItem(id: 'r22', title: '혼수 준비',          category: '혼수', categoryEmoji: '🏠', categoryColor: const Color(0xFF5BBDB8), monthLabel: '4개월 전', tabId: tabId),
  RoadmapItem(id: 'r23', title: '청첩장 준비',        category: '청첩장', categoryEmoji: '💌', categoryColor: const Color(0xFFD4A96A), monthLabel: '4개월 전', tabId: tabId),
  RoadmapItem(id: 'r24', title: '청첩장 돌리기 시작', category: '청첩장', categoryEmoji: '💌', categoryColor: const Color(0xFFD4A96A), monthLabel: '3개월 전', tabId: tabId),
  RoadmapItem(id: 'r25', title: '하객 명단 작성',     category: '본식', categoryEmoji: '💒', categoryColor: const Color(0xFFC47FC4), monthLabel: '3개월 전', tabId: tabId),
  RoadmapItem(id: 'r26', title: '모바일 청첩장 제작', category: '청첩장', categoryEmoji: '💌', categoryColor: const Color(0xFFD4A96A), monthLabel: '3개월 전', tabId: tabId),
  RoadmapItem(id: 'r27', title: 'DVD 예약',           category: 'DVD', categoryEmoji: '🎥', categoryColor: const Color(0xFF5B9BD5), monthLabel: '3개월 전', tabId: tabId),
  RoadmapItem(id: 'r28', title: '식순 확정',          category: '본식', categoryEmoji: '💒', categoryColor: const Color(0xFFC47FC4), monthLabel: '1개월 전', tabId: tabId),
  RoadmapItem(id: 'r29', title: '하객 명단 확정',     category: '본식', categoryEmoji: '💒', categoryColor: const Color(0xFFC47FC4), monthLabel: '1개월 전', tabId: tabId),
  RoadmapItem(id: 'r30', title: '최종 피팅',          category: '드레스', categoryEmoji: '👗', categoryColor: const Color(0xFFE8857A), monthLabel: '1개월 전', tabId: tabId),
  RoadmapItem(id: 'r31', title: '축사/축가 확정',     category: '축사', categoryEmoji: '🎤', categoryColor: const Color(0xFF6BBD6E), monthLabel: '1개월 전', tabId: tabId),
  RoadmapItem(id: 'r32', title: '업체 최종 확인',     category: '본식', categoryEmoji: '💒', categoryColor: const Color(0xFFC47FC4), monthLabel: '1주일 전', tabId: tabId),
  RoadmapItem(id: 'r33', title: '신혼집 이사',        category: '신혼집', categoryEmoji: '🏡', categoryColor: const Color(0xFF6BBD6E), monthLabel: '1주일 전', tabId: tabId),
  RoadmapItem(id: 'r34', title: '컨디션 관리',        category: '본식', categoryEmoji: '💒', categoryColor: const Color(0xFFD4A96A), monthLabel: '당일', tabId: tabId),
  RoadmapItem(id: 'r35', title: '본식',               category: '본식', categoryEmoji: '💒', categoryColor: const Color(0xFFD4A96A), monthLabel: '당일', tabId: tabId),
];

// ══════════════════════════════════════════
// Screen
// ══════════════════════════════════════════

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  late List<RoadmapTab> _tabs;
  late List<RoadmapItem> _items;
  late String _selectedTabId;
  final Set<String> _collapsedMonths = {};

  @override
  void initState() {
    super.initState();
    final defaultTab = RoadmapTab(id: 'tab_default', name: '기본 로드맵');
    _tabs = [defaultTab];
    _selectedTabId = defaultTab.id;
    _items = _defaultItems(defaultTab.id);
  }

  // ── 현재 탭 아이템 & 통계 ─────────────────

  List<RoadmapItem> get _currentItems =>
      _items.where((e) => e.tabId == _selectedTabId).toList();

  int get _total => _currentItems.length;
  int get _done  => _currentItems.where((e) => e.isDone).length;
  int get _todo  => _total - _done;
  double get _progress => _total == 0 ? 0 : _done / _total;

  String get _selectedTabName =>
      _tabs.firstWhere((t) => t.id == _selectedTabId).name;

  // ── 월별 그룹 ─────────────────────────────

  List<String> get _activeMonths {
    final months = _currentItems.map((e) => e.monthLabel).toSet();
    return _monthOrder.where((m) => months.contains(m)).toList();
  }

  List<RoadmapItem> _itemsFor(String month) =>
      _currentItems.where((e) => e.monthLabel == month).toList();

  // ── 이벤트 ───────────────────────────────

  void _toggleDone(RoadmapItem item) =>
      setState(() => item.isDone = !item.isDone);

  void _toggleMonth(String month) => setState(() {
        if (_collapsedMonths.contains(month)) {
          _collapsedMonths.remove(month);
        } else {
          _collapsedMonths.add(month);
        }
      });

  void _addItem(RoadmapItem item) => setState(() => _items.add(item));

  void _updateItem(RoadmapItem item) => setState(() {});

  void _deleteItem(RoadmapItem item) =>
      setState(() => _items.remove(item));

  void _addTab(String name) {
    final tab = RoadmapTab(
        id: 'tab_${DateTime.now().millisecondsSinceEpoch}', name: name);
    setState(() {
      _tabs.add(tab);
      _selectedTabId = tab.id;
    });
  }

  void _deleteTab(RoadmapTab tab) {
    if (_tabs.length <= 1) return;
    setState(() {
      _items.removeWhere((e) => e.tabId == tab.id);
      _tabs.remove(tab);
      _selectedTabId = _tabs.first.id;
    });
  }

  // ══════════════════════════════════════════
  // Modals
  // ══════════════════════════════════════════

  void _showAddItemModal() {
    final titleCtrl    = TextEditingController();
    final categoryCtrl = TextEditingController();
    final emojiCtrl    = TextEditingController(text: '📌');
    final memoCtrl     = TextEditingController();
    String selectedMonth = _monthOrder.first;
    Color selectedColor  = _palette.first;

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => _ItemModal(
          title: '일정 추가',
          titleCtrl: titleCtrl,
          categoryCtrl: categoryCtrl,
          emojiCtrl: emojiCtrl,
          memoCtrl: memoCtrl,
          selectedMonth: selectedMonth,
          selectedColor: selectedColor,
          onMonthChanged: (v) => setS(() => selectedMonth = v),
          onColorChanged: (v) => setS(() => selectedColor = v),
          onCancel: () => Navigator.pop(ctx),
          onConfirm: () {
            if (titleCtrl.text.trim().isEmpty) return;
            _addItem(RoadmapItem(
              id: 'item_${DateTime.now().millisecondsSinceEpoch}',
              title: titleCtrl.text.trim(),
              category: categoryCtrl.text.trim().isEmpty
                  ? '기타'
                  : categoryCtrl.text.trim(),
              categoryEmoji: emojiCtrl.text.trim().isEmpty
                  ? '📌'
                  : emojiCtrl.text.trim(),
              categoryColor: selectedColor,
              monthLabel: selectedMonth,
              memo: memoCtrl.text.trim(),
              tabId: _selectedTabId,
            ));
            Navigator.pop(ctx);
          },
          confirmLabel: '추가',
        ),
      ),
    );
  }

  void _showEditItemModal(RoadmapItem item) {
    final titleCtrl    = TextEditingController(text: item.title);
    final categoryCtrl = TextEditingController(text: item.category);
    final emojiCtrl    = TextEditingController(text: item.categoryEmoji);
    final memoCtrl     = TextEditingController(text: item.memo);
    String selectedMonth = item.monthLabel;
    Color selectedColor  = item.categoryColor;

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => _ItemModal(
          title: '일정 수정',
          titleCtrl: titleCtrl,
          categoryCtrl: categoryCtrl,
          emojiCtrl: emojiCtrl,
          memoCtrl: memoCtrl,
          selectedMonth: selectedMonth,
          selectedColor: selectedColor,
          onMonthChanged: (v) => setS(() => selectedMonth = v),
          onColorChanged: (v) => setS(() => selectedColor = v),
          onCancel: () => Navigator.pop(ctx),
          onConfirm: () {
            if (titleCtrl.text.trim().isEmpty) return;
            item.title         = titleCtrl.text.trim();
            item.category      = categoryCtrl.text.trim().isEmpty ? '기타' : categoryCtrl.text.trim();
            item.categoryEmoji = emojiCtrl.text.trim().isEmpty ? '📌' : emojiCtrl.text.trim();
            item.categoryColor = selectedColor;
            item.monthLabel    = selectedMonth;
            item.memo          = memoCtrl.text.trim();
            _updateItem(item);
            Navigator.pop(ctx);
          },
          confirmLabel: '수정',
          onDelete: () {
            Navigator.pop(ctx);
            _showDeleteItemModal(item);
          },
        ),
      ),
    );
  }

  void _showDeleteItemModal(RoadmapItem item) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: context.wModalBg,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🗑️', style: TextStyle(fontSize: 36)),
              const SizedBox(height: 12),
              Text('일정 삭제',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.wTextPrimary)),
              const SizedBox(height: 8),
              Text('"${item.title}"\n일정을 삭제할까요? 복구할 수 없습니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: context.wTextSecondary, height: 1.6)),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: _cancelBtn('취소', () => Navigator.pop(ctx))),
                const SizedBox(width: 10),
                Expanded(flex: 2, child: _dangerBtn('삭제', () {
                  _deleteItem(item);
                  Navigator.pop(ctx);
                })),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTabModal() {
    final nameCtrl = TextEditingController();
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: context.wModalBg,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('로드맵 추가',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.wTextPrimary)),
                  _closeBtn(ctx),
                ],
              ),
              const SizedBox(height: 18),
              Text('탭 이름',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.wTextLight)),
              const SizedBox(height: 6),
              _modalTextField(controller: nameCtrl, hint: '로드맵 이름을 입력하세요', maxLength: 20),
              const SizedBox(height: 18),
              Row(children: [
                Expanded(child: _cancelBtn('취소', () => Navigator.pop(ctx))),
                const SizedBox(width: 10),
                Expanded(flex: 2, child: _confirmBtn('추가', () {
                  if (nameCtrl.text.trim().isNotEmpty) {
                    _addTab(nameCtrl.text.trim());
                    Navigator.pop(ctx);
                  }
                })),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteTabModal(RoadmapTab tab) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: context.wModalBg,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🗑️', style: TextStyle(fontSize: 36)),
              const SizedBox(height: 12),
              Text('로드맵 삭제',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.wTextPrimary)),
              const SizedBox(height: 8),
              Text('"${tab.name}"\n로드맵과 포함된 모든 일정이 삭제됩니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: context.wTextSecondary, height: 1.6)),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: _cancelBtn('취소', () => Navigator.pop(ctx))),
                const SizedBox(width: 10),
                Expanded(flex: 2, child: _dangerBtn('삭제', () {
                  _deleteTab(tab);
                  Navigator.pop(ctx);
                })),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  // ── 공통 모달 위젯 ────────────────────────

  Widget _closeBtn(BuildContext ctx) => GestureDetector(
        onTap: () => Navigator.pop(ctx),
        child: Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: context.wIconBtnBg, borderRadius: BorderRadius.circular(8)),
          child: Icon(Icons.close, size: 16, color: context.wTextLight),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.wBorder)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.wBorder)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        ),
      );

  Widget _cancelBtn(String label, VoidCallback onTap) => TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: context.wIconBtnBg,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(label, style: TextStyle(color: context.wTextLight, fontSize: 14, fontWeight: FontWeight.w600)),
      );

  Widget _confirmBtn(String label, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.primaryGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
        ),
      );

  Widget _dangerBtn(String label, VoidCallback onTap) => TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: AppColors.error,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
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
                    children: [
                      _buildProgressCard(),
                      _buildTabRow(),
                      const SizedBox(height: 8),
                      _buildTimeline(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(bottom: 90, right: 20, child: _buildFab()),
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomNav()),
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
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.wBorderLight))),
          child: Row(
            children: [
              _iconBtn(Icons.arrow_back_ios_new_rounded, () => Navigator.maybePop(context)),
              const SizedBox(width: 8),
              const Text('weddly',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, fontStyle: FontStyle.italic, color: AppColors.primary, letterSpacing: -0.5)),
              const Spacer(),
              _iconBtn(context.isDark ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded, themeNotifier.toggle),
              const SizedBox(width: 6),
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
          width: 38, height: 38,
          decoration: BoxDecoration(color: context.wIconBtnBg, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 18, color: context.wIconBtnColor),
        ),
      );

  // ── Progress Card ─────────────────────────

  Widget _buildProgressCard() {
    final pct = (_progress * 100).round();
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF18110A), Color(0xFF33210A), Color(0xFFA8721E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 타이틀 + 퍼센트
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('WEDDING ROADMAP',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white54, letterSpacing: 1.2)),
                  const SizedBox(height: 4),
                  Text(_selectedTabName,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                ],
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$pct',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                    const TextSpan(
                      text: '%',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 프로그레스바
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 14),
          // 통계 그리드
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
            ),
            child: Row(
              children: [
                _statCell('전체', '$_total', Colors.white),
                _statDivider(),
                _statCell('완료', '$_done', AppColors.primary),
                _statDivider(),
                _statCell('미완료', '$_todo', Colors.white.withOpacity(0.55)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCell(String label, String value, Color valueColor) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: valueColor)),
              const SizedBox(height: 2),
              Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.7))),
            ],
          ),
        ),
      );

  Widget _statDivider() => Container(width: 1, height: 36, color: Colors.white.withOpacity(0.1));

  // ── Tab Row ───────────────────────────────

  Widget _buildTabRow() {
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        children: [
          ..._tabs.map((tab) => _buildTab(tab)),
          const SizedBox(width: 8),
          _buildAddTabBtn(),
        ],
      ),
    );
  }

  Widget _buildTab(RoadmapTab tab) {
    final isActive = tab.id == _selectedTabId;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabId = tab.id),
      onLongPress: _tabs.length > 1 ? () => _showDeleteTabModal(tab) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(colors: AppColors.primaryGradient, begin: Alignment.topLeft, end: Alignment.bottomRight)
              : null,
          color: isActive ? null : context.wSurface,
          border: Border.all(color: isActive ? Colors.transparent : context.wBorder),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(tab.name,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : context.wTextLight)),
      ),
    );
  }

  Widget _buildAddTabBtn() => GestureDetector(
        onTap: _showAddTabModal,
        child: Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
            color: context.wSurfaceAlt,
            border: Border.all(color: const Color(0xFFD0C0A8), style: BorderStyle.solid, width: 1.5),
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Icon(Icons.add_rounded, size: 18, color: AppColors.primaryDark),
        ),
      );

  // ── Timeline ──────────────────────────────

  Widget _buildTimeline() {
    final months = _activeMonths;
    if (months.isEmpty) return _buildEmptyState();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: months.map((month) => _buildMonthSection(month)).toList(),
      ),
    );
  }

  Widget _buildMonthSection(String month) {
    final items     = _itemsFor(month);
    final collapsed = _collapsedMonths.contains(month);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month header
        GestureDetector(
          onTap: () => _toggleMonth(month),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: context.isDark ? const Color(0xFF221E14) : const Color(0xFFFFF9F2),
                    border: Border.all(color: context.wPartnerBorder),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(month,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                      const SizedBox(width: 4),
                      Icon(
                        collapsed ? Icons.chevron_right_rounded : Icons.expand_more_rounded,
                        size: 14, color: AppColors.primaryDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: Container(height: 1, color: context.wPartnerBorder)),
              ],
            ),
          ),
        ),
        // Items
        if (!collapsed)
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildItemCard(item),
              )),
      ],
    );
  }

  Widget _buildItemCard(RoadmapItem item) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: item.isDone ? 0.55 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: context.wSurface,
          border: Border.all(color: context.isDark ? const Color(0xFF3A2E1A) : const Color(0xFFF0F0F0)),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
          child: Row(
            children: [
              // Checkbox
              GestureDetector(
                onTap: () => _toggleDone(item),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22, height: 22,
                  decoration: BoxDecoration(
                    color: item.isDone ? AppColors.primary : context.wInputBg,
                    border: Border.all(
                      color: item.isDone ? AppColors.primary : context.wBorder,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: item.isDone
                      ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: item.isDone ? context.wTextMuted : context.wTextPrimary,
                        decoration: item.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.memo.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(item.memo,
                          style: TextStyle(fontSize: 11, color: context.wTextLight),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Category badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: item.categoryColor.withOpacity(0.12),
                  border: Border.all(color: item.categoryColor.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${item.categoryEmoji} ${item.category}',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: item.categoryColor),
                ),
              ),
              const SizedBox(width: 6),
              // More button
              GestureDetector(
                onTap: () => _showEditItemModal(item),
                child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(color: context.wIconBtnBg, borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.more_horiz_rounded, size: 16, color: context.wTextLight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Empty state ───────────────────────────

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: const Color(0xFFFFF8EF), borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.list_alt_rounded, size: 28, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text('아직 타임라인이 없어요',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: context.wTextPrimary)),
          const SizedBox(height: 8),
          Text('우측 하단 + 버튼을 눌러\n타임라인 단계를 추가해 보세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: context.wTextHint, height: 1.7)),
        ],
      ),
    );
  }

  // ── FAB ──────────────────────────────────

  Widget _buildFab() => GestureDetector(
        onTap: _showAddItemModal,
        child: Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.primaryGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.45), blurRadius: 20, offset: const Offset(0, 6))],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
        ),
      );

  // ── Bottom nav ───────────────────────────

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: context.wNavBg,
        border: Border(top: BorderSide(color: context.wBorderLight)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _navItem(Icons.favorite_border_rounded, '홈', active: true),
              _navItem(Icons.account_balance_wallet_outlined, '예산'),
              _navItem(Icons.home_outlined, '메인'),
              _navItem(Icons.chat_bubble_outline_rounded, '커뮤니티'),
              _navItem(Icons.settings_outlined, '설정'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, {bool active = false}) {
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
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color, letterSpacing: -0.2)),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════
// Item Modal Widget (Add / Edit 공용)
// ══════════════════════════════════════════

class _ItemModal extends StatelessWidget {
  const _ItemModal({
    required this.title,
    required this.titleCtrl,
    required this.categoryCtrl,
    required this.emojiCtrl,
    required this.memoCtrl,
    required this.selectedMonth,
    required this.selectedColor,
    required this.onMonthChanged,
    required this.onColorChanged,
    required this.onCancel,
    required this.onConfirm,
    required this.confirmLabel,
    this.onDelete,
  });

  final String title;
  final TextEditingController titleCtrl;
  final TextEditingController categoryCtrl;
  final TextEditingController emojiCtrl;
  final TextEditingController memoCtrl;
  final String selectedMonth;
  final Color selectedColor;
  final ValueChanged<String> onMonthChanged;
  final ValueChanged<Color> onColorChanged;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final String confirmLabel;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: context.wModalBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.wTextPrimary)),
                GestureDetector(
                  onTap: onCancel,
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(color: context.wIconBtnBg, borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.close, size: 16, color: context.wTextLight),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // 제목
            _label(context, '제목 *'),
            const SizedBox(height: 6),
            _inputField(context, controller: titleCtrl, hint: '일정 제목을 입력하세요'),
            const SizedBox(height: 14),

            // 이모지 + 카테고리
            Row(
              children: [
                SizedBox(
                  width: 72,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(context, '이모지'),
                      const SizedBox(height: 6),
                      _inputField(context, controller: emojiCtrl, hint: '📌'),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(context, '카테고리'),
                      const SizedBox(height: 6),
                      _inputField(context, controller: categoryCtrl, hint: '예) 드레스'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 색상
            _label(context, '색상'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _palette.map((color) {
                final isSelected = selectedColor == color;
                return GestureDetector(
                  onTap: () => onColorChanged(color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected ? Border.all(color: context.wTextPrimary, width: 2) : null,
                      boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 6, offset: const Offset(0, 2))] : null,
                    ),
                    child: isSelected ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // 시기
            _label(context, '시기'),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: context.wInputBg,
                border: Border.all(color: context.wBorder),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedMonth,
                  items: _monthOrder.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (v) { if (v != null) onMonthChanged(v); },
                  style: TextStyle(fontSize: 13, color: context.wTextPrimary, fontFamily: 'pretendard'),
                  dropdownColor: context.wModalBg,
                  isExpanded: true,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // 메모
            _label(context, '메모 (선택)'),
            const SizedBox(height: 6),
            _inputField(context, controller: memoCtrl, hint: '추가 메모를 입력하세요', maxLines: 3),
            const SizedBox(height: 20),

            // Buttons
            if (onDelete != null) ...[
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.08),
                    border: Border.all(color: AppColors.error.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('삭제',
                      style: TextStyle(color: AppColors.error, fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onCancel,
                    style: TextButton.styleFrom(
                      backgroundColor: context.wIconBtnBg,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('취소', style: TextStyle(color: context.wTextLight, fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: AppColors.primaryGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(confirmLabel, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String text) => Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.wTextLight),
      );

  Widget _inputField(BuildContext context, {
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) =>
      TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(fontSize: 13, color: context.wTextPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: context.wTextHint, fontSize: 13),
          filled: true,
          fillColor: context.wInputBg,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.wBorder)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.wBorder)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        ),
      );
}
