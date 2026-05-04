import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'memo_write_screen.dart';

// ══════════════════════════════════════════
// Models
// ══════════════════════════════════════════

class MemoFolder {
  final String id;
  final String name;

  const MemoFolder({required this.id, required this.name});
}

// ══════════════════════════════════════════
// Sample Data
// ══════════════════════════════════════════

int _nextNoteId   = 20;
int _nextFolderId = 10;

final List<MemoFolder> _defaultFolders = [
  const MemoFolder(id: 'f1', name: '웨딩 준비'),
  const MemoFolder(id: 'f2', name: '업체 메모'),
  const MemoFolder(id: 'f3', name: '신혼여행'),
];

final List<MemoNote> _defaultNotes = [
  MemoNote(id: 1, title: '드레스 피팅 메모', content: '1차 피팅 완료. 허리 수선 필요. 2차 일정 확인 중.', folderId: 'f1', folderName: '웨딩 준비', color: const Color(0xFFD4A96A), noteDate: DateTime(2026, 5, 1, 14, 0)),
  MemoNote(id: 2, title: '꽃 장식 업체 연락처', content: '010-1234-5678 / 견적 250만원', folderId: 'f2', folderName: '업체 메모', color: const Color(0xFF5BAD7F), noteDate: DateTime(2026, 4, 28, 10, 30)),
  MemoNote(id: 3, title: '하와이 여행 체크리스트', content: '여권, 비자, 숙소 예약 완료. 항공권 재확인 필요.', folderId: 'f3', folderName: '신혼여행', color: const Color(0xFF5B8AF0), noteDate: DateTime(2026, 4, 25, 9, 0)),
  MemoNote(id: 4, title: '스드메 비교 메모', content: '스튜디오 A vs B 비교. A 더 자연스러운 느낌.', folderId: 'f1', folderName: '웨딩 준비', noteDate: DateTime(2026, 4, 20, 16, 0)),
  MemoNote(id: 5, title: '기타 메모', content: '웨딩홀 주차 정보 확인. 하객 식사 메뉴 결정 필요.', noteDate: DateTime(2026, 4, 15, 11, 0)),
];

// ══════════════════════════════════════════
// Screen
// ══════════════════════════════════════════

class MemoScreen extends StatefulWidget {
  const MemoScreen({super.key});

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

enum _MemoTab { all, folder, note }

class _MemoScreenState extends State<MemoScreen> {
  _MemoTab _activeTab = _MemoTab.all;
  final List<MemoFolder> _folders = List.from(_defaultFolders);
  final List<MemoNote>   _notes   = List.from(_defaultNotes);

  bool _fabOpen = false;

  // ── CRUD
  void _addNote(MemoNote note)    => setState(() => _notes.add(note));
  void _updateNote(MemoNote note) => setState(() {
    final i = _notes.indexWhere((n) => n.id == note.id);
    if (i != -1) _notes[i] = note;
  });
  void _deleteNote(int id)        => setState(() => _notes.removeWhere((n) => n.id == id));
  void _deleteFolder(String id)   => setState(() {
    _folders.removeWhere((f) => f.id == id);
    _notes.removeWhere((n) => n.folderId == id);
  });
  void _addFolder(String name)    => setState(() {
    _folders.add(MemoFolder(id: 'f${_nextFolderId++}', name: name));
  });

  // ── 필터
  List<MemoNote> get _filteredNotes {
    switch (_activeTab) {
      case _MemoTab.all:    return _notes;
      case _MemoTab.folder: return [];
      case _MemoTab.note:   return _notes;
    }
  }

  List<MemoFolder> get _filteredFolders {
    switch (_activeTab) {
      case _MemoTab.all:    return _folders;
      case _MemoTab.folder: return _folders;
      case _MemoTab.note:   return [];
    }
  }

  // ── 날짜 포맷
  String _fmtDate(DateTime? d) {
    if (d == null) return '';
    return '${d.year}.${d.month.toString().padLeft(2,'0')}.${d.day.toString().padLeft(2,'0')}';
  }

  // ── 모달
  void _openAddFolderModal() {
    setState(() => _fabOpen = false);
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => _AddFolderModal(onAdd: _addFolder),
    );
  }

  void _openDeleteFolderModal(MemoFolder folder) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => _ConfirmDeleteDialog(
        title: '폴더를 삭제할까요?',
        desc: '삭제하면 되돌릴 수 없습니다.\n폴더 내 모든 노트도 함께 삭제됩니다.',
        onConfirm: () => _deleteFolder(folder.id),
      ),
    );
  }

  void _openDeleteNoteModal(MemoNote note) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => _ConfirmDeleteDialog(
        title: '메모를 삭제할까요?',
        desc: '삭제하면 되돌릴 수 없습니다.',
        onConfirm: () => _deleteNote(note.id),
      ),
    );
  }

  void _openWriteScreen({MemoNote? editing}) {
    setState(() => _fabOpen = false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MemoWriteScreen(
          editing:  editing,
          nextId:   _nextNoteId++,
          onSave:   editing == null ? _addNote : _updateNote,
          onDelete: editing != null ? _deleteNote : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildTabs(),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
          // FAB 배경막
          if (_fabOpen)
            GestureDetector(
              onTap: () => setState(() => _fabOpen = false),
              child: Container(color: Colors.black.withOpacity(0.18)),
            ),
          // FAB
          Positioned(
            bottom: 24, right: 18,
            child: _buildFab(),
          ),
        ],
      ),
    );
  }

  // ── 헤더
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.chevron_left, size: 22, color: Color(0xFF666666)),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'weddly',
            style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w800,
              color: AppColors.primary, fontStyle: FontStyle.italic, letterSpacing: -0.5,
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

  Widget _iconBtn(IconData icon) {
    return Container(
      width: 38, height: 38,
      decoration: BoxDecoration(color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, size: 19, color: const Color(0xFF666666)),
    );
  }

  // ── 탭
  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: [
          _tabItem('전체',  _MemoTab.all),
          const SizedBox(width: 6),
          _tabItem('폴더',  _MemoTab.folder),
          const SizedBox(width: 6),
          _tabItem('노트',  _MemoTab.note),
        ],
      ),
    );
  }

  Widget _tabItem(String label, _MemoTab tab) {
    final isActive = _activeTab == tab;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
        decoration: BoxDecoration(
          gradient: isActive ? const LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: AppColors.primaryGradient,
          ) : null,
          color: isActive ? null : Colors.white,
          border: Border.all(
            color: isActive ? Colors.transparent : const Color(0xFFE8E8E8),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF888888),
          ),
        ),
      ),
    );
  }

  // ── 콘텐츠
  Widget _buildContent() {
    final folders = _filteredFolders;
    final notes   = _filteredNotes;

    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: [
        if (folders.isNotEmpty) ...[
          _sectionHeader('폴더', folders.length),
          ...folders.map((f) => _buildFolderCard(f)),
        ],
        if (notes.isNotEmpty) ...[
          _sectionHeader('노트', notes.length),
          ...notes.map((n) => _buildNoteCard(n)),
        ],
        if (folders.isEmpty && notes.isEmpty)
          _emptyState(),
      ],
    );
  }

  Widget _sectionHeader(String label, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
      child: Row(
        children: [
          Text(label.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFAAAAAA), letterSpacing: 0.5)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: const Color(0xFFFFF8EF), borderRadius: BorderRadius.circular(10)),
            child: Text('$count', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  // ── 폴더 카드
  Widget _buildFolderCard(MemoFolder folder) {
    final noteCount = _notes.where((n) => n.folderId == folder.id).length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          border: Border.all(color: const Color(0xFFF0F0F0), width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // 폴더 아이콘
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [Color(0xFFF7EEDD), Color(0xFFEEDBB5)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.folder_rounded, color: Color(0xFFC49050), size: 22),
            ),
            const SizedBox(width: 12),
            // 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(folder.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF222222)), overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text('노트 $noteCount개', style: const TextStyle(fontSize: 11, color: Color(0xFFBBBBBB), fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            // 삭제 버튼
            GestureDetector(
              onTap: () => _openDeleteFolderModal(folder),
              child: Container(
                width: 30, height: 30,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFDDDDDD)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 노트 카드
  Widget _buildNoteCard(MemoNote note) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: GestureDetector(
        onTap: () => _openWriteScreen(editing: note),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFF0F0F0), width: 1.5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 색상 바
                if (note.color != null)
                  Container(
                    width: 5,
                    decoration: BoxDecoration(
                      color: note.color,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                    ),
                  ),
                // 본문
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 13, 12, 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF222222)),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (note.content.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            note.content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA), fontWeight: FontWeight.w500, height: 1.5),
                          ),
                        ],
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            Text(_fmtDate(note.noteDate), style: const TextStyle(fontSize: 11, color: Color(0xFFCCCCCC), fontWeight: FontWeight.w500)),
                            if (note.folderName != null) ...[
                              const SizedBox(width: 7),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                                decoration: BoxDecoration(color: const Color(0xFFFFF8EF), borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.folder_open_rounded, size: 11, color: AppColors.primary),
                                    const SizedBox(width: 3),
                                    Text(note.folderName!, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // 삭제 버튼
                GestureDetector(
                  onTap: () => _openDeleteNoteModal(note),
                  child: Container(
                    width: 36,
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: Color(0xFFF5F5F5))),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                    ),
                    child: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFDDDDDD)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── 빈 상태
  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: const [
          Text('📝', style: TextStyle(fontSize: 40)),
          SizedBox(height: 10),
          Text('메모가 없습니다.', style: TextStyle(fontSize: 13, color: Color(0xFFCCCCCC), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // ── FAB
  Widget _buildFab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // FAB 메뉴
        AnimatedOpacity(
          opacity: _fabOpen ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedSlide(
            offset: _fabOpen ? Offset.zero : const Offset(0, 0.3),
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !_fabOpen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _fabMenuItem(
                    icon: Icons.folder_rounded,
                    label: '폴더 추가',
                    iconBg: const [Color(0xFFF7EEDD), Color(0xFFEEDBB5)],
                    iconColor: const Color(0xFFC49050),
                    onTap: _openAddFolderModal,
                  ),
                  const SizedBox(height: 8),
                  _fabMenuItem(
                    icon: Icons.edit_note_rounded,
                    label: '노트 추가',
                    iconBg: AppColors.primaryGradient,
                    iconColor: Colors.white,
                    onTap: () => _openWriteScreen(),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
        // FAB 버튼
        GestureDetector(
          onTap: () => setState(() => _fabOpen = !_fabOpen),
          child: AnimatedRotation(
            turns: _fabOpen ? 0.125 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: AppColors.primaryGradient,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.45), blurRadius: 16, offset: const Offset(0, 4))],
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fabMenuItem({
    required IconData icon,
    required String label,
    required List<Color> iconBg,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFEEEEEE), width: 1.5),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 14, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: iconBg),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════
// 폴더 추가 모달
// ══════════════════════════════════════════

class _AddFolderModal extends StatefulWidget {
  final void Function(String name) onAdd;
  const _AddFolderModal({required this.onAdd});

  @override
  State<_AddFolderModal> createState() => _AddFolderModalState();
}

class _AddFolderModalState extends State<_AddFolderModal> {
  final _ctrl = TextEditingController();

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _confirm() {
    final name = _ctrl.text.trim();
    if (name.isEmpty) return;
    widget.onAdd(name);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 60, offset: const Offset(0, 20))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 핸들 바
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: const Color(0xFFE8E8E8), borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 18),
            const Center(child: Text('폴더 추가', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF222222)))),
            const SizedBox(height: 4),
            const Center(child: Text('폴더 이름을 입력해 주세요.', style: TextStyle(fontSize: 13, color: Color(0xFF888888)))),
            const SizedBox(height: 14),
            TextField(
              controller: _ctrl,
              maxLength: 20,
              autofocus: true,
              decoration: InputDecoration(
                hintText: '폴더 이름',
                hintStyle: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
                filled: true, fillColor: const Color(0xFFF8F8F8),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                counterStyle: const TextStyle(fontSize: 11, color: Color(0xFFCCCCCC)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 1.5)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 1.5)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
              ),
              style: const TextStyle(fontSize: 14, color: Color(0xFF222222)),
              onSubmitted: (_) => _confirm(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
                      child: const Center(child: Text('취소', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF888888)))),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: _confirm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: AppColors.primaryGradient),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: const Center(child: Text('추가', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white))),
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
// 삭제 확인 모달 (중앙)
// ══════════════════════════════════════════

class _ConfirmDeleteDialog extends StatelessWidget {
  final String title;
  final String desc;
  final VoidCallback onConfirm;

  const _ConfirmDeleteDialog({required this.title, required this.desc, required this.onConfirm});

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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 60, offset: const Offset(0, 20))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF222222))),
            const SizedBox(height: 6),
            Text(desc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Color(0xFF888888), height: 1.6)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
                      child: const Center(child: Text('취소', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF888888)))),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () { Navigator.pop(context); onConfirm(); },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(color: const Color(0xFFFFF0F0), borderRadius: BorderRadius.circular(12)),
                      child: const Center(child: Text('삭제', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFF44336)))),
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
