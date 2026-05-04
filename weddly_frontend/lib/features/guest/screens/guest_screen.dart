import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

// ══════════════════════════════════════════
// Models
// ══════════════════════════════════════════

class GuestCategory {
  final String id;
  final String name;
  final Color? color;

  const GuestCategory({required this.id, required this.name, this.color});
}

enum VisitStatus { none, planned, done }
enum InviteStatus { notSent, sent }

extension VisitStatusLabel on VisitStatus {
  String get label {
    switch (this) {
      case VisitStatus.none:    return '미정';
      case VisitStatus.planned: return '방문예정';
      case VisitStatus.done:    return '방문완료';
    }
  }
}

extension InviteStatusLabel on InviteStatus {
  String get label {
    switch (this) {
      case InviteStatus.notSent: return '미발송';
      case InviteStatus.sent:    return '발송완료';
    }
  }
}

class GuestItem {
  final int id;
  final String name;
  final String category;
  final int companions;
  final VisitStatus visitStatus;
  final InviteStatus inviteStatus;
  final int amount;
  final String memo;

  const GuestItem({
    required this.id,
    required this.name,
    required this.category,
    this.companions = 0,
    this.visitStatus = VisitStatus.none,
    this.inviteStatus = InviteStatus.notSent,
    this.amount = 0,
    this.memo = '',
  });

  GuestItem copyWith({
    String? name,
    String? category,
    int? companions,
    VisitStatus? visitStatus,
    InviteStatus? inviteStatus,
    int? amount,
    String? memo,
  }) {
    return GuestItem(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      companions: companions ?? this.companions,
      visitStatus: visitStatus ?? this.visitStatus,
      inviteStatus: inviteStatus ?? this.inviteStatus,
      amount: amount ?? this.amount,
      memo: memo ?? this.memo,
    );
  }
}

// ══════════════════════════════════════════
// Sample Data
// ══════════════════════════════════════════

final List<GuestCategory> _defaultCategories = [
  GuestCategory(id: 'all',    name: '전체',  color: null),
  GuestCategory(id: 'family', name: '부모님', color: AppColors.primary),
  GuestCategory(id: 'friend', name: '친구',  color: const Color(0xFFE8758A)),
  GuestCategory(id: 'work',   name: '직장',  color: const Color(0xFF5B9BD5)),
  GuestCategory(id: 'other',  name: '기타',  color: const Color(0xFF9B76C8)),
];

int _nextGuestId = 20;
int _nextCatId   = 10;

List<GuestItem> _sampleGuests = [
  const GuestItem(id: 1,  name: '김민준', category: '친구',  companions: 1, visitStatus: VisitStatus.planned, inviteStatus: InviteStatus.sent,    amount: 100000, memo: '고등학교 친구'),
  const GuestItem(id: 2,  name: '이서연', category: '직장',  companions: 0, visitStatus: VisitStatus.none,    inviteStatus: InviteStatus.sent,    amount: 50000,  memo: ''),
  const GuestItem(id: 3,  name: '박정숙', category: '부모님', companions: 2, visitStatus: VisitStatus.planned, inviteStatus: InviteStatus.sent,    amount: 300000, memo: '신부 측 부모님'),
  const GuestItem(id: 4,  name: '최유진', category: '친구',  companions: 1, visitStatus: VisitStatus.none,    inviteStatus: InviteStatus.notSent, amount: 70000,  memo: '대학교 친구'),
  const GuestItem(id: 5,  name: '정수현', category: '직장',  companions: 0, visitStatus: VisitStatus.done,    inviteStatus: InviteStatus.sent,    amount: 50000,  memo: ''),
  const GuestItem(id: 6,  name: '강민서', category: '기타',  companions: 0, visitStatus: VisitStatus.none,    inviteStatus: InviteStatus.sent,    amount: 0,      memo: '동네 지인'),
  const GuestItem(id: 7,  name: '윤도현', category: '친구',  companions: 2, visitStatus: VisitStatus.planned, inviteStatus: InviteStatus.sent,    amount: 100000, memo: '군대 친구'),
  const GuestItem(id: 8,  name: '임지수', category: '직장',  companions: 1, visitStatus: VisitStatus.none,    inviteStatus: InviteStatus.notSent, amount: 0,      memo: ''),
  const GuestItem(id: 9,  name: '한서준', category: '부모님', companions: 1, visitStatus: VisitStatus.planned, inviteStatus: InviteStatus.sent,    amount: 200000, memo: '신랑 측 친척'),
  const GuestItem(id: 10, name: '오민아', category: '친구',  companions: 0, visitStatus: VisitStatus.done,    inviteStatus: InviteStatus.sent,    amount: 50000,  memo: '초등학교 친구'),
  const GuestItem(id: 11, name: '신동욱', category: '직장',  companions: 0, visitStatus: VisitStatus.planned, inviteStatus: InviteStatus.sent,    amount: 50000,  memo: ''),
  const GuestItem(id: 12, name: '권나연', category: '기타',  companions: 1, visitStatus: VisitStatus.planned, inviteStatus: InviteStatus.notSent, amount: 30000,  memo: '지인 소개'),
];

// ══════════════════════════════════════════
// Screen
// ══════════════════════════════════════════

class GuestScreen extends StatefulWidget {
  const GuestScreen({super.key});

  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  List<GuestCategory> _categories = List.from(_defaultCategories);
  List<GuestItem>     _guests     = List.from(_sampleGuests);

  String _activeCategoryId = 'all';
  String _sortBy           = 'name';
  final Set<int> _selectedIds = {};

  // ── 유틸
  Color _catColor(String catName) {
    final c = _categories.firstWhere(
      (c) => c.name == catName,
      orElse: () => const GuestCategory(id: '', name: '', color: Color(0xFFAAAAAA)),
    );
    return c.color ?? const Color(0xFFAAAAAA);
  }

  List<GuestItem> get _filtered {
    List<GuestItem> list = List.from(_guests);
    if (_activeCategoryId != 'all') {
      final cat = _categories.firstWhere(
        (c) => c.id == _activeCategoryId,
        orElse: () => const GuestCategory(id: '', name: ''),
      );
      if (cat.name.isNotEmpty) {
        list = list.where((g) => g.category == cat.name).toList();
      }
    }
    switch (_sortBy) {
      case 'name':
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'visit':
        const ord = {VisitStatus.done: 0, VisitStatus.planned: 1, VisitStatus.none: 2};
        list.sort((a, b) => (ord[a.visitStatus] ?? 2) - (ord[b.visitStatus] ?? 2));
        break;
      case 'amount':
        list.sort((a, b) => b.amount - a.amount);
        break;
    }
    return list;
  }

  String _fmtAmount(int n) {
    if (n == 0) return '미정';
    return '₩${n.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')}';
  }

  // ── 게스트 CRUD
  void _addGuest(GuestItem item) {
    setState(() => _guests.add(item));
  }

  void _updateGuest(GuestItem item) {
    setState(() {
      final idx = _guests.indexWhere((g) => g.id == item.id);
      if (idx != -1) _guests[idx] = item;
    });
  }

  void _deleteGuest(int id) {
    setState(() {
      _guests.removeWhere((g) => g.id == id);
      _selectedIds.remove(id);
    });
  }

  // ── 카테고리 추가
  void _addCategory(String name, Color color) {
    final id = 'cat_${_nextCatId++}';
    setState(() => _categories.add(GuestCategory(id: id, name: name, color: color)));
  }

  // ── 일괄 처리
  void _bulkSetVisit() {
    setState(() {
      for (var id in _selectedIds) {
        final idx = _guests.indexWhere((g) => g.id == id);
        if (idx != -1) {
          _guests[idx] = _guests[idx].copyWith(visitStatus: VisitStatus.done);
        }
      }
      _selectedIds.clear();
    });
  }

  void _bulkSetInvite() {
    setState(() {
      for (var id in _selectedIds) {
        final idx = _guests.indexWhere((g) => g.id == id);
        if (idx != -1) {
          _guests[idx] = _guests[idx].copyWith(inviteStatus: InviteStatus.sent);
        }
      }
      _selectedIds.clear();
    });
  }

  // ── 모달 열기
  void _openGuestModal({GuestItem? editing}) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => _GuestFormModal(
        categories: _categories.where((c) => c.id != 'all').toList(),
        editing: editing,
        onSave: (item) {
          if (editing == null) {
            _addGuest(item);
          } else {
            _updateGuest(item);
          }
        },
        nextId: _nextGuestId++,
      ),
    );
  }

  void _openCategoryModal() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => _CategoryFormModal(
        onAdd: _addCategory,
      ),
    );
  }

  void _openDeleteModal(GuestItem guest) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => _DeleteConfirmModal(
        guestName: guest.name,
        onConfirm: () => _deleteGuest(guest.id),
      ),
    );
  }

  // ══════════════════════════════════════════
  // Build
  // ══════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final visiting = filtered.where((g) =>
      g.visitStatus == VisitStatus.planned || g.visitStatus == VisitStatus.done
    ).length;
    final totalAmt = filtered.fold(0, (s, g) => s + g.amount);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              _buildCatStrip(),
              _buildStats(filtered.length, visiting, totalAmt),
              if (_selectedIds.isNotEmpty) _buildBulkStrip(),
              Expanded(child: _buildList(filtered)),
            ],
          ),
          // FAB
          Positioned(
            bottom: 24,
            right: 20,
            child: _buildFab(),
          ),
        ],
      ),
    );
  }

  // ── 헤더
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 상단: 로고 + 액션 아이콘
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.chevron_left, size: 20, color: Color(0xFF555555)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'weddly',
                    style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800,
                      color: AppColors.primary, fontStyle: FontStyle.italic,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Spacer(),
                  _iconBtn(Icons.notifications_none_rounded),
                  const SizedBox(width: 6),
                  _iconBtn(Icons.person_outline_rounded),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
            // 하단: 페이지 제목 + 정렬
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
              child: Row(
                children: [
                  const Text(
                    '하객관리',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF222222)),
                  ),
                  const Spacer(),
                  _buildSortDropdown(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon) {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(icon, size: 18, color: const Color(0xFF666666)),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _sortBy,
          isDense: true,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF555555)),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFFAAAAAA)),
          items: const [
            DropdownMenuItem(value: 'name',   child: Text('이름순')),
            DropdownMenuItem(value: 'visit',  child: Text('방문 여부')),
            DropdownMenuItem(value: 'amount', child: Text('축의금 높은순')),
          ],
          onChanged: (v) {
            if (v != null) setState(() => _sortBy = v);
          },
        ),
      ),
    );
  }

  // ── 카테고리 스트립
  Widget _buildCatStrip() {
    return Container(
      height: 54,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          ..._categories.map((cat) {
            final isActive = cat.id == _activeCategoryId;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _activeCategoryId = cat.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : const Color(0xFFF8F8F8),
                    border: Border.all(
                      color: isActive ? AppColors.primary : const Color(0xFFEEEEEE),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isActive ? [
                      BoxShadow(color: AppColors.primary.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 2)),
                    ] : [],
                  ),
                  child: Text(
                    cat.name,
                    style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : const Color(0xFFAAAAAA),
                    ),
                  ),
                ),
              ),
            );
          }),
          // 카테고리 추가 버튼
          GestureDetector(
            onTap: _openCategoryModal,
            child: Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFCCCCCC), width: 1.5, style: BorderStyle.solid),
              ),
              child: const Icon(Icons.add, size: 18, color: Color(0xFFCCCCCC)),
            ),
          ),
        ],
      ),
    );
  }

  // ── 통계 바
  Widget _buildStats(int guestCount, int visiting, int totalAmt) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          _statItem('$guestCount명', '하객', AppColors.primary),
          _statDivider(),
          _statItem('$visiting명', '방문 예정/완료', const Color(0xFF5B9BD5)),
          _statDivider(),
          _statItem(_fmtAmount(totalAmt), '총 축의금', const Color(0xFF70B56E)),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFFBBBBBB), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _statDivider() {
    return Container(width: 1, height: 30, color: const Color(0xFFEEEEEE));
  }

  // ── 일괄 액션 스트립
  Widget _buildBulkStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFAF3),
        border: Border(bottom: BorderSide(color: Color(0xFFF0E8D0))),
      ),
      child: Row(
        children: [
          Text(
            '${_selectedIds.length}명 선택',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF444444)),
          ),
          const Spacer(),
          _bulkBtn('✓ 방문완료', const Color(0xFF55A052), const Color(0x1F70B56E), _bulkSetVisit),
          const SizedBox(width: 6),
          _bulkBtn('✉ 청첩장완료', const Color(0xFFC49050), const Color(0x33D4A96A), _bulkSetInvite),
          const SizedBox(width: 6),
          _bulkBtn('취소', const Color(0xFF888888), const Color(0xFFF0F0F0),
            () => setState(() => _selectedIds.clear()),
          ),
        ],
      ),
    );
  }

  Widget _bulkBtn(String label, Color textColor, Color bgColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textColor)),
      ),
    );
  }

  // ── 하객 목록
  Widget _buildList(List<GuestItem> guests) {
    if (guests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('👥', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            const Text('등록된 하객이 없습니다.', style: TextStyle(fontSize: 13, color: Color(0xFFCCCCCC))),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      itemCount: guests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _buildGuestCard(guests[i]),
    );
  }

  Widget _buildGuestCard(GuestItem guest) {
    final isSelected = _selectedIds.contains(guest.id);
    final barColor   = _catColor(guest.category);

    return GestureDetector(
      onTap: () => _openGuestModal(editing: guest),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 6, offset: const Offset(0, 1))],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 체크박스
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) { _selectedIds.remove(guest.id); }
                    else { _selectedIds.add(guest.id); }
                  });
                },
                child: Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 18, height: 18,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      border: Border.all(
                        color: isSelected ? AppColors.primary : const Color(0xFFDDDDDD),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: isSelected
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                  ),
                ),
              ),
              // 컬러 바
              Container(width: 5, color: barColor),
              // 카드 본문
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 1행: 이름 + 축의금
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              guest.name,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF222222)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            _fmtAmount(guest.amount),
                            style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700,
                              color: guest.amount == 0 ? const Color(0xFFCCCCCC) : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // 2행: 배지들 + 동반인원
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 4,
                              children: [
                                _badge(guest.category, const Color(0xFFF0F0F0), const Color(0xFF888888)),
                                _visitBadge(guest.visitStatus),
                                _inviteBadge(guest.inviteStatus),
                              ],
                            ),
                          ),
                          if (guest.companions > 0)
                            Text(
                              '+${guest.companions}명',
                              style: const TextStyle(fontSize: 11, color: Color(0xFFBBBBBB), fontWeight: FontWeight.w500),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // 삭제 버튼
              GestureDetector(
                onTap: () => _openDeleteModal(guest),
                child: Container(
                  width: 40,
                  decoration: const BoxDecoration(
                    border: Border(left: BorderSide(color: Color(0xFFF5F5F5))),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFE0A0A0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg)),
    );
  }

  Widget _visitBadge(VisitStatus status) {
    switch (status) {
      case VisitStatus.none:
        return _badge('미정', const Color(0xFFF0F0F0), const Color(0xFFBBBBBB));
      case VisitStatus.planned:
        return _badge('방문예정', const Color(0x1F5B9BD5), const Color(0xFF5B9BD5));
      case VisitStatus.done:
        return _badge('방문완료', const Color(0x1F70B56E), const Color(0xFF70B56E));
    }
  }

  Widget _inviteBadge(InviteStatus status) {
    switch (status) {
      case InviteStatus.notSent:
        return _badge('미발송', const Color(0xFFF0F0F0), const Color(0xFFBBBBBB));
      case InviteStatus.sent:
        return _badge('청첩장발송', const Color(0x1FD4A96A), const Color(0xFFC49050));
    }
  }

  // ── FAB
  Widget _buildFab() {
    return GestureDetector(
      onTap: () => _openGuestModal(),
      child: Container(
        width: 54, height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.primaryGradient,
          ),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.55), blurRadius: 18, offset: const Offset(0, 4))],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
      ),
    );
  }
}

// ══════════════════════════════════════════
// 하객 등록/수정 모달
// ══════════════════════════════════════════

class _GuestFormModal extends StatefulWidget {
  final List<GuestCategory> categories;
  final GuestItem? editing;
  final void Function(GuestItem) onSave;
  final int nextId;

  const _GuestFormModal({
    required this.categories,
    required this.onSave,
    required this.nextId,
    this.editing,
  });

  @override
  State<_GuestFormModal> createState() => _GuestFormModalState();
}

class _GuestFormModalState extends State<_GuestFormModal> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _compCtrl;
  late final TextEditingController _amtCtrl;
  late final TextEditingController _memoCtrl;
  late String       _selectedCatId;
  late VisitStatus  _visitStatus;
  late InviteStatus _inviteStatus;

  @override
  void initState() {
    super.initState();
    final e = widget.editing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _compCtrl = TextEditingController(text: (e?.companions ?? 0).toString());
    _amtCtrl  = TextEditingController(text: (e?.amount ?? 0).toString());
    _memoCtrl = TextEditingController(text: e?.memo ?? '');
    _visitStatus  = e?.visitStatus  ?? VisitStatus.none;
    _inviteStatus = e?.inviteStatus ?? InviteStatus.notSent;

    // 카테고리 초기값
    if (e != null && widget.categories.any((c) => c.name == e.category)) {
      _selectedCatId = widget.categories.firstWhere((c) => c.name == e.category).id;
    } else {
      _selectedCatId = widget.categories.isNotEmpty ? widget.categories.first.id : '';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _compCtrl.dispose();
    _amtCtrl.dispose();
    _memoCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    final cat = widget.categories.firstWhere(
      (c) => c.id == _selectedCatId,
      orElse: () => widget.categories.first,
    );
    final item = GuestItem(
      id:           widget.editing?.id ?? widget.nextId,
      name:         name,
      category:     cat.name,
      companions:   int.tryParse(_compCtrl.text) ?? 0,
      visitStatus:  _visitStatus,
      inviteStatus: _inviteStatus,
      amount:       int.tryParse(_amtCtrl.text) ?? 0,
      memo:         _memoCtrl.text.trim(),
    );
    widget.onSave(item);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editing != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 360, maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 60, offset: const Offset(0, 20))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            _modalHeader(isEdit ? '하객 수정' : '하객 등록'),
            // 바디
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _field('이름 *', _inputField(_nameCtrl, '하객 이름을 입력하세요')),
                    const SizedBox(height: 14),
                    _field('카테고리 *', _catDropdown()),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: _field('동반 인원', _inputField(_compCtrl, '0', inputType: TextInputType.number))),
                        const SizedBox(width: 10),
                        Expanded(child: _field('축의금 (원)', _inputField(_amtCtrl, '0', inputType: TextInputType.number))),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _field('방문 여부', _visitSegment()),
                    const SizedBox(height: 14),
                    _field('청첩장 발송', _inviteSegment()),
                    const SizedBox(height: 14),
                    _field('비고', _textArea(_memoCtrl, '메모를 입력하세요')),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // 푸터
            _modalFooter(_save),
          ],
        ),
      ),
    );
  }

  Widget _modalHeader(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF222222))),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF888888)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modalFooter(VoidCallback onSave) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
              child: const Text('취소', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF888888))),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: onSave,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.primaryGradient,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 3))],
                ),
                child: const Center(
                  child: Text('저장', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF555555))),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _inputField(TextEditingController ctrl, String hint, {TextInputType? inputType}) {
    return TextField(
      controller: ctrl,
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      style: const TextStyle(fontSize: 14, color: Color(0xFF222222)),
    );
  }

  Widget _textArea(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      maxLines: 2,
      maxLength: 80,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        counterStyle: const TextStyle(fontSize: 11, color: Color(0xFFCCCCCC)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      style: const TextStyle(fontSize: 14, color: Color(0xFF222222)),
    );
  }

  Widget _catDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCatId,
          isExpanded: true,
          style: const TextStyle(fontSize: 14, color: Color(0xFF222222)),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFFAAAAAA)),
          items: widget.categories.map((cat) => DropdownMenuItem(
            value: cat.id,
            child: Text(cat.name),
          )).toList(),
          onChanged: (v) { if (v != null) setState(() => _selectedCatId = v); },
        ),
      ),
    );
  }

  Widget _visitSegment() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          _segItem('미정',    VisitStatus.none,    _visitStatus == VisitStatus.none,    const Color(0xFF222222)),
          _segItem('방문예정', VisitStatus.planned, _visitStatus == VisitStatus.planned, const Color(0xFF5B9BD5)),
          _segItem('방문완료', VisitStatus.done,    _visitStatus == VisitStatus.done,    const Color(0xFF70B56E)),
        ],
      ),
    );
  }

  Widget _inviteSegment() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          _inviteItem('미발송',   InviteStatus.notSent, _inviteStatus == InviteStatus.notSent, const Color(0xFF222222)),
          _inviteItem('발송완료', InviteStatus.sent,    _inviteStatus == InviteStatus.sent,    AppColors.primary),
        ],
      ),
    );
  }

  Widget _segItem(String label, VisitStatus val, bool selected, Color activeColor) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _visitStatus = val),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 1))] : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600,
              color: selected ? activeColor : const Color(0xFFBBBBBB),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inviteItem(String label, InviteStatus val, bool selected, Color activeColor) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _inviteStatus = val),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 1))] : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600,
              color: selected ? activeColor : const Color(0xFFBBBBBB),
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════
// 카테고리 추가 모달
// ══════════════════════════════════════════

class _CategoryFormModal extends StatefulWidget {
  final void Function(String name, Color color) onAdd;
  const _CategoryFormModal({required this.onAdd});

  @override
  State<_CategoryFormModal> createState() => _CategoryFormModalState();
}

class _CategoryFormModalState extends State<_CategoryFormModal> {
  final _nameCtrl = TextEditingController();
  Color _selectedColor = const Color(0xFF70B56E);

  static const _colors = [
    Color(0xFF70B56E),
    Color(0xFFFF9800),
    Color(0xFF26C6DA),
    Color(0xFFAB47BC),
    Color(0xFFEC407A),
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _add() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    widget.onAdd(name, _selectedColor);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 60, offset: const Offset(0, 20))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0)))),
              child: Row(
                children: [
                  const Text('카테고리 추가', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF222222))),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(9)),
                      child: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF888888)),
                    ),
                  ),
                ],
              ),
            ),
            // 바디
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('카테고리 이름 *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF555555))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameCtrl,
                    maxLength: 10,
                    decoration: InputDecoration(
                      hintText: '예) 동창회, 군대 등',
                      hintStyle: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
                      filled: true, fillColor: const Color(0xFFF8F8F8),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                      counterStyle: const TextStyle(fontSize: 11, color: Color(0xFFCCCCCC)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 1.5)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 1.5)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                    ),
                    style: const TextStyle(fontSize: 14, color: Color(0xFF222222)),
                  ),
                  const SizedBox(height: 14),
                  const Text('색상 선택', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF555555))),
                  const SizedBox(height: 10),
                  Row(
                    children: _colors.map((c) {
                      final isSelected = c == _selectedColor;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedColor = c),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 30, height: 30,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: isSelected ? Border.all(color: Colors.black26, width: 3) : null,
                              boxShadow: isSelected ? [BoxShadow(color: c.withOpacity(0.5), blurRadius: 8)] : [],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            // 푸터
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
                      child: const Text('취소', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF888888))),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: _add,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                            colors: AppColors.primaryGradient,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('추가', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                        ),
                      ),
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
}

// ══════════════════════════════════════════
// 삭제 확인 모달
// ══════════════════════════════════════════

class _DeleteConfirmModal extends StatelessWidget {
  final String guestName;
  final VoidCallback onConfirm;

  const _DeleteConfirmModal({required this.guestName, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Container(
        width: 300,
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 60, offset: const Offset(0, 20))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🗑️', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 12),
            const Text(
              '하객을 삭제할까요?',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF222222)),
            ),
            const SizedBox(height: 8),
            Text(
              '$guestName 하객 정보를 삭제하면 복구할 수 없습니다.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF888888), height: 1.6),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                        child: Text('취소', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF888888))),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(color: const Color(0xFFF44336), borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                        child: Text('삭제', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
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
