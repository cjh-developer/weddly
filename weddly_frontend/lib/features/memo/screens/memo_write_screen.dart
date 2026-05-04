import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

// ══════════════════════════════════════════
// Model
// ══════════════════════════════════════════

class MemoNote {
  final int       id;
  final String    title;
  final String    content;
  final String?   folderId;
  final String?   folderName;
  final Color?    color;
  final DateTime? noteDate;

  const MemoNote({
    required this.id,
    required this.title,
    required this.content,
    this.folderId,
    this.folderName,
    this.color,
    this.noteDate,
  });

  MemoNote copyWith({
    String?   title,
    String?   content,
    String?   folderId,
    String?   folderName,
    Color?    color,
    DateTime? noteDate,
    bool clearColor  = false,
    bool clearDate   = false,
    bool clearFolder = false,
  }) {
    return MemoNote(
      id:         id,
      title:      title      ?? this.title,
      content:    content    ?? this.content,
      folderId:   clearFolder ? null : (folderId   ?? this.folderId),
      folderName: clearFolder ? null : (folderName ?? this.folderName),
      color:      clearColor  ? null : (color      ?? this.color),
      noteDate:   clearDate   ? null : (noteDate   ?? this.noteDate),
    );
  }
}

// ══════════════════════════════════════════
// 색상 상수 (HTML memo_write.html 동일)
// ══════════════════════════════════════════

const _kColorNone    = null;
const _kColorGold    = Color(0xFFD4A96A);
const _kColorRed     = Color(0xFFE07070);
const _kColorGreen   = Color(0xFF5BAD7F);
const _kColorBlue    = Color(0xFF5B8AF0);
const _kColorPurple  = Color(0xFF9C6BC4);

const List<Color?> _kColorOptions = [
  _kColorNone,
  _kColorGold,
  _kColorRed,
  _kColorGreen,
  _kColorBlue,
  _kColorPurple,
];

// ══════════════════════════════════════════
// MemoWriteScreen
// ══════════════════════════════════════════

class MemoWriteScreen extends StatefulWidget {
  final MemoNote? editing;
  final void Function(MemoNote) onSave;
  final void Function(int)?     onDelete;
  final int nextId;

  const MemoWriteScreen({
    super.key,
    required this.onSave,
    this.editing,
    this.onDelete,
    this.nextId = 100,
  });

  @override
  State<MemoWriteScreen> createState() => _MemoWriteScreenState();
}

class _MemoWriteScreenState extends State<MemoWriteScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;
  late Color?    _selectedColor;
  late DateTime? _selectedDate;
  bool _showColorPalette = false;

  @override
  void initState() {
    super.initState();
    final e = widget.editing;
    _titleCtrl   = TextEditingController(text: e?.title   ?? '');
    _contentCtrl = TextEditingController(text: e?.content ?? '');
    _selectedColor = e?.color;
    _selectedDate  = e?.noteDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  // ── 포맷
  String _fmtDate(DateTime? d) {
    if (d == null) return '날짜';
    return '${d.year}.${_p2(d.month)}.${_p2(d.day)}';
  }

  String _fmtTime(DateTime? d) {
    if (d == null) return '시간';
    return '${_p2(d.hour)}:${_p2(d.minute)}';
  }

  String _p2(int n) => n.toString().padLeft(2, '0');

  // ── 저장
  void _save() {
    final title   = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();
    if (title.isEmpty && content.isEmpty) {
      Navigator.pop(context);
      return;
    }
    final note = MemoNote(
      id:         widget.editing?.id ?? widget.nextId,
      title:      title.isEmpty ? '제목 없음' : title,
      content:    content,
      folderId:   widget.editing?.folderId,
      folderName: widget.editing?.folderName,
      color:      _selectedColor,
      noteDate:   _selectedDate,
    );
    widget.onSave(note);
    Navigator.pop(context);
  }

  // ── 날짜 선택
  void _openDatePicker() async {
    final now    = DateTime.now();
    final initial = _selectedDate ?? now;
    final picked  = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate:   DateTime(2020),
      lastDate:    DateTime(2035),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedDate = DateTime(
          picked.year, picked.month, picked.day,
          _selectedDate?.hour   ?? 0,
          _selectedDate?.minute ?? 0,
        );
      });
    }
  }

  // ── 시간 선택
  void _openTimePicker() async {
    final init   = TimeOfDay(hour: _selectedDate?.hour ?? 0, minute: _selectedDate?.minute ?? 0);
    final picked = await showTimePicker(
      context: context,
      initialTime: init,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      final base = _selectedDate ?? DateTime.now();
      setState(() {
        _selectedDate = DateTime(base.year, base.month, base.day, picked.hour, picked.minute);
      });
    }
  }

  // ── 삭제 확인
  void _confirmDelete() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => _DeleteConfirmModal(
        onConfirm: () {
          widget.onDelete?.call(widget.editing!.id);
          Navigator.pop(context);
        },
      ),
    );
  }

  // ══════════════════════════════════════════
  // Build
  // ══════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editing != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. 메인 헤더 (로고 + 알림 + 프로필)
            _buildMainHeader(),
            // 2. 서브 헤더 (뒤로 + 제목 + 저장)
            _buildWriteHeader(isEdit),
            // 3. 색상 강조 바 (4px)
            _buildColorAccentBar(),
            // 4. 스크롤 영역
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWriteArea(),
                  ],
                ),
              ),
            ),
            // 5. 하단 툴바
            _buildToolbar(isEdit),
            // 6. 저작권
            _buildCopyright(),
          ],
        ),
      ),
    );
  }

  // ── 1. 메인 헤더
  Widget _buildMainHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      decoration: const BoxDecoration(
        color: Color(0xF5FFFFFF),
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
      ),
      child: Row(
        children: [
          const Text(
            'weddly',
            style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w800,
              color: AppColors.primary, fontStyle: FontStyle.italic,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          _iconBtn(Icons.notifications_none_rounded),
          const SizedBox(width: 8),
          _iconBtn(Icons.person_outline_rounded),
        ],
      ),
    );
  }

  // ── 2. 서브 헤더 (뒤로 | 제목 | 저장)
  Widget _buildWriteHeader(bool isEdit) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: const BoxDecoration(
        color: Color(0xF5FFFFFF),
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
      ),
      child: Row(
        children: [
          // 뒤로가기
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: _iconBtn(Icons.chevron_left_rounded),
          ),
          // 제목 (중앙)
          Expanded(
            child: Text(
              isEdit ? '메모 편집' : '새 메모',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700,
                color: Color(0xFF222222), letterSpacing: -0.3,
              ),
            ),
          ),
          // 저장 버튼
          GestureDetector(
            onTap: _save,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.primaryGradient,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                '저장',
                style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 3. 색상 강조 바
  Widget _buildColorAccentBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 4,
      color: _selectedColor ?? Colors.transparent,
    );
  }

  // ── 4. 작성 영역 (memo_write.html .write-area 동일)
  // 순서: 제목 → 날짜/시간 칩 → 구분선 → 내용
  // 카드/컨테이너 없이 흰 배경 위에 직접 배치
  Widget _buildWriteArea() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ① 제목
          TextField(
            controller: _titleCtrl,
            maxLength: 50,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: '제목',
              hintStyle: TextStyle(
                color: Color(0xFFDDDDDD),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              counterText: '',
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w700,
              color: Color(0xFF222222), letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 14),

          // ② 날짜·시간 칩 — .meta-chip.is-set, mb:14
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _metaChip(
                icon: Icons.calendar_today_rounded,
                text: _fmtDate(_selectedDate),
                onTap: _openDatePicker,
              ),
              _metaChip(
                icon: Icons.access_time_rounded,
                text: _fmtTime(_selectedDate),
                onTap: _openTimePicker,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ③ 구분선 — height:1px, color:#f0f0f0, mb:14
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 14),

          // ④ 내용 — font-size:14px, color:#444, line-height:1.8, placeholder:#ddd, min-height:200
          TextField(
            controller: _contentCtrl,
            maxLines: null,
            minLines: 14,
            decoration: const InputDecoration(
              hintText: '내용을 입력하세요...',
              hintStyle: TextStyle(color: Color(0xFFDDDDDD), fontSize: 14),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF444444),
              height: 1.8,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── 메타 칩 (날짜/시간) — is-set 스타일 항상 적용 (값 있으면)
  Widget _metaChip({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final isSet = _selectedDate != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color:  isSet ? const Color(0xFFFFF8EF) : const Color(0xFFF5F5F5),
          border: Border.all(
            color: isSet ? const Color(0xFFF0E8D8) : Colors.transparent,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13,
              color: isSet ? const Color(0xFFC49050) : const Color(0xFF888888)),
            const SizedBox(width: 5),
            Text(
              text,
              style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500,
                color: isSet ? const Color(0xFFC49050) : const Color(0xFF888888),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 5. 하단 툴바
  Widget _buildToolbar(bool isEdit) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xF7FFFFFF),
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 툴바 버튼 행
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 8),
            child: Row(
              children: [
                // 첨부파일 버튼 (디자인 용, 기능 미구현)
                _toolbarBtn(
                  icon: Icons.attach_file_rounded,
                  active: false,
                  onTap: () {},
                ),
                // 색상 버튼
                _toolbarBtn(
                  icon: Icons.palette_outlined,
                  active: _showColorPalette,
                  onTap: () => setState(() => _showColorPalette = !_showColorPalette),
                ),
                const Spacer(),
                // 편집 모드: 삭제 버튼
                if (isEdit)
                  _toolbarBtn(
                    icon: Icons.delete_outline_rounded,
                    active: false,
                    activeColor: const Color(0xFFF44336),
                    onTap: _confirmDelete,
                  ),
              ],
            ),
          ),
          // 색상 팔레트 (토글)
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _showColorPalette
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Text(
                    '색상',
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600,
                      color: Color(0xFFBBBBBB),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ..._kColorOptions.map((c) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _selectedColor = c;
                        _showColorPalette = false;
                      }),
                      child: _colorSwatch(c),
                    ),
                  )),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _toolbarBtn({
    required IconData icon,
    required bool active,
    Color? activeColor,
    required VoidCallback onTap,
  }) {
    final color = active
        ? (activeColor ?? AppColors.primary)
        : const Color(0xFF888888);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFFF8EF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }

  // 색상 스와치 (26×26, circle)
  Widget _colorSwatch(Color? c) {
    final isSelected = _selectedColor == c;
    if (c == null) {
      // 없음: 흰 배경 + 취소선
      return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 26, height: 26,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? const Color(0xFF888888) : const Color(0xFFDDDDDD),
            width: 2.5,
          ),
        ),
        child: CustomPaint(painter: _StrikePainter()),
      );
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 26, height: 26,
      decoration: BoxDecoration(
        color: c,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? const Color(0xFF333333) : Colors.transparent,
          width: 2.5,
        ),
      ),
    );
  }

  // ── 6. 저작권
  Widget _buildCopyright() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      child: const Text(
        '© 2025 Weddly. All rights reserved.\n당신의 특별한 날을 함께해요 💍',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11, color: Color(0xFFCCCCCC),
          letterSpacing: 0.2, height: 1.8,
        ),
      ),
    );
  }

  // ── 공통 아이콘 버튼
  Widget _iconBtn(IconData icon) {
    return Container(
      width: 38, height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 20, color: const Color(0xFF666666)),
    );
  }
}

// ══════════════════════════════════════════
// 삭제 확인 모달 (중앙 Dialog)
// ══════════════════════════════════════════

class _DeleteConfirmModal extends StatelessWidget {
  final VoidCallback onConfirm;
  const _DeleteConfirmModal({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 60,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '메모를 삭제할까요?',
              style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF222222),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '삭제하면 되돌릴 수 없습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF888888), height: 1.6),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('취소',
                          style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF888888),
                          )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('삭제',
                          style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFF44336),
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

// ── 취소선 painter (색상 없음 스와치)
class _StrikePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.8, size.height * 0.2),
      Paint()
        ..color = const Color(0xFFCCCCCC)
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
