import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_notifier.dart';
import '../../../core/theme/weddly_colors.dart';

// ══════════════════════════════════════════
// Model
// ══════════════════════════════════════════

class ScheduleEvent {
  final int id;
  final String title;
  final DateTime date;
  final String? startTime; // "HH:MM" 24h
  final String? endTime;
  final Color color;
  final String? memo;

  const ScheduleEvent({
    required this.id,
    required this.title,
    required this.date,
    this.startTime,
    this.endTime,
    required this.color,
    this.memo,
  });

  ScheduleEvent copyWith({
    String? title,
    DateTime? date,
    String? startTime,
    String? endTime,
    Color? color,
    String? memo,
    bool clearStartTime = false,
    bool clearEndTime = false,
    bool clearMemo = false,
  }) {
    return ScheduleEvent(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: clearStartTime ? null : (startTime ?? this.startTime),
      endTime: clearEndTime ? null : (endTime ?? this.endTime),
      color: color ?? this.color,
      memo: clearMemo ? null : (memo ?? this.memo),
    );
  }
}

// ══════════════════════════════════════════
// Constants
// ══════════════════════════════════════════

const _kEventColors = [
  Color(0xFFD4A96A),
  Color(0xFFE8758A),
  Color(0xFF5B9BD5),
  Color(0xFF70B56E),
  Color(0xFF9B76C8),
];
const _kWeekdayKr = ['일', '월', '화', '수', '목', '금', '토'];

final List<ScheduleEvent> _kSampleEvents = [
  ScheduleEvent(
    id: 1,
    title: '드레스 피팅',
    date: DateTime(2026, 5, 5),
    startTime: '14:00',
    endTime: '16:00',
    color: const Color(0xFFE8758A),
    memo: '강남 드레스샵 방문',
  ),
  ScheduleEvent(
    id: 2,
    title: '웨딩홀 미팅',
    date: DateTime(2026, 5, 1),
    startTime: '14:00',
    endTime: '15:30',
    color: const Color(0xFFD4A96A),
    memo: '세부 계획 논의',
  ),
  ScheduleEvent(
    id: 3,
    title: '스튜디오 촬영',
    date: DateTime(2026, 5, 15),
    startTime: '10:00',
    endTime: '18:00',
    color: const Color(0xFF5B9BD5),
    memo: '야외 촬영 포함',
  ),
  ScheduleEvent(
    id: 4,
    title: '신혼여행 준비',
    date: DateTime(2026, 5, 1),
    color: const Color(0xFF70B56E),
    memo: '여권/비자 확인',
  ),
  ScheduleEvent(
    id: 5,
    title: '메이크업 리허설',
    date: DateTime(2026, 5, 20),
    startTime: '10:00',
    endTime: '12:00',
    color: const Color(0xFF9B76C8),
  ),
  ScheduleEvent(
    id: 6,
    title: '부케 상담',
    date: DateTime(2026, 5, 8),
    startTime: '13:00',
    endTime: '14:00',
    color: const Color(0xFFE8758A),
    memo: '플라워샵 방문',
  ),
];

// ══════════════════════════════════════════
// ScheduleScreen
// ══════════════════════════════════════════

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _tabIndex = 0; // 0=월, 1=주, 2=일
  late DateTime _focusedDate;
  late DateTime _selectedDate;
  List<ScheduleEvent> _events = List.from(_kSampleEvents);
  int _nextId = _kSampleEvents.length + 1;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedDate = DateTime(now.year, now.month, now.day);
    _selectedDate = _focusedDate;
  }

  // ── Helpers

  DateTime get _today {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<ScheduleEvent> _eventsForDate(DateTime date) =>
      _events.where((e) => _isSameDay(e.date, date)).toList();

  String _dowKr(DateTime d) => _kWeekdayKr[d.weekday % 7];

  // Week starts on Sunday
  DateTime _weekStartOf(DateTime d) {
    final fromSun = d.weekday % 7; // Mon=1..Sat=6, Sun=0
    return DateTime(d.year, d.month, d.day - fromSun);
  }

  // Build 42-cell grid for the given month
  List<DateTime> _buildMonthGrid(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startPad = firstDay.weekday % 7; // 0=Sun

    final cells = <DateTime>[];
    for (int i = startPad; i > 0; i--) {
      cells.add(firstDay.subtract(Duration(days: i)));
    }
    for (int d = 1; d <= daysInMonth; d++) {
      cells.add(DateTime(year, month, d));
    }
    int nextDay = 1;
    while (cells.length < 42) {
      cells.add(DateTime(year, month + 1, nextDay++));
    }
    return cells;
  }

  String get _periodLabel {
    switch (_tabIndex) {
      case 0:
        return '${_focusedDate.year}년 ${_focusedDate.month}월';
      case 1:
        final ws = _weekStartOf(_focusedDate);
        final we = ws.add(const Duration(days: 6));
        if (ws.month == we.month) {
          return '${ws.year}년 ${ws.month}월';
        }
        return '${ws.month}월 ~ ${we.month}월';
      case 2:
        return '${_focusedDate.year}년 ${_focusedDate.month}월 ${_focusedDate.day}일';
      default:
        return '';
    }
  }

  void _goToPrev() => setState(() {
        switch (_tabIndex) {
          case 0:
            _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
            break;
          case 1:
            _focusedDate = _focusedDate.subtract(const Duration(days: 7));
            break;
          case 2:
            _focusedDate = _focusedDate.subtract(const Duration(days: 1));
            break;
        }
      });

  void _goToNext() => setState(() {
        switch (_tabIndex) {
          case 0:
            _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
            break;
          case 1:
            _focusedDate = _focusedDate.add(const Duration(days: 7));
            break;
          case 2:
            _focusedDate = _focusedDate.add(const Duration(days: 1));
            break;
        }
      });

  void _goToToday() => setState(() {
        _focusedDate = _today;
        _selectedDate = _today;
      });

  // ── CRUD

  void _addEvent(ScheduleEvent e) {
    setState(() {
      _events = [
        ..._events,
        ScheduleEvent(
          id: _nextId++,
          title: e.title,
          date: e.date,
          startTime: e.startTime,
          endTime: e.endTime,
          color: e.color,
          memo: e.memo,
        ),
      ];
    });
  }

  void _updateEvent(ScheduleEvent updated) {
    setState(() {
      _events = _events
          .map((e) => e.id == updated.id ? updated : e)
          .toList();
    });
  }

  void _deleteEvent(int id) {
    setState(() => _events = _events.where((e) => e.id != id).toList());
  }

  // ── Modals

  void _showAddModal({DateTime? initialDate}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.48),
      builder: (_) => _AddModal(
        initialDate: initialDate ?? _selectedDate,
        onSave: _addEvent,
      ),
    );
  }

  void _showEditModal(ScheduleEvent event) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.48),
      builder: (_) => _AddModal(
        initialDate: event.date,
        existingEvent: event,
        onSave: (_) {},
        onUpdate: _updateEvent,
      ),
    );
  }

  void _showDeleteModal(int eventId, String title) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.48),
      builder: (_) => _DeleteModal(
        title: title,
        onConfirm: () => _deleteEvent(eventId),
      ),
    );
  }

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
                _buildTabBar(),
                Expanded(
                  child: IndexedStack(
                    index: _tabIndex,
                    children: [
                      _MonthView(
                        focusedDate: _focusedDate,
                        selectedDate: _selectedDate,
                        today: _today,
                        events: _events,
                        monthGrid: _buildMonthGrid(
                            _focusedDate.year, _focusedDate.month),
                        isSameDay: _isSameDay,
                        eventsForDate: _eventsForDate,
                        dowKr: _dowKr,
                        onDaySelected: (d) =>
                            setState(() => _selectedDate = d),
                        onAddTap: () =>
                            _showAddModal(initialDate: _selectedDate),
                        onDelete: _showDeleteModal,
                        onEdit: _showEditModal,
                      ),
                      _WeekView(
                        focusedDate: _focusedDate,
                        today: _today,
                        events: _events,
                        weekStartOf: _weekStartOf,
                        isSameDay: _isSameDay,
                        eventsForDate: _eventsForDate,
                        dowKr: _dowKr,
                        onDelete: _showDeleteModal,
                        onEdit: _showEditModal,
                      ),
                      _DayView(
                        focusedDate: _focusedDate,
                        today: _today,
                        events: _events,
                        isSameDay: _isSameDay,
                        eventsForDate: _eventsForDate,
                        dowKr: _dowKr,
                        onDelete: _showDeleteModal,
                        onEdit: _showEditModal,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 20,
              bottom: 26,
              child: _buildFAB(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: context.wHeaderBg,
        border: Border(bottom: BorderSide(color: context.wBorderLight)),
      ),
      child: Column(
        children: [
          // Top row
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: context.wIconBtnBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.chevron_left,
                        color: context.wTextSecondary, size: 22),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'weddly',
                  style: const TextStyle(
                    fontSize: 20,
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
                    _iconBtn(
                        icon: Icons.notifications_none_rounded, onTap: () {}),
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
          ),
          // Period nav row
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _goToPrev,
                  child: const Icon(Icons.chevron_left,
                      size: 24, color: Color(0xFF888888)),
                ),
                SizedBox(
                  width: 130,
                  child: Text(
                    _periodLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: context.wTextPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _goToNext,
                  child: const Icon(Icons.chevron_right,
                      size: 24, color: Color(0xFF888888)),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _goToToday,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '오늘',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: context.wIconBtnBg,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(icon, color: context.wIconBtnColor, size: 18),
      ),
    );
  }

  Widget _buildTabBar() {
    const tabs = ['월', '주', '일'];
    return Container(
      decoration: BoxDecoration(
        color: context.wSurfaceAlt,
        border: Border(bottom: BorderSide(color: context.wBorderLight)),
      ),
      child: Row(
        children: tabs.asMap().entries.map((e) {
          final active = e.key == _tabIndex;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _tabIndex = e.key),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    e.value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: active
                          ? AppColors.primary
                          : const Color(0xFFBBBBBB),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 28,
                    height: active ? 2.5 : 0,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFAB() {
    return GestureDetector(
      onTap: () => _showAddModal(),
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.55),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 26),
      ),
    );
  }
}

// ══════════════════════════════════════════
// Monthly View
// ══════════════════════════════════════════

class _MonthView extends StatelessWidget {
  final DateTime focusedDate;
  final DateTime selectedDate;
  final DateTime today;
  final List<ScheduleEvent> events;
  final List<DateTime> monthGrid;
  final bool Function(DateTime, DateTime) isSameDay;
  final List<ScheduleEvent> Function(DateTime) eventsForDate;
  final String Function(DateTime) dowKr;
  final ValueChanged<DateTime> onDaySelected;
  final VoidCallback onAddTap;
  final void Function(int, String) onDelete;
  final void Function(ScheduleEvent) onEdit;

  const _MonthView({
    required this.focusedDate,
    required this.selectedDate,
    required this.today,
    required this.events,
    required this.monthGrid,
    required this.isSameDay,
    required this.eventsForDate,
    required this.dowKr,
    required this.onDaySelected,
    required this.onAddTap,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final selectedEvents = eventsForDate(selectedDate);

    return Column(
      children: [
        // Weekday header
        Container(
          color: context.wSurface,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: _kWeekdayKr.asMap().entries.map((e) {
              Color color;
              if (e.key == 0) {
                color = const Color(0xFFE8758A);
              } else if (e.key == 6) {
                color = const Color(0xFF5B9BD5);
              } else {
                color = const Color(0xFFBBBBBB);
              }
              return Expanded(
                child: Center(
                  child: Text(
                    e.value,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // Calendar grid
        Container(
          color: context.wSurface,
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.75,
              mainAxisSpacing: 2,
            ),
            itemCount: 42,
            itemBuilder: (ctx, i) {
              final date = monthGrid[i];
              final isCurrentMonth = date.month == focusedDate.month;
              final isToday = isSameDay(date, today);
              final isSelected = isSameDay(date, selectedDate);
              final dayEvents = eventsForDate(date);
              final weekday = date.weekday % 7; // 0=Sun

              Color dayNumColor;
              if (!isCurrentMonth) {
                dayNumColor = const Color(0xFFD0D0D0);
              } else if (weekday == 0) {
                dayNumColor = const Color(0xFFE8758A);
              } else if (weekday == 6) {
                dayNumColor = const Color(0xFF5B9BD5);
              } else {
                dayNumColor = const Color(0xFF333333);
              }

              Color? circleBg;
              if (isToday) {
                circleBg = AppColors.primary;
                dayNumColor = Colors.white;
              } else if (isSelected && isCurrentMonth) {
                circleBg = AppColors.primary.withOpacity(0.18);
                dayNumColor = AppColors.primaryDark;
              }

              return GestureDetector(
                onTap: isCurrentMonth ? () => onDaySelected(date) : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    Container(
                      width: 27,
                      height: 27,
                      decoration: BoxDecoration(
                        color: circleBg,
                        shape: BoxShape.circle,
                        boxShadow: isToday
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: (isToday || isSelected)
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: dayNumColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    if (dayEvents.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: dayEvents
                            .take(3)
                            .map((e) => Container(
                                  width: 5,
                                  height: 5,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 1),
                                  decoration: BoxDecoration(
                                    color: e.color,
                                    shape: BoxShape.circle,
                                  ),
                                ))
                            .toList(),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        // Selected day events
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: context.wBg,
              border: Border(
                  top: BorderSide(
                      color: context.wBorderLight, width: 1.5)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date label
                  Row(
                    children: [
                      Text(
                        '${selectedDate.month}월 ${selectedDate.day}일 (${dowKr(selectedDate)}) · ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: context.wTextLight,
                        ),
                      ),
                      Text(
                        '오늘 일정 ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: context.wTextLight,
                        ),
                      ),
                      Text(
                        '${selectedEvents.length}개',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (selectedEvents.isEmpty)
                    _emptyState(context, '📅', '등록된 일정이 없습니다')
                  else
                    ...selectedEvents.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _EventCard(
                          event: e,
                          onTap: () => onEdit(e),
                          onDelete: () => onDelete(e.id, e.title),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════
// Weekly View
// ══════════════════════════════════════════

class _WeekView extends StatelessWidget {
  final DateTime focusedDate;
  final DateTime today;
  final List<ScheduleEvent> events;
  final DateTime Function(DateTime) weekStartOf;
  final bool Function(DateTime, DateTime) isSameDay;
  final List<ScheduleEvent> Function(DateTime) eventsForDate;
  final String Function(DateTime) dowKr;
  final void Function(int, String) onDelete;
  final void Function(ScheduleEvent) onEdit;

  const _WeekView({
    required this.focusedDate,
    required this.today,
    required this.events,
    required this.weekStartOf,
    required this.isSameDay,
    required this.eventsForDate,
    required this.dowKr,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final weekStart = weekStartOf(focusedDate);
    final weekDays = List.generate(7, (i) => weekStart.add(Duration(days: i)));

    // Collect all days with events
    final daysWithEvents = weekDays.where((d) => eventsForDate(d).isNotEmpty).toList();
    final hasAnyEvent = daysWithEvents.isNotEmpty;

    return Column(
      children: [
        // Day strip
        Container(
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
          decoration: BoxDecoration(
            color: context.wSurface,
            border: Border(bottom: BorderSide(color: context.wBorderLight)),
          ),
          child: Row(
            children: weekDays.asMap().entries.map((e) {
              final date = e.value;
              final isToday = isSameDay(date, today);
              final isFocused = isSameDay(date, focusedDate);
              final dayEvents = eventsForDate(date);
              final weekday = date.weekday % 7;

              Color nameColor;
              if (isToday) {
                nameColor = AppColors.primary;
              } else if (weekday == 0) {
                nameColor = const Color(0xFFE8758A);
              } else if (weekday == 6) {
                nameColor = const Color(0xFF5B9BD5);
              } else {
                nameColor = const Color(0xFFBBBBBB);
              }

              Color numColor;
              Color? numBg;
              if (isToday) {
                numColor = Colors.white;
                numBg = AppColors.primary;
              } else if (isFocused && !isToday) {
                numColor = AppColors.primaryDark;
                numBg = AppColors.primary.withOpacity(0.18);
              } else if (weekday == 0) {
                numColor = const Color(0xFFE8758A);
              } else if (weekday == 6) {
                numColor = const Color(0xFF5B9BD5);
              } else {
                numColor = const Color(0xFF333333);
              }

              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _kWeekdayKr[weekday],
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: nameColor),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: numBg,
                        shape: BoxShape.circle,
                        boxShadow: isToday
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: numColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 5,
                      height: 5,
                      child: dayEvents.isNotEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                color: dayEvents.first.color,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        // Events list grouped by day
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: hasAnyEvent
                ? Column(
                    children: daysWithEvents.map((date) {
                      final dayEvents = eventsForDate(date);
                      final isToday = isSameDay(date, today);
                      return Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Group header
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Text(
                                    '${date.month}월 ${date.day}일 (${dowKr(date)})',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: isToday
                                          ? AppColors.primary
                                          : const Color(0xFFAAAAAA),
                                    ),
                                  ),
                                  if (isToday) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        '오늘',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            ...dayEvents.map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _EventCard(
                                  event: e,
                                  onTap: () => onEdit(e),
                                  onDelete: () => onDelete(e.id, e.title),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: _emptyState(context, '📆', '이번 주 등록된 일정이 없습니다'),
                  ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════
// Daily View
// ══════════════════════════════════════════

class _DayView extends StatelessWidget {
  final DateTime focusedDate;
  final DateTime today;
  final List<ScheduleEvent> events;
  final bool Function(DateTime, DateTime) isSameDay;
  final List<ScheduleEvent> Function(DateTime) eventsForDate;
  final String Function(DateTime) dowKr;
  final void Function(int, String) onDelete;
  final void Function(ScheduleEvent) onEdit;

  const _DayView({
    required this.focusedDate,
    required this.today,
    required this.events,
    required this.isSameDay,
    required this.eventsForDate,
    required this.dowKr,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final dayEvents = eventsForDate(focusedDate);
    final isToday = isSameDay(focusedDate, today);

    // Build hour slots 8..21
    final hours = List.generate(14, (i) => i + 8);

    // Events by start hour
    Map<int, List<ScheduleEvent>> eventsByHour = {};
    List<ScheduleEvent> allDayEvents = [];
    for (final e in dayEvents) {
      if (e.startTime == null) {
        allDayEvents.add(e);
      } else {
        final h = int.tryParse(e.startTime!.split(':').first) ?? 0;
        (eventsByHour[h] ??= []).add(e);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        children: [
          // Date banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
            decoration: BoxDecoration(
              color: context.wSurface,
              border: Border(
                  bottom: BorderSide(color: context.wBorderLight)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${focusedDate.year}년 ${focusedDate.month}월 ${focusedDate.day}일',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: context.wTextPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${dowKr(focusedDate)}요일',
                      style: TextStyle(
                          fontSize: 13,
                          color: context.wTextLight,
                          fontWeight: FontWeight.w500),
                    ),
                    if (isToday) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '오늘',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '일정 ${dayEvents.length}개',
                  style: TextStyle(
                      fontSize: 12, color: context.wTextLight),
                ),
              ],
            ),
          ),
          // All-day events
          if (allDayEvents.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('하루 종일',
                      style: TextStyle(
                          fontSize: 11,
                          color: context.wTextLight,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  ...allDayEvents.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _EventCard(
                          event: e,
                          onTap: () => onEdit(e),
                          onDelete: () => onDelete(e.id, e.title),
                        ),
                      )),
                ],
              ),
            ),
          // Hour rows
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: hours.map((h) {
                final hEvents = eventsByHour[h] ?? [];
                return Container(
                  constraints: const BoxConstraints(minHeight: 52),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: hEvents.isNotEmpty
                            ? context.wBorderLight
                            : const Color(0xFFF9F9F9),
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 42,
                        child: Text(
                          '$h:00',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFFCCCCCC),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: hEvents.isEmpty
                            ? const SizedBox()
                            : Column(
                                children: hEvents
                                    .map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 6),
                                        child: _DayEventChip(
                                          event: e,
                                          onTap: () => onEdit(e),
                                          onDelete: () =>
                                              onDelete(e.id, e.title),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════
// Event Card (Month / Week)
// ══════════════════════════════════════════

class _EventCard extends StatelessWidget {
  final ScheduleEvent event;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const _EventCard({required this.event, required this.onDelete, this.onTap});

  String get _timeText {
    if (event.startTime == null) return '';
    if (event.endTime == null) return event.startTime!;
    return '${event.startTime} ~ ${event.endTime}';
  }

  String get _metaText {
    final parts = <String>[];
    if (_timeText.isNotEmpty) parts.add(_timeText);
    if (event.memo != null && event.memo!.isNotEmpty) parts.add(event.memo!);
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      decoration: BoxDecoration(
        color: context.wSurface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Color bar
          Container(
            width: 4,
            height: 52,
            decoration: BoxDecoration(
              color: event.color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.wTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_metaText.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    _metaText,
                    style: TextStyle(
                        fontSize: 12, color: context.wTextLight),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          // Delete
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2F2),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.close,
                  size: 16, color: Color(0xFFF44336)),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

// ══════════════════════════════════════════
// Day Event Chip (Daily view)
// ══════════════════════════════════════════

class _DayEventChip extends StatelessWidget {
  final ScheduleEvent event;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const _DayEventChip({required this.event, required this.onDelete, this.onTap});

  String get _timeText {
    if (event.startTime == null) return '';
    if (event.endTime == null) return event.startTime!;
    return '${event.startTime} ~ ${event.endTime}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: context.wSurface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: event.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              event.title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.wTextPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (_timeText.isNotEmpty)
            Text(
              _timeText,
              style: const TextStyle(fontSize: 11, color: Color(0xFFBBBBBB)),
            ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2F2),
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(Icons.close,
                  size: 14, color: Color(0xFFF44336)),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

// ══════════════════════════════════════════
// Add Modal
// ══════════════════════════════════════════

class _AddModal extends StatefulWidget {
  final DateTime initialDate;
  final void Function(ScheduleEvent) onSave;
  final void Function(ScheduleEvent)? onUpdate;
  final ScheduleEvent? existingEvent;

  const _AddModal({
    required this.initialDate,
    required this.onSave,
    this.onUpdate,
    this.existingEvent,
  });

  @override
  State<_AddModal> createState() => _AddModalState();
}

class _AddModalState extends State<_AddModal> {
  final _titleCtrl = TextEditingController();
  final _memoCtrl = TextEditingController();
  late DateTime _date;
  String? _startTime;
  String? _endTime;
  Color _color = const Color(0xFFD4A96A);

  bool get _isEditMode => widget.existingEvent != null;

  @override
  void initState() {
    super.initState();
    final ev = widget.existingEvent;
    if (ev != null) {
      _titleCtrl.text = ev.title;
      _memoCtrl.text = ev.memo ?? '';
      _date = ev.date;
      _startTime = ev.startTime;
      _endTime = ev.endTime;
      _color = ev.color;
    } else {
      _date = widget.initialDate;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _memoCtrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) => '${d.year}. ${d.month}. ${d.day}.';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('ko', 'KR'),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime(bool isStart) async {
    final initialTime = isStart ? _startTime : _endTime;
    await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.48),
      builder: (_) => _TimePickerDialog(
        initialTime: initialTime,
        onConfirm: (time) => setState(() {
          if (isStart) {
            _startTime = time;
          } else {
            _endTime = time;
          }
        }),
      ),
    );
  }

  void _onSave() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('일정 제목을 입력해주세요.')),
      );
      return;
    }
    final memo =
        _memoCtrl.text.trim().isEmpty ? null : _memoCtrl.text.trim();

    if (_isEditMode) {
      widget.onUpdate!(
        widget.existingEvent!.copyWith(
          title: _titleCtrl.text.trim(),
          date: _date,
          startTime: _startTime,
          endTime: _endTime,
          color: _color,
          memo: memo,
          clearStartTime: _startTime == null,
          clearEndTime: _endTime == null,
          clearMemo: memo == null,
        ),
      );
    } else {
      widget.onSave(
        ScheduleEvent(
          id: 0,
          title: _titleCtrl.text.trim(),
          date: _date,
          startTime: _startTime,
          endTime: _endTime,
          color: _color,
          memo: memo,
        ),
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: context.wModalBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 60,
              offset: Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 16, 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: context.wBorderLight)),
              ),
              child: Row(
                children: [
                  Text(
                    _isEditMode ? '일정 수정' : '일정 등록',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: context.wTextPrimary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: context.wIconBtnBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.close,
                          size: 16, color: context.wTextLight),
                    ),
                  ),
                ],
              ),
            ),
            // Body
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    _modalLabel('일정 제목', required: true),
                    _modalInput(
                      controller: _titleCtrl,
                      hint: '일정 제목을 입력하세요',
                      maxLength: 30,
                    ),
                    const SizedBox(height: 14),
                    // Date
                    _modalLabel('날짜', required: true),
                    GestureDetector(
                      onTap: _pickDate,
                      child: _readonlyField(
                        context,
                        text: _formatDate(_date),
                        icon: Icons.calendar_today_outlined,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Time
                    _modalLabel('시간'),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickTime(true),
                            child: _readonlyField(
                              context,
                              text: _startTime ?? '시작',
                              icon: Icons.schedule_outlined,
                              muted: _startTime == null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickTime(false),
                            child: _readonlyField(
                              context,
                              text: _endTime ?? '종료',
                              icon: Icons.schedule_outlined,
                              muted: _endTime == null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Color
                    _modalLabel('색상'),
                    const SizedBox(height: 4),
                    Row(
                      children: _kEventColors.asMap().entries.map((e) {
                        final selected = _color == e.value;
                        return GestureDetector(
                          onTap: () => setState(() => _color = e.value),
                          child: Container(
                            width: 32,
                            height: 32,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: e.value,
                              shape: BoxShape.circle,
                              border: selected
                                  ? Border.all(
                                      color: context.wModalInputBorder,
                                      width: 2.5)
                                  : null,
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                        color: e.value.withOpacity(0.5),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                  : null,
                            ),
                            child: selected
                                ? const Icon(Icons.check,
                                    size: 16, color: Colors.white)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    // Memo
                    _modalLabel('메모'),
                    _modalInput(
                      controller: _memoCtrl,
                      hint: '메모를 입력하세요',
                      maxLines: 2,
                      maxLength: 100,
                    ),
                  ],
                ),
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: context.wBorderLight)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 13),
                        decoration: BoxDecoration(
                          color: context.wIconBtnBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '취소',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.wTextLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: _onSave,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.primaryGradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _isEditMode ? '수정 완료' : '저장',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
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

  Widget _modalLabel(String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: context.wTextSecondary,
          ),
          children: required
              ? const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppColors.primary),
                  )
                ]
              : [],
        ),
      ),
    );
  }

  Widget _modalInput({
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
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        counterText: '',
        filled: true,
        fillColor: context.wModalInputBg,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: context.wModalInputBorder, width: 1.5),
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

  Widget _readonlyField(
    BuildContext context, {
    required String text,
    required IconData icon,
    bool muted = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: context.wModalInputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.wModalInputBorder, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 16,
              color: muted ? context.wTextHint : context.wTextSecondary),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: muted ? context.wTextHint : context.wModalInputText,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════
// Delete Confirmation Modal
// ══════════════════════════════════════════

class _DeleteModal extends StatelessWidget {
  final String title;
  final VoidCallback onConfirm;

  const _DeleteModal({required this.title, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Container(
        width: 300,
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        decoration: BoxDecoration(
          color: context.wModalBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 60,
              offset: Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🗑️', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 12),
            Text(
              '일정을 삭제할까요?',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: context.wTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '"$title"\n이 일정을 삭제하면 복구할 수 없습니다.',
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
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: context.wIconBtnBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '취소',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.wTextLight,
                          ),
                        ),
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
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF44336),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          '삭제',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
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
// Shared helper
// ══════════════════════════════════════════

Widget _emptyState(BuildContext context, String emoji, String message) {
  return Padding(
    padding: const EdgeInsets.only(top: 32),
    child: Center(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(fontSize: 13, color: Color(0xFFCCCCCC)),
          ),
        ],
      ),
    ),
  );
}

// ══════════════════════════════════════════
// Custom Time Picker Dialog (드럼롤 방식)
// ══════════════════════════════════════════

class _TimePickerDialog extends StatefulWidget {
  final String? initialTime; // "HH:MM"
  final void Function(String) onConfirm;

  const _TimePickerDialog({this.initialTime, required this.onConfirm});

  @override
  State<_TimePickerDialog> createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<_TimePickerDialog> {
  late FixedExtentScrollController _hourCtrl;
  late FixedExtentScrollController _minCtrl;
  late int _hour;
  late int _min;

  @override
  void initState() {
    super.initState();
    if (widget.initialTime != null) {
      final parts = widget.initialTime!.split(':');
      _hour = int.tryParse(parts[0]) ?? 0;
      _min = int.tryParse(parts[1]) ?? 0;
    } else {
      final now = DateTime.now();
      _hour = now.hour;
      _min = now.minute;
    }
    _hourCtrl = FixedExtentScrollController(initialItem: _hour);
    _minCtrl = FixedExtentScrollController(initialItem: _min);
  }

  @override
  void dispose() {
    _hourCtrl.dispose();
    _minCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double itemExtent = 52.0;
    const int visibleCount = 5;
    const double wheelHeight = itemExtent * visibleCount;

    Widget buildWheel({
      required FixedExtentScrollController ctrl,
      required int count,
      required int selectedValue,
      required String Function(int) labelOf,
      required ValueChanged<int> onChanged,
    }) {
      return Expanded(
        child: SizedBox(
          height: wheelHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 선택 항목 하이라이트
              Positioned(
                top: (wheelHeight - itemExtent) / 2,
                left: 6,
                right: 6,
                child: Container(
                  height: itemExtent,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              // 상단 그라디언트 페이드
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: itemExtent * 1.5,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          context.wModalBg,
                          context.wModalBg.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // 하단 그라디언트 페이드
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: itemExtent * 1.5,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          context.wModalBg,
                          context.wModalBg.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // 스크롤 휠
              ListWheelScrollView.useDelegate(
                controller: ctrl,
                itemExtent: itemExtent,
                diameterRatio: 2.4,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: onChanged,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: count,
                  builder: (ctx, i) {
                    final isSelected = i == selectedValue;
                    return Center(
                      child: Text(
                        labelOf(i),
                        style: TextStyle(
                          fontSize: isSelected ? 22 : 16,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isSelected
                              ? AppColors.primary
                              : context.wTextMuted,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: context.wModalBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 60,
              offset: Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 16, 12),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: context.wBorderLight)),
              ),
              child: Row(
                children: [
                  Text(
                    '시간 선택',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: context.wTextPrimary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: context.wIconBtnBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.close,
                          size: 16, color: context.wTextLight),
                    ),
                  ),
                ],
              ),
            ),
            // 현재 선택 시간 표시
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                '${_hour.toString().padLeft(2, '0')}:${_min.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 2,
                ),
              ),
            ),
            // 드럼롤 휠 영역
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  buildWheel(
                    ctrl: _hourCtrl,
                    count: 24,
                    selectedValue: _hour,
                    labelOf: (i) => '${i.toString().padLeft(2, '0')}시',
                    onChanged: (i) => setState(() => _hour = i),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      ':',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: context.wTextSecondary,
                      ),
                    ),
                  ),
                  buildWheel(
                    ctrl: _minCtrl,
                    count: 60,
                    selectedValue: _min,
                    labelOf: (i) => '${i.toString().padLeft(2, '0')}분',
                    onChanged: (i) => setState(() => _min = i),
                  ),
                ],
              ),
            ),
            // 푸터 버튼
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                border:
                    Border(top: BorderSide(color: context.wBorderLight)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 13),
                      decoration: BoxDecoration(
                        color: context.wIconBtnBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.wTextLight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final formatted =
                            '${_hour.toString().padLeft(2, '0')}:${_min.toString().padLeft(2, '0')}';
                        widget.onConfirm(formatted);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.primaryGradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '확인',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
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
