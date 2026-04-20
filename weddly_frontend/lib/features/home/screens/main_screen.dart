import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_notifier.dart';
import '../../../core/theme/weddly_colors.dart';

// -- Timeline type
enum _TlType { done, urgent, todo, dday }

// -- Timeline item data
class _TlItem {
  final _TlType type;
  final String title;
  final String due;
  const _TlItem({required this.type, required this.title, required this.due});
}

// -- Vendor data
class _VendorData {
  final String emoji;
  final String name;
  final String count;
  final Color bgColor;
  final Color darkBgColor;
  const _VendorData(
      {required this.emoji,
      required this.name,
      required this.count,
      required this.bgColor,
      required this.darkBgColor});
}

// -- Community data
class _CommunityData {
  final int rank;
  final String emoji;
  final Color thumbBg;
  final Color darkThumbBg;
  final String title;
  final String tag;
  final int likes;
  final int comments;
  const _CommunityData(
      {required this.rank,
      required this.emoji,
      required this.thumbBg,
      required this.darkThumbBg,
      required this.title,
      required this.tag,
      required this.likes,
      required this.comments});
}

// ========================================
// MainScreen
// ========================================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _activeNavIndex = 2; // Home (center)

  // -- D-Day calculation
  String get _ddayText {
    final wedding = DateTime(2026, 8, 15);
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    final diff = wedding.difference(todayNorm).inDays;
    if (diff > 0) return 'D-$diff';
    if (diff < 0) return 'D+${diff.abs()}';
    return 'D-Day!';
  }

  // -- Timeline data
  static const List<_TlItem> _timelineItems = [
    _TlItem(type: _TlType.done, title: '웨딩홀 예약', due: '완료'),
    _TlItem(type: _TlType.done, title: '스튜디오 계약', due: '완료'),
    _TlItem(type: _TlType.done, title: '드레스 가봉 1차', due: '완료'),
    _TlItem(
        type: _TlType.urgent,
        title: '청첩장 제작 및 발송',
        due: '2026.05.01 마감'),
    _TlItem(type: _TlType.todo, title: '메이크업 리허설', due: '2026.06.15'),
    _TlItem(type: _TlType.dday, title: '결혼식 D-Day', due: '2026.08.15 (토)'),
    _TlItem(type: _TlType.todo, title: '신혼여행', due: '2026.08.16'),
  ];

  // -- Vendor data
  static const List<_VendorData> _vendors = [
    _VendorData(
        emoji: '\u{1F3DB}\uFE0F',
        name: '예식장',
        count: '142개',
        bgColor: Color(0xFFFFF8EF),
        darkBgColor: Color(0xFF252010)),
    _VendorData(
        emoji: '\u{1F4F8}',
        name: '스튜디오',
        count: '287개',
        bgColor: Color(0xFFF0E8FF),
        darkBgColor: Color(0xFF1C1825)),
    _VendorData(
        emoji: '\u{1F457}',
        name: '드레스',
        count: '156개',
        bgColor: Color(0xFFFFF0F5),
        darkBgColor: Color(0xFF25151E)),
    _VendorData(
        emoji: '\u{1F484}',
        name: '메이크업',
        count: '203개',
        bgColor: Color(0xFFF8F0FF),
        darkBgColor: Color(0xFF1E1825)),
    _VendorData(
        emoji: '\u{1F3AC}',
        name: 'DVD',
        count: '98개',
        bgColor: Color(0xFFEEF2FF),
        darkBgColor: Color(0xFF161A28)),
    _VendorData(
        emoji: '\u{1F4CB}',
        name: '웨딩플래너',
        count: '64개',
        bgColor: Color(0xFFFFF5EB),
        darkBgColor: Color(0xFF231C10)),
  ];

  // -- Community data
  static const List<_CommunityData> _community = [
    _CommunityData(
        rank: 1,
        emoji: '\u{1F492}',
        thumbBg: Color(0xFFFFF8EF),
        darkThumbBg: Color(0xFF252010),
        title: '웨딩홀 선택할 때 꼭 확인해야 할 5가지',
        tag: '웨딩홀',
        likes: 342,
        comments: 58),
    _CommunityData(
        rank: 2,
        emoji: '\u{1F457}',
        thumbBg: Color(0xFFFFF0F5),
        darkThumbBg: Color(0xFF25151E),
        title: '드레스 업체 솔직 후기 - 강남 TOP 5',
        tag: '드레스',
        likes: 287,
        comments: 43),
    _CommunityData(
        rank: 3,
        emoji: '\u{1F4F8}',
        thumbBg: Color(0xFFF0F8FF),
        darkThumbBg: Color(0xFF141C28),
        title: '스튜디오 예약 최적 시기는 언제일까요?',
        tag: '스튜디오',
        likes: 231,
        comments: 37),
    _CommunityData(
        rank: 4,
        emoji: '\u{1F484}',
        thumbBg: Color(0xFFF8F0FF),
        darkThumbBg: Color(0xFF1E1825),
        title: '메이크업 리허설 꼭 해야 하나요? 경험담',
        tag: '메이크업',
        likes: 198,
        comments: 29),
    _CommunityData(
        rank: 5,
        emoji: '\u{1F48D}',
        thumbBg: Color(0xFFF0FFF6),
        darkThumbBg: Color(0xFF141E18),
        title: '예물 예산 어떻게 배분하셨나요?',
        tag: '예산',
        likes: 176,
        comments: 52),
  ];

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
                    padding: const EdgeInsets.only(bottom: 88),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeroCard(),
                        _buildPartnerSection(),
                        _buildStatsSection(),
                        _buildTimelineSection(),
                        _buildMenuSection(),
                        _buildVendorSection(),
                        _buildCommunitySection(),
                        _buildCopyright(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: _buildBottomNav(),
            ),
          ],
        ),
      ),
    );
  }

  // ========================================
  // 1. Header
  // ========================================
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: context.wHeaderBg,
        border: Border(bottom: BorderSide(color: context.wBorderLight)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // weddly logo
          const Text(
            'weddly',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              color: AppColors.primary,
              letterSpacing: -0.5,
            ),
          ),
          // Right icon buttons
          Row(
            children: [
              _IconBtn(
                onTap: themeNotifier.toggle,
                child: ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeNotifier,
                  builder: (_, mode, __) => Icon(
                    mode == ThemeMode.dark ? Icons.wb_sunny : Icons.dark_mode,
                    size: 18,
                    color: mode == ThemeMode.dark
                        ? AppColors.primary
                        : context.wIconBtnColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _IconBtn(
                badge: true,
                child: Icon(Icons.notifications,
                    size: 19, color: context.wIconBtnColor),
              ),
              const SizedBox(width: 8),
              _IconBtn(
                child: Icon(Icons.person,
                    size: 19, color: context.wIconBtnColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ========================================
  // 2. Hero card
  // ========================================
  Widget _buildHeroCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.heroGradient,
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Shimmer overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.06),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6],
                ),
              ),
            ),
          ),
          // Background deco circles
          Positioned(
              right: -28,
              bottom: -42,
              child: _heroDeco(130)),
          Positioned(
              right: 42,
              bottom: -12,
              child: _heroDeco(75)),
          Positioned(
              right: -4,
              top: -8,
              child: _heroDeco(40)),
          // Content
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '안녕하세요 \u{1F44B}',
                        style: TextStyle(
                            fontSize: 11, color: Color(0x80FFFFFF)),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        '홍길동님, 환영합니다!!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(7, 4, 10, 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.14)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('\u{1F48D}',
                                style: TextStyle(fontSize: 12)),
                            SizedBox(width: 5),
                            Text(
                              '2026년 8월 15일 (토)',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xBFFFFFFF)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  constraints: const BoxConstraints(minWidth: 80),
                  padding:
                      const EdgeInsets.fromLTRB(14, 10, 14, 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.16)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'D \u00B7 DAY',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Color(0x80FFFFFF),
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _ddayText,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        '결혼까지',
                        style: TextStyle(
                            fontSize: 9,
                            color: Color(0x73FFFFFF)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroDeco(double size) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              Border.all(color: Colors.white.withOpacity(0.07)),
          color: Colors.white.withOpacity(0.03),
        ),
      );

  // ========================================
  // Section header
  // ========================================
  Widget _sectionHeader(String title,
      {VoidCallback? onMore, String moreLabel = '더보기'}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: context.wTextPrimary)),
          if (onMore != null)
            GestureDetector(
              onTap: onMore,
              child: Row(
                children: [
                  Text(moreLabel,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary)),
                  const Icon(Icons.chevron_right,
                      size: 14, color: AppColors.primary),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ========================================
  // 3. Partner section
  // ========================================
  Widget _buildPartnerSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionHeader('\u{1F491} 파트너 연결'),
          GestureDetector(
            onTap: _showPartnerModal,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.wPartnerBg,
                border: Border.all(
                    color: context.wPartnerBorder, width: 1.5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primaryDark
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child:
                          Text('\u{1F491}', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('파트너 코드 연결',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: context.wTextPrimary)),
                        const SizedBox(height: 3),
                        Text('코드 공유 \u00B7 파트너 연결하기',
                            style: TextStyle(
                                fontSize: 11,
                                color: context.wTextMuted)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      color: AppColors.primary, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========================================
  // 4. Stats section (donut chart)
  // ========================================
  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionHeader('\u{1F4CA} 현황'),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 18, 12, 16),
            decoration: BoxDecoration(
              color: context.wSurface,
              border: Border.all(
                  color: context.wBorderLight, width: 1.5),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _StatHalf(
                    label: '전체 진행률',
                    percentage: 0.38,
                    pctText: '38%',
                    valueText: '3 / 8 완료',
                    subText: '미완료 5개',
                    ringColor: AppColors.primary,
                    ringBgColor: context.wDonutRingBg,
                  ),
                ),
                Container(
                  width: 1,
                  height: 90,
                  color: context.wBorderLight,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(
                  child: _StatHalf(
                    label: '예산 사용률',
                    percentage: 0.38,
                    pctText: '38%',
                    valueText: '1,900만원',
                    subText: '/ 5,000만원',
                    ringColor: const Color(0xFF5B8DEF),
                    ringBgColor: context.wDonutRingBg,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========================================
  // 5. Wedding timeline section
  // ========================================
  Widget _buildTimelineSection() {
    final doneCount =
        _timelineItems.where((i) => i.type == _TlType.done).length;
    final total = _timelineItems.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionHeader('\u{1F4C5} 웨딩 타임라인',
              onMore: _showTimelineSheet, moreLabel: '전체보기'),
          // Roadmap select
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: context.wSurfaceAlt,
              border: Border.all(color: context.wBorderLight),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('기본 로드맵',
                    style: TextStyle(
                        fontSize: 13, color: context.wTextSecondary)),
                Icon(Icons.keyboard_arrow_down,
                    size: 18, color: context.wTextLight),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: context.wSurface,
              border: Border.all(
                  color: context.wBorderLight, width: 1.5),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              children: [
                // Summary progress bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            color: context.wTextLight,
                            fontFamily: 'Pretendard',
                          ),
                          children: [
                            const TextSpan(text: '완료 '),
                            TextSpan(
                              text: '$doneCount',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(text: ' / $total'),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: Container(
                          width: 100,
                          height: 5,
                          color: context.wBorderLight,
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: doneCount / total,
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primaryDark,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Divider(
                      height: 1, color: context.wBorderLight),
                ),
                // Timeline items (max 4 preview)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: Column(
                    children: _timelineItems
                        .take(4)
                        .toList()
                        .asMap()
                        .entries
                        .map((e) => _TlItemWidget(
                              item: e.value,
                              isLast: e.key == 3,
                            ))
                        .toList(),
                  ),
                ),
                // View all row
                InkWell(
                  onTap: _showTimelineSheet,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.fromLTRB(16, 10, 16, 12),
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: context.wBorderLight)),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '전체 ${_timelineItems.length}개',
                          style: TextStyle(
                              fontSize: 11,
                              color: context.wTextMuted),
                        ),
                        const Row(
                          children: [
                            Text('전체보기',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary)),
                            Icon(Icons.chevron_right,
                                size: 14,
                                color: AppColors.primary),
                          ],
                        ),
                      ],
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

  // ========================================
  // 6. Menu grid
  // ========================================
  Widget _buildMenuSection() {
    final menus = [
      {'icon': Icons.calendar_month, 'label': '일정관리'},
      {'icon': Icons.credit_card, 'label': '예산관리'},
      {'icon': Icons.favorite, 'label': '웨딩관리'},
      {'icon': Icons.people, 'label': '하객관리'},
      {'icon': Icons.edit_note, 'label': '메모장'},
      {'icon': Icons.format_list_numbered, 'label': '식순관리'},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionHeader('\u{1F4F1} 메뉴'),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.95,
            ),
            itemCount: menus.length,
            itemBuilder: (ctx, i) => _MenuCell(
              icon: menus[i]['icon'] as IconData,
              label: menus[i]['label'] as String,
            ),
          ),
        ],
      ),
    );
  }

  // ========================================
  // 7. Vendor browsing
  // ========================================
  Widget _buildVendorSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionHeader('\u{1F3EA} 업체 둘러보기', onMore: () {}),
          SizedBox(
            height: 128,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _vendors.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: 10),
              itemBuilder: (ctx, i) {
                final v = _vendors[i];
                return Container(
                  width: 100,
                  padding:
                      const EdgeInsets.fromLTRB(10, 14, 10, 12),
                  decoration: BoxDecoration(
                    color: ctx.wSurface,
                    border: Border.all(
                        color: ctx.wBorderLight,
                        width: 1.5),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: ctx.isDark ? v.darkBgColor : v.bgColor,
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(v.emoji,
                              style: const TextStyle(
                                  fontSize: 22)),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(v.name,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: ctx.wTextSecondary)),
                      const SizedBox(height: 2),
                      Text(v.count,
                          style: TextStyle(
                              fontSize: 10,
                              color: ctx.wTextMuted)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ========================================
  // 8. Community popular posts
  // ========================================
  Widget _buildCommunitySection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionHeader('\u{1F525} 커뮤니티 인기글', onMore: () {}),
          Container(
            decoration: BoxDecoration(
              color: context.wSurface,
              border: Border.all(
                  color: context.wBorderLight, width: 1.5),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              children: _community
                  .asMap()
                  .entries
                  .map((e) => _CommunityRow(
                        item: e.value,
                        isLast: e.key == _community.length - 1,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ========================================
  // 9. Copyright
  // ========================================
  Widget _buildCopyright() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Text(
        '(C) 2025 Weddly. All rights reserved.\n당신의 특별한 날을 함께해요 \u{1F48D}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          color: context.wCopyrightColor,
          height: 1.8,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  // ========================================
  // 10. Bottom navigation
  // ========================================
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.favorite, 'label': '웨딩관리'},
      {'icon': Icons.credit_card, 'label': '예산'},
      {'icon': Icons.home, 'label': '홈'},
      {'icon': Icons.chat_bubble, 'label': '커뮤니티'},
      {'icon': Icons.menu, 'label': '설정'},
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: context.isDark
                ? const Color(0xFF21180E).withOpacity(0.72)
                : Colors.white.withOpacity(0.82),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: context.isDark
                  ? Colors.white.withOpacity(0.07)
                  : Colors.black.withOpacity(0.06),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                    context.isDark ? 0.35 : 0.10),
                blurRadius: 28,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppColors.primary.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: items.asMap().entries.map((e) {
              final isActive = e.key == _activeNavIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _activeNavIndex = e.key),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Active dot indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: isActive ? 18 : 0,
                        height: isActive ? 3 : 0,
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      Icon(
                        e.value['icon'] as IconData,
                        size: e.key == 2 ? 22 : 20,
                        color: isActive
                            ? AppColors.primary
                            : context.wTextMuted,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        e.value['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                          color: isActive
                              ? AppColors.primary
                              : context.wTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // -- Partner modal
  void _showPartnerModal() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (ctx) => const _PartnerModalContent(),
    );
  }

  // -- Timeline full view modal
  void _showTimelineSheet() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (ctx) =>
          const _TimelineSheetContent(items: _timelineItems),
    );
  }
}

// ========================================
// Sub widgets
// ========================================

// -- Header icon button
class _IconBtn extends StatelessWidget {
  final Widget child;
  final bool badge;
  final VoidCallback? onTap;
  const _IconBtn({required this.child, this.badge = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: context.wIconBtnBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: child),
          ),
          if (badge)
            Positioned(
              top: 7,
              right: 7,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: context.wSurface, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// -- Stats half (donut + text)
class _StatHalf extends StatelessWidget {
  final String label;
  final double percentage;
  final String pctText;
  final String valueText;
  final String subText;
  final Color ringColor;
  final Color ringBgColor;

  const _StatHalf({
    required this.label,
    required this.percentage,
    required this.pctText,
    required this.valueText,
    required this.subText,
    required this.ringColor,
    required this.ringBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 76,
          height: 76,
          child: CustomPaint(
            painter:
                _DonutPainter(percentage: percentage, color: ringColor, bgColor: ringBgColor),
            child: Center(
              child: Text(
                pctText,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: context.wTextPrimary,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(label,
            style: TextStyle(
                fontSize: 11,
                color: context.wTextLight,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(valueText,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: context.wTextSecondary)),
        Text(subText,
            style: TextStyle(
                fontSize: 10, color: context.wTextMuted)),
      ],
    );
  }
}

// -- Donut chart CustomPainter
class _DonutPainter extends CustomPainter {
  final double percentage;
  final Color color;
  final Color bgColor;
  const _DonutPainter({required this.percentage, required this.color, required this.bgColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const strokeWidth = 8.0;

    // Background ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = bgColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Fill ring
    final sweep = 2 * math.pi * percentage;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.percentage != percentage || old.color != color || old.bgColor != bgColor;
}

// -- Timeline item widget
class _TlItemWidget extends StatelessWidget {
  final _TlItem item;
  final bool isLast;
  const _TlItemWidget({required this.item, required this.isLast});

  Color _titleColor(BuildContext context) {
    switch (item.type) {
      case _TlType.done:
        return context.wTextHint;
      case _TlType.urgent:
        return const Color(0xFFF44336);
      case _TlType.dday:
        return AppColors.primary;
      case _TlType.todo:
        return context.wTextPrimary;
    }
  }

  Color _dueColor(BuildContext context) {
    switch (item.type) {
      case _TlType.urgent:
        return const Color(0x80F44336);
      case _TlType.dday:
        return AppColors.primary.withOpacity(0.7);
      default:
        return context.wTextHint;
    }
  }

  Widget _buildDot(BuildContext context) {
    switch (item.type) {
      case _TlType.done:
        return Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            boxShadow: [
              BoxShadow(
                color: Color(0x73D4A96A),
                blurRadius: 6,
                offset: Offset(0, 2),
              )
            ],
          ),
          child:
              const Icon(Icons.check, color: Colors.white, size: 10),
        );
      case _TlType.urgent:
        return Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.wSurface,
            border:
                Border.all(color: const Color(0xFFF44336), width: 2),
          ),
          child: const Center(
            child: Text('!',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFF44336))),
          ),
        );
      case _TlType.todo:
        return Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.wSurface,
            border:
                Border.all(color: context.wBorder, width: 2),
          ),
        );
      case _TlType.dday:
        return Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x80D4A96A),
                blurRadius: 8,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: const Center(
            child: Text('\u2605',
                style:
                    TextStyle(fontSize: 8, color: Colors.white)),
          ),
        );
    }
  }

  Widget _buildBadge(BuildContext context) {
    String text;
    Color bg;
    Color fg;
    switch (item.type) {
      case _TlType.done:
        text = '완료';
        bg = context.isDark ? const Color(0xFF1A2A1A) : const Color(0xFFF0FAF0);
        fg = const Color(0xFF4CAF50);
        break;
      case _TlType.urgent:
        text = '긴급';
        bg = context.isDark ? const Color(0xFF2A1A1A) : const Color(0xFFFFF0F0);
        fg = const Color(0xFFF44336);
        break;
      case _TlType.todo:
        text = '예정';
        bg = context.isDark ? context.wIconBtnBg : const Color(0xFFF5F5F5);
        fg = context.wTextMuted;
        break;
      case _TlType.dday:
        text = 'D-Day';
        bg = AppColors.primary;
        fg = Colors.white;
        break;
    }
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: item.type == _TlType.dday ? null : bg,
        gradient: item.type == _TlType.dday
            ? const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: fg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Track: dot + connecting line
        Column(
          children: [
            _buildDot(context),
            if (!isLast)
              Container(
                width: 2,
                height: 26,
                margin: const EdgeInsets.symmetric(vertical: 2),
                color: item.type == _TlType.done
                    ? const Color(0xFFD4A96A)
                    : context.wBorderLight,
              ),
          ],
        ),
        const SizedBox(width: 10),
        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: item.type == _TlType.done
                        ? FontWeight.w500
                        : FontWeight.w600,
                    color: _titleColor(context),
                    decoration: item.type == _TlType.done
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: context.wTextHint,
                  ),
                ),
                const SizedBox(height: 2),
                Text(item.due,
                    style: TextStyle(
                        fontSize: 11, color: _dueColor(context))),
              ],
            ),
          ),
        ),
        // Badge
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: _buildBadge(context),
        ),
      ],
    );
  }
}

// -- Menu cell
class _MenuCell extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MenuCell({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: context.wMenuIconBg,
            border: Border.all(
                color: context.wMenuIconBorder, width: 1.5),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(height: 7),
        Text(label,
            style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: context.wMenuLabel)),
      ],
    );
  }
}

// -- Community row
class _CommunityRow extends StatelessWidget {
  final _CommunityData item;
  final bool isLast;
  const _CommunityRow({required this.item, required this.isLast});

  Color get _rankColor {
    switch (item.rank) {
      case 1:
        return AppColors.primary;
      case 2:
        return const Color(0xFF9DA5B4);
      case 3:
        return const Color(0xFFC17F3B);
      default:
        return const Color(0xFFDDDDDD);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom:
                    BorderSide(color: context.wBorderLight)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              '${item.rank}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: _rankColor),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.isDark ? item.darkThumbBg : item.thumbBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child:
                  Text(item.emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.wTextPrimary),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: context.wCmTagBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(item.tag,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary)),
                    ),
                    const SizedBox(width: 7),
                    Text('\u2764\uFE0F ${item.likes}',
                        style: TextStyle(
                            fontSize: 10,
                            color: context.wTextMuted)),
                    const SizedBox(width: 7),
                    Text('댓글 ${item.comments}',
                        style: TextStyle(
                            fontSize: 10,
                            color: context.wTextMuted)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ========================================
// Partner code modal
// ========================================
class _PartnerModalContent extends StatelessWidget {
  const _PartnerModalContent();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.wModalBg,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding:
                const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text('\u{1F491} 파트너 코드',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: context.wTextPrimary)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: context.wIconBtnBg,
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.close,
                        size: 16,
                        color: context.wIconBtnColor),
                  ),
                ),
              ],
            ),
          ),
          Divider(
              height: 1, color: context.wBorderLight),
          Padding(
            padding:
                const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                // My partner code
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.wModalCodeCard,
                    border: Border.all(
                        color: context.wModalCodeBorder,
                        width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text('내 파트너 코드',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: context.wTextMuted,
                              letterSpacing: 0.3)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('W2A4B3',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                                letterSpacing: 3,
                              )),
                          Row(
                            children: [
                              _ModalActionBtn(
                                  icon: Icons.copy,
                                  label: '복사'),
                              const SizedBox(width: 6),
                              _ModalActionBtn(
                                  icon: Icons.share,
                                  label: '공유'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Divider
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                            color: context.wBorderLight)),
                    const SizedBox(width: 8),
                    Text('파트너 코드 입력',
                        style: TextStyle(
                            fontSize: 10,
                            color: context.wTextHint)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Divider(
                            color: context.wBorderLight)),
                  ],
                ),
                const SizedBox(height: 12),
                // Partner code input
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.wModalConnectBg,
                    border: Border.all(
                        color: context.wBorderLight,
                        width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      Text('파트너 코드 입력',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: context.wTextMuted)),
                      const SizedBox(height: 8),
                      TextField(
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            letterSpacing: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: context.wModalInputText),
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: '파트너 코드 6자리 입력',
                          hintStyle: TextStyle(
                            letterSpacing: 0,
                            fontSize: 12,
                            color: context.wTextHint,
                            fontWeight: FontWeight.w400,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: context.wModalInputBorder,
                                width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: context.wModalInputBorder,
                                width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.5),
                          ),
                          filled: true,
                          fillColor: context.wModalInputBg,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 11),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primaryDark,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius:
                              BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary
                                  .withOpacity(0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: const Text(
                          '파트너 연결하기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -- Modal action button
class _ModalActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ModalActionBtn({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.wModalActionBtnBg,
        border: Border.all(
            color: context.wModalCodeBorder, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary)),
        ],
      ),
    );
  }
}

// ========================================
// Timeline full view modal
// ========================================
class _TimelineSheetContent extends StatelessWidget {
  final List<_TlItem> items;
  const _TimelineSheetContent({required this.items});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.72,
      ),
      decoration: BoxDecoration(
        color: context.wModalBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding:
                const EdgeInsets.fromLTRB(20, 14, 16, 12),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text('\u{1F4C5} 웨딩 타임라인',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: context.wTextPrimary)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: context.wIconBtnBg,
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.close,
                        size: 16,
                        color: context.wIconBtnColor),
                  ),
                ),
              ],
            ),
          ),
          Divider(
              height: 1, color: context.wBorderLight),
          // Full timeline list
          Flexible(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                children: items
                    .asMap()
                    .entries
                    .map((e) => _TlItemWidget(
                          item: e.value,
                          isLast: e.key == items.length - 1,
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
