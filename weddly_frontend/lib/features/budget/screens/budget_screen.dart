import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_notifier.dart';
import '../../../core/theme/weddly_colors.dart';

// ══════════════════════════════════════════
// Models
// ══════════════════════════════════════════

class SubBudgetItem {
  final int id;
  final String name;
  final int amount;
  final String? note;

  const SubBudgetItem({
    required this.id,
    required this.name,
    required this.amount,
    this.note,
  });

  SubBudgetItem copyWith({String? name, int? amount, String? note, bool clearNote = false}) {
    return SubBudgetItem(
      id: id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      note: clearNote ? null : (note ?? this.note),
    );
  }
}

class BudgetItem {
  final int id;
  final String emoji;
  final String name;
  final int amount;
  final Color color;
  final String? memo;
  final List<SubBudgetItem> subItems;

  const BudgetItem({
    required this.id,
    required this.emoji,
    required this.name,
    required this.amount,
    required this.color,
    this.memo,
    this.subItems = const [],
  });

  int get spent => subItems.fold(0, (s, e) => s + e.amount);
  double get usageRate => amount > 0 ? (spent / amount).clamp(0.0, 1.0) : 0.0;

  BudgetItem copyWith({
    String? emoji,
    String? name,
    int? amount,
    Color? color,
    String? memo,
    bool clearMemo = false,
    List<SubBudgetItem>? subItems,
  }) {
    return BudgetItem(
      id: id,
      emoji: emoji ?? this.emoji,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      color: color ?? this.color,
      memo: clearMemo ? null : (memo ?? this.memo),
      subItems: subItems ?? this.subItems,
    );
  }
}

// ══════════════════════════════════════════
// Constants
// ══════════════════════════════════════════

const _kCategories = [
  ('💍', '예식비'),
  ('📷', '스튜디오'),
  ('💄', '메이크업'),
  ('👗', '드레스'),
  ('📋', '플래너'),
  ('✈️', '신혼여행'),
  ('💎', '예물/예단'),
  ('🏠', '혼수/가전'),
  ('🍽️', '상견례'),
  ('💌', '청첩장'),
  ('📦', '기타'),
];

const _kItemColors = [
  Color(0xFFD4A96A),
  Color(0xFFE8857A),
  Color(0xFFC47FC4),
  Color(0xFF5B9BD5),
  Color(0xFF6BBD6E),
  Color(0xFF5BBDB8),
  Color(0xFFE89B5B),
  Color(0xFF888888),
];

final List<BudgetItem> _kSampleData = [
  BudgetItem(
    id: 1,
    emoji: '💍',
    name: '예식비',
    amount: 8000000,
    color: const Color(0xFFD4A96A),
    subItems: [
      const SubBudgetItem(id: 1, name: '웨딩홀 대관', amount: 6000000, note: '계약 완료'),
      const SubBudgetItem(id: 2, name: '음식비', amount: 2000000),
    ],
  ),
  BudgetItem(
    id: 2,
    emoji: '📷',
    name: '스튜디오',
    amount: 2000000,
    color: const Color(0xFF5B9BD5),
    subItems: [
      const SubBudgetItem(id: 3, name: 'A스튜디오', amount: 1300000, note: '비교 중'),
    ],
  ),
  BudgetItem(
    id: 3,
    emoji: '💄',
    name: '메이크업',
    amount: 1500000,
    color: const Color(0xFFE8857A),
    subItems: [],
  ),
  BudgetItem(
    id: 4,
    emoji: '✈️',
    name: '신혼여행',
    amount: 5000000,
    color: const Color(0xFF6BBD6E),
    subItems: [
      const SubBudgetItem(id: 4, name: '항공권', amount: 2400000),
      const SubBudgetItem(id: 5, name: '숙박비', amount: 1800000, note: '예약 완료'),
    ],
  ),
];

// ══════════════════════════════════════════
// Helpers
// ══════════════════════════════════════════

String _formatKRW(int amount) {
  if (amount == 0) return '0원';
  if (amount >= 100000000) {
    final eok = amount ~/ 100000000;
    final man = (amount % 100000000) ~/ 10000;
    return man > 0 ? '$eok억 $man만원' : '$eok억원';
  } else if (amount >= 10000) {
    final man = amount ~/ 10000;
    final rest = amount % 10000;
    return rest > 0 ? '$man만 ${rest}원' : '$man만원';
  }
  return '${amount}원';
}

String _commaFormat(int amount) {
  if (amount == 0) return '0';
  return amount.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
}

int _parseAmount(String text) =>
    int.tryParse(text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

// ══════════════════════════════════════════
// BudgetScreen
// ══════════════════════════════════════════

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  int _totalBudget = 30000000;
  List<BudgetItem> _items = List.from(_kSampleData);
  int _nextItemId = _kSampleData.length + 1;
  int _nextSubId = 20;
  final Set<int> _expandedIds = {1}; // id 1 starts expanded

  // ── Computed
  int get _totalSpent => _items.fold(0, (s, e) => s + e.spent);
  double get _usageRate =>
      _totalBudget > 0 ? (_totalSpent / _totalBudget).clamp(0.0, 1.0) : 0.0;
  int get _remaining => _totalBudget - _totalSpent;

  // ── CRUD Items
  void _addItem(BudgetItem item) => setState(() => _items = [
        ..._items,
        BudgetItem(
          id: _nextItemId++,
          emoji: item.emoji,
          name: item.name,
          amount: item.amount,
          color: item.color,
          memo: item.memo,
        ),
      ]);

  void _updateItem(BudgetItem updated) => setState(() =>
      _items = _items.map((e) => e.id == updated.id ? updated : e).toList());

  void _deleteItem(int id) => setState(() {
        _items = _items.where((e) => e.id != id).toList();
        _expandedIds.remove(id);
      });

  // ── CRUD Sub-items
  void _addSubItem(int itemId, SubBudgetItem sub) => setState(() {
        _items = _items.map((item) {
          if (item.id != itemId) return item;
          return item.copyWith(subItems: [
            ...item.subItems,
            SubBudgetItem(
              id: _nextSubId++,
              name: sub.name,
              amount: sub.amount,
              note: sub.note,
            ),
          ]);
        }).toList();
      });

  void _deleteSubItem(int itemId, int subId) => setState(() {
        _items = _items.map((item) {
          if (item.id != itemId) return item;
          return item.copyWith(
              subItems: item.subItems.where((s) => s.id != subId).toList());
        }).toList();
      });

  void _updateSubItem(int itemId, SubBudgetItem updated) => setState(() {
        _items = _items.map((item) {
          if (item.id != itemId) return item;
          return item.copyWith(
            subItems: item.subItems
                .map((s) => s.id == updated.id ? updated : s)
                .toList(),
          );
        }).toList();
      });

  // ── Modals
  void _showTotalBudgetModal() => showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.48),
        builder: (_) => _TotalBudgetModal(
          current: _totalBudget,
          onSave: (v) => setState(() => _totalBudget = v),
        ),
      );

  void _showAddModal() => showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.48),
        builder: (_) => _ItemModal(onSave: _addItem),
      );

  void _showEditModal(BudgetItem item) => showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.48),
        builder: (_) => _ItemModal(
          existingItem: item,
          onSave: (_) {},
          onUpdate: _updateItem,
        ),
      );

  void _showDeleteItemModal(BudgetItem item) => showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.48),
        builder: (_) => _DeleteModal(
          title: '"${item.name}" 예산을 삭제할까요?',
          description: '삭제하면 세부 항목도 모두 삭제되며\n되돌릴 수 없습니다.',
          onConfirm: () => _deleteItem(item.id),
        ),
      );

  void _showDeleteSubModal(int itemId, SubBudgetItem sub) => showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.48),
        builder: (_) => _DeleteModal(
          title: '"${sub.name}"을 삭제할까요?',
          description: '삭제하면 되돌릴 수 없습니다.',
          onConfirm: () => _deleteSubItem(itemId, sub.id),
        ),
      );

  void _showAddSubModal(int itemId) => showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.48),
        builder: (_) => _SubItemModal(
          onSave: (sub) => _addSubItem(itemId, sub),
        ),
      );

  void _showEditSubModal(int itemId, SubBudgetItem sub) => showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.48),
        builder: (_) => _SubItemModal(
          onSave: (_) {},
          existingItem: sub,
          onUpdate: (updated) => _updateSubItem(itemId, updated),
        ),
      );

  // ── Build

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.wBg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 90),
                    child: Column(
                      children: [
                        _buildSummaryCard(),
                        const SizedBox(height: 16),
                        _buildCategorySection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(right: 18, bottom: 26, child: _buildFAB()),
          ],
        ),
      ),
    );
  }

  // ── Header

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: BoxDecoration(
        color: context.wHeaderBg,
        border: Border(bottom: BorderSide(color: context.wBorderLight)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: context.wIconBtnBg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(Icons.chevron_left,
                  color: context.wTextSecondary, size: 22),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'weddly',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              color: AppColors.primary,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (_, mode, __) => _iconBtn(
              icon: mode == ThemeMode.dark
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_round_outlined,
              onTap: () => themeNotifier.toggle(),
            ),
          ),
          const SizedBox(width: 6),
          Stack(
            clipBehavior: Clip.none,
            children: [
              _iconBtn(icon: Icons.notifications_none_rounded, onTap: () {}),
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF44336),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
          _iconBtn(icon: Icons.account_circle_outlined, onTap: () {}),
        ],
      ),
    );
  }

  Widget _iconBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: context.wIconBtnBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: context.wIconBtnColor, size: 19),
      ),
    );
  }

  // ── Summary card

  Widget _buildSummaryCard() {
    final pct = (_usageRate * 100).toStringAsFixed(0);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF18110A),
            Color(0xFF33210A),
            Color(0xFFA8721E),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -20,
            bottom: -36,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.07), width: 1),
                color: Colors.white.withOpacity(0.025),
              ),
            ),
          ),
          Positioned(
            right: 54,
            bottom: -8,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.07), width: 1),
                color: Colors.white.withOpacity(0.025),
              ),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row
              Row(
                children: [
                  Text(
                    '전체 예산',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.5),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _showTotalBudgetModal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.2), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '설정',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Main row
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Left: amounts + progress
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatKRW(_totalBudget),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            text: '사용 ',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            children: [
                              TextSpan(
                                text: _formatKRW(_totalSpent),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withOpacity(0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: LinearProgressIndicator(
                                  value: _usageRate,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.15),
                                  valueColor: AlwaysStoppedAnimation(
                                      Colors.white.withOpacity(0.82)),
                                  minHeight: 4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$pct%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '잔여 ${_formatKRW(_remaining < 0 ? 0 : _remaining)}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.4),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Right: Donut ring
                  SizedBox(
                    width: 66,
                    height: 66,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(66, 66),
                          painter: _DonutPainter(progress: _usageRate),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$pct%',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '사용률',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.5),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Category section

  Widget _buildCategorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Section header
          Row(
            children: [
              Text(
                '카테고리별 예산',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: context.wTextLight,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: context.wCmTagBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_items.length}개',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  const Text('💰', style: TextStyle(fontSize: 36)),
                  const SizedBox(height: 10),
                  Text(
                    '등록된 예산이 없습니다',
                    style: TextStyle(
                        fontSize: 13, color: context.wTextMuted),
                  ),
                ],
              ),
            )
          else
            ...List.generate(
              _items.length,
              (i) {
                final item = _items[i];
                final isExpanded = _expandedIds.contains(item.id);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _BudgetCard(
                    item: item,
                    isExpanded: isExpanded,
                    onToggle: () => setState(() {
                      if (isExpanded) {
                        _expandedIds.remove(item.id);
                      } else {
                        _expandedIds.add(item.id);
                      }
                    }),
                    onEdit: () => _showEditModal(item),
                    onDelete: () => _showDeleteItemModal(item),
                    onAddSubItem: () => _showAddSubModal(item.id),
                    onDeleteSubItem: (sub) =>
                        _showDeleteSubModal(item.id, sub),
                    onEditSubItem: (sub) =>
                        _showEditSubModal(item.id, sub),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ── FAB

  Widget _buildFAB() {
    return GestureDetector(
      onTap: _showAddModal,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.45),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 24),
      ),
    );
  }
}

// ══════════════════════════════════════════
// Budget Card (Category item)
// ══════════════════════════════════════════

class _BudgetCard extends StatelessWidget {
  final BudgetItem item;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddSubItem;
  final void Function(SubBudgetItem) onDeleteSubItem;
  final void Function(SubBudgetItem) onEditSubItem;

  const _BudgetCard({
    required this.item,
    required this.isExpanded,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    required this.onAddSubItem,
    required this.onDeleteSubItem,
    required this.onEditSubItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.wSurface,
        border: Border.all(color: context.wBorderLight, width: 1.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card header
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
              child: Row(
                children: [
                  // Emoji + left color bar
                  Container(
                    width: 4,
                    height: 36,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text(item.emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: context.wTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_formatKRW(item.spent)} / ${_formatKRW(item.amount)}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: context.wTextLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Right: % + mini progress + actions + chevron
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${(item.usageRate * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Edit
                          GestureDetector(
                            onTap: onEdit,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: context.wIconBtnBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.edit_outlined,
                                  size: 14, color: context.wIconBtnColor),
                            ),
                          ),
                          const SizedBox(width: 4),
                          // Delete
                          GestureDetector(
                            onTap: onDelete,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: context.wIconBtnBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.delete_outline,
                                  size: 14, color: context.wTextMuted),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Mini progress bar
                      SizedBox(
                        width: 80,
                        height: 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: item.usageRate,
                            backgroundColor:
                                context.isDark
                                    ? const Color(0xFF2E2818)
                                    : const Color(0xFFF0EBE4),
                            valueColor:
                                AlwaysStoppedAnimation(item.color),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 6),
                  // Chevron
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        size: 20, color: context.wTextMuted),
                  ),
                ],
              ),
            ),
          ),
          // Expandable sub-items
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: isExpanded
                ? Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: context.wBorderLight)),
                    ),
                    child: Column(
                      children: [
                        // Sub-items list
                        ...item.subItems.asMap().entries.map((e) {
                          final sub = e.value;
                          final isLast =
                              e.key == item.subItems.length - 1;
                          return GestureDetector(
                            onTap: () => onEditSubItem(sub),
                            child: Container(
                            padding: const EdgeInsets.fromLTRB(
                                20, 10, 14, 10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: isLast
                                  ? null
                                  : Border(
                                      bottom: BorderSide(
                                          color: context.wBorderLight
                                              .withOpacity(0.5))),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  margin:
                                      const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: item.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    sub.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: context.wTextSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (sub.note != null &&
                                    sub.note!.isNotEmpty) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: context.wCmTagBg,
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      sub.note!,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                                const SizedBox(width: 8),
                                Text(
                                  _formatKRW(sub.amount),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: context.wTextSecondary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () => onDeleteSubItem(sub),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: context.wIconBtnBg,
                                      borderRadius:
                                          BorderRadius.circular(7),
                                    ),
                                    child: Icon(Icons.close,
                                        size: 13,
                                        color: context.wTextMuted),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          );
                        }),
                        // Add sub-item button
                        GestureDetector(
                          onTap: onAddSubItem,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10),
                            margin: const EdgeInsets.fromLTRB(
                                14, 6, 14, 12),
                            decoration: BoxDecoration(
                              color: context.wCmTagBg,
                              border: Border.all(
                                  color: context.wPartnerBorder,
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                '+ 항목 추가',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════
// Donut Painter
// ══════════════════════════════════════════

class _DonutPainter extends CustomPainter {
  final double progress;
  const _DonutPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;

    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    if (progress > 0) {
      final fgPaint = Paint()
        ..color = Colors.white.withOpacity(0.82)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        fgPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) => old.progress != progress;
}

// ══════════════════════════════════════════
// Total Budget Modal
// ══════════════════════════════════════════

class _TotalBudgetModal extends StatefulWidget {
  final int current;
  final void Function(int) onSave;
  const _TotalBudgetModal({required this.current, required this.onSave});

  @override
  State<_TotalBudgetModal> createState() => _TotalBudgetModalState();
}

class _TotalBudgetModalState extends State<_TotalBudgetModal> {
  late TextEditingController _ctrl;
  int _preview = 0;

  @override
  void initState() {
    super.initState();
    _preview = widget.current;
    _ctrl = TextEditingController(
        text: widget.current > 0 ? _commaFormat(widget.current) : '');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: context.wModalBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Color(0x40000000), blurRadius: 60, offset: Offset(0, 20))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _modalHeader(context, '전체 예산 설정'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel(context, '전체 예산 금액'),
                  _amountField(
                    context,
                    controller: _ctrl,
                    onChanged: (v) =>
                        setState(() => _preview = _parseAmount(v)),
                  ),
                  if (_preview > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 2),
                      child: Text(
                        _formatKRW(_preview),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            _modalFooter(context,
                onCancel: () => Navigator.pop(context),
                onConfirm: () {
                  final v = _parseAmount(_ctrl.text);
                  if (v <= 0) {
                    _showSnack(context, '금액을 입력해주세요.');
                    return;
                  }
                  widget.onSave(v);
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════
// Item Modal (Add / Edit)
// ══════════════════════════════════════════

class _ItemModal extends StatefulWidget {
  final BudgetItem? existingItem;
  final void Function(BudgetItem) onSave;
  final void Function(BudgetItem)? onUpdate;

  const _ItemModal({
    this.existingItem,
    required this.onSave,
    this.onUpdate,
  });

  @override
  State<_ItemModal> createState() => _ItemModalState();
}

class _ItemModalState extends State<_ItemModal> {
  late TextEditingController _nameCtrl;
  late TextEditingController _amountCtrl;
  late TextEditingController _memoCtrl;
  late String _emoji;
  late Color _color;
  int _amountPreview = 0;

  bool get _isEdit => widget.existingItem != null;

  @override
  void initState() {
    super.initState();
    final ev = widget.existingItem;
    _emoji = ev?.emoji ?? _kCategories[0].$1;
    _color = ev?.color ?? _kItemColors[0];
    _amountPreview = ev?.amount ?? 0;
    _nameCtrl = TextEditingController(text: ev?.name ?? '');
    _amountCtrl = TextEditingController(
        text: ev != null && ev.amount > 0 ? _commaFormat(ev.amount) : '');
    _memoCtrl = TextEditingController(text: ev?.memo ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    _memoCtrl.dispose();
    super.dispose();
  }

  void _onConfirm() {
    if (_nameCtrl.text.trim().isEmpty) {
      _showSnack(context, '예산 항목 제목을 입력해주세요.');
      return;
    }
    final amount = _parseAmount(_amountCtrl.text);
    if (amount <= 0) {
      _showSnack(context, '예산 금액을 입력해주세요.');
      return;
    }
    final memo =
        _memoCtrl.text.trim().isEmpty ? null : _memoCtrl.text.trim();

    if (_isEdit) {
      widget.onUpdate!(widget.existingItem!.copyWith(
        emoji: _emoji,
        name: _nameCtrl.text.trim(),
        amount: amount,
        color: _color,
        memo: memo,
        clearMemo: memo == null,
      ));
    } else {
      widget.onSave(BudgetItem(
        id: 0,
        emoji: _emoji,
        name: _nameCtrl.text.trim(),
        amount: amount,
        color: _color,
        memo: memo,
      ));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Container(
        decoration: BoxDecoration(
          color: context.wModalBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Color(0x40000000), blurRadius: 60, offset: Offset(0, 20))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _modalHeader(context, _isEdit ? '예산 수정' : '예산 등록'),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.65),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category grid
                    _fieldLabel(context, '카테고리 선택'),
                    const SizedBox(height: 6),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1.1,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                      ),
                      itemCount: _kCategories.length,
                      itemBuilder: (_, i) {
                        final cat = _kCategories[i];
                        final selected = _emoji == cat.$1;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _emoji = cat.$1;
                            if (!_isEdit &&
                                _nameCtrl.text.isEmpty) {
                              _nameCtrl.text = cat.$2;
                            }
                          }),
                          child: Container(
                            decoration: BoxDecoration(
                              color: selected
                                  ? context.wCmTagBg
                                  : context.wInputBg,
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : context.wBorder,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(cat.$1,
                                    style:
                                        const TextStyle(fontSize: 18)),
                                const SizedBox(height: 2),
                                Text(
                                  cat.$2,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: selected
                                        ? AppColors.primary
                                        : context.wTextLight,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Name
                    _fieldLabel(context, '제목', required: true),
                    _textField(context,
                        controller: _nameCtrl,
                        hint: '예산 항목 제목을 입력하세요',
                        maxLength: 30),
                    const SizedBox(height: 14),
                    // Amount
                    _fieldLabel(context, '예산 금액', required: true),
                    _amountField(context,
                        controller: _amountCtrl,
                        onChanged: (v) =>
                            setState(() => _amountPreview = _parseAmount(v))),
                    if (_amountPreview > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 2),
                        child: Text(
                          _formatKRW(_amountPreview),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    const SizedBox(height: 14),
                    // Color
                    _fieldLabel(context, '색상'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _kItemColors.map((c) {
                        final sel = _color == c;
                        return GestureDetector(
                          onTap: () => setState(() => _color = c),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: sel
                                    ? context.wTextPrimary
                                    : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                            child: sel
                                ? const Icon(Icons.check,
                                    size: 14, color: Colors.white)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    // Memo
                    _fieldLabel(context, '메모'),
                    _textField(context,
                        controller: _memoCtrl,
                        hint: '메모나 상세 내용을 입력하세요',
                        maxLines: 2,
                        maxLength: 100),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _modalFooter(context,
                confirmLabel: _isEdit ? '수정 완료' : '저장',
                onCancel: () => Navigator.pop(context),
                onConfirm: _onConfirm),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════
// Sub-Item Modal
// ══════════════════════════════════════════

class _SubItemModal extends StatefulWidget {
  final void Function(SubBudgetItem) onSave;
  final SubBudgetItem? existingItem;
  final void Function(SubBudgetItem)? onUpdate;
  const _SubItemModal({
    required this.onSave,
    this.existingItem,
    this.onUpdate,
  });

  @override
  State<_SubItemModal> createState() => _SubItemModalState();
}

class _SubItemModalState extends State<_SubItemModal> {
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  int _preview = 0;

  bool get _isEdit => widget.existingItem != null;

  @override
  void initState() {
    super.initState();
    final ex = widget.existingItem;
    if (ex != null) {
      _nameCtrl.text = ex.name;
      _amountCtrl.text = _commaFormat(ex.amount);
      _noteCtrl.text = ex.note ?? '';
      _preview = ex.amount;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _onConfirm() {
    if (_nameCtrl.text.trim().isEmpty) {
      _showSnack(context, '항목 이름을 입력해주세요.');
      return;
    }
    final amount = _parseAmount(_amountCtrl.text);
    if (amount <= 0) {
      _showSnack(context, '금액을 입력해주세요.');
      return;
    }
    final sub = SubBudgetItem(
      id: widget.existingItem?.id ?? 0,
      name: _nameCtrl.text.trim(),
      amount: amount,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
    );
    if (_isEdit) {
      widget.onUpdate?.call(sub);
    } else {
      widget.onSave(sub);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: context.wModalBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Color(0x40000000), blurRadius: 60, offset: Offset(0, 20))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _modalHeader(context, _isEdit ? '세부 항목 수정' : '세부 항목 추가'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel(context, '항목명', required: true),
                  _textField(context,
                      controller: _nameCtrl,
                      hint: '예: 웨딩홀 대관',
                      maxLength: 20),
                  const SizedBox(height: 14),
                  _fieldLabel(context, '금액', required: true),
                  _amountField(context,
                      controller: _amountCtrl,
                      onChanged: (v) =>
                          setState(() => _preview = _parseAmount(v))),
                  if (_preview > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 2),
                      child: Text(
                        _formatKRW(_preview),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  const SizedBox(height: 14),
                  _fieldLabel(context, '메모'),
                  _textField(context,
                      controller: _noteCtrl,
                      hint: '예: 계약 완료',
                      maxLength: 20),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            _modalFooter(context,
                confirmLabel: _isEdit ? '수정 완료' : '저장',
                onCancel: () => Navigator.pop(context),
                onConfirm: _onConfirm),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════
// Delete Modal
// ══════════════════════════════════════════

class _DeleteModal extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onConfirm;

  const _DeleteModal({
    required this.title,
    required this.description,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        decoration: BoxDecoration(
          color: context.wModalBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Color(0x33000000), blurRadius: 60, offset: Offset(0, 20))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🗑️', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.wTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF888888),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: context.wIconBtnBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text('취소',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: context.wTextLight,
                            )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onConfirm();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('삭제',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFF44336),
                            )),
                      ),
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
}

// ══════════════════════════════════════════
// Shared Modal Helpers
// ══════════════════════════════════════════

Widget _modalHeader(BuildContext context, String title) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 14, 16, 12),
    decoration:
        BoxDecoration(border: Border(bottom: BorderSide(color: context.wBorderLight))),
    child: Row(
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.wTextPrimary)),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                color: context.wIconBtnBg,
                borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.close, size: 16, color: context.wTextLight),
          ),
        ),
      ],
    ),
  );
}

Widget _modalFooter(
  BuildContext context, {
  required VoidCallback onCancel,
  required VoidCallback onConfirm,
  String confirmLabel = '저장',
}) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
    decoration:
        BoxDecoration(border: Border(top: BorderSide(color: context.wBorderLight))),
    child: Row(
      children: [
        GestureDetector(
          onTap: onCancel,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
            decoration: BoxDecoration(
                color: context.wIconBtnBg,
                borderRadius: BorderRadius.circular(12)),
            child: Text('취소',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.wTextLight)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: onConfirm,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: AppColors.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Center(
                child: Text(confirmLabel,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.3)),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _fieldLabel(BuildContext context, String label,
    {bool required = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: context.wTextSecondary),
        children: required
            ? const [
                TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppColors.primary))
              ]
            : [],
      ),
    ),
  );
}

Widget _textField(
  BuildContext context, {
  required TextEditingController controller,
  required String hint,
  int maxLines = 1,
  int? maxLength,
}) {
  return TextField(
    controller: controller,
    maxLines: maxLines,
    maxLength: maxLength,
    style: TextStyle(
        fontSize: 14,
        color: context.wModalInputText,
        fontWeight: FontWeight.w500),
    decoration: InputDecoration(
      hintText: hint,
      counterText: '',
      filled: true,
      fillColor: context.wModalInputBg,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.wModalInputBorder, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
    ),
  );
}

Widget _amountField(
  BuildContext context, {
  required TextEditingController controller,
  required ValueChanged<String> onChanged,
}) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      _CommaInputFormatter(),
    ],
    onChanged: onChanged,
    style: TextStyle(
        fontSize: 14,
        color: context.wModalInputText,
        fontWeight: FontWeight.w500),
    decoration: InputDecoration(
      hintText: '금액을 입력하세요',
      suffixText: '원',
      suffixStyle: TextStyle(
          fontSize: 13,
          color: context.wTextLight,
          fontWeight: FontWeight.w500),
      filled: true,
      fillColor: context.wModalInputBg,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.wModalInputBorder, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
    ),
  );
}

void _showSnack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
}

// ══════════════════════════════════════════
// Comma Input Formatter
// ══════════════════════════════════════════

class _CommaInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(',', '');
    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }
    final formatted = digits.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
