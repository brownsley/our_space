import 'package:flutter/material.dart';

class MilestoneProgressBar extends StatefulWidget {
  final DateTime anniversaryDate;

  const MilestoneProgressBar({super.key, required this.anniversaryDate});

  @override
  State<MilestoneProgressBar> createState() => _MilestoneProgressBarState();
}

class _MilestoneProgressBarState extends State<MilestoneProgressBar> {
  bool _isExpanded = false;

  static const Color pink = Color(0xFFE05688);
  static const Color dark = Color(0xFF30212A);
  static const Color lightPink = Color(0xFFFFF0F5);
  static const Color borderPink = Color(0xFFF4E2EA);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final startDate = DateTime(
      widget.anniversaryDate.year,
      widget.anniversaryDate.month,
      widget.anniversaryDate.day,
    );

    final today = DateTime(now.year, now.month, now.day);
    final totalDays = today.difference(startDate).inDays;
    final elapsedDays = totalDays.clamp(0, 1000000);
    final currentBlock = elapsedDays ~/ 100;
    final nextMilestone = (currentBlock + 1) * 100;
    final daysIntoBlock = elapsedDays % 100;
    final progress = daysIntoBlock / 100;
    final daysRemaining = nextMilestone - elapsedDays;

    final unlockedMilestones = List<int>.generate(
      currentBlock,
      (index) => (index + 1) * 100,
    );

    final isFutureDate = totalDays < 0;
    final displayDays = isFutureDate ? 0 : totalDays;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: borderPink),
        boxShadow: [
          BoxShadow(
            color: pink.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFF2F7), Color(0xFFFFE6EF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: pink.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: pink,
                        size: 23,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'OUR JOURNEY',
                            style: TextStyle(
                              color: pink,
                              fontSize: 10,
                              letterSpacing: 1.8,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Every day is a milestone',
                            style: TextStyle(
                              color: dark,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.flag_rounded, color: pink, size: 14),
                          const SizedBox(width: 5),
                          Text(
                            '${unlockedMilestones.length} reached',
                            style: const TextStyle(
                              color: pink,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Text(
                  isFutureDate
                      ? 'Your journey begins in'
                      : 'YOUR NEXT SPECIAL DAY',
                  style: TextStyle(
                    color: dark.withOpacity(0.6),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        isFutureDate ? 'Coming soon' : '$nextMilestone',
                        style: const TextStyle(
                          color: dark,
                          fontSize: 34,
                          height: 1.1,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                    if (!isFutureDate) ...[
                      const SizedBox(width: 7),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text(
                          'DAYS',
                          style: TextStyle(
                            color: pink,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: pink,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: pink.withOpacity(0.16),
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            isFutureDate ? '${-totalDays}' : '$daysRemaining',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Text(
                            'DAYS LEFT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              letterSpacing: 0.7,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Milestone progress',
                        style: TextStyle(
                          color: dark,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: lightPink,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isFutureDate ? '0%' : '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          color: pink,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                Text(
                  isFutureDate
                      ? 'Your story is about to begin.'
                      : '$displayDays of $nextMilestone days completed',
                  style: TextStyle(
                    color: dark.withOpacity(0.55),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 10),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: isFutureDate ? 0 : progress),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        value: value,
                        minHeight: 12,
                        backgroundColor: const Color(0xFFF7EDF2),
                        valueColor: const AlwaysStoppedAnimation<Color>(pink),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLegend(Icons.favorite_rounded, 'Day $displayDays'),
                    _buildLegend(Icons.flag_rounded, '$nextMilestone-day goal'),
                  ],
                ),

                if (unlockedMilestones.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Divider(height: 1, color: borderPink),
                  ),

                  // Expandable milestone header
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Container(
                              height: 42,
                              width: 42,
                              decoration: BoxDecoration(
                                color: lightPink,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.workspace_premium_rounded,
                                color: pink,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Memories unlocked',
                                    style: TextStyle(
                                      color: dark,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${unlockedMilestones.length} special milestones reached',
                                    style: TextStyle(
                                      color: dark.withOpacity(0.5),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              _isExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: pink,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Expandable milestone history
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: _isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: const SizedBox(
                      width: double.infinity,
                      height: 0,
                    ),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: unlockedMilestones.reversed.map((milestone) {
                          final milestoneDate = startDate.add(
                            Duration(days: milestone),
                          );

                          final formattedDate =
                              '${milestoneDate.day.toString().padLeft(2, '0')} '
                              '${_monthName(milestoneDate.month)} '
                              '${milestoneDate.year}';

                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFAFC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: borderPink),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Milestone icon
                                Container(
                                  height: 36,
                                  width: 36,
                                  decoration: const BoxDecoration(
                                    color: pink,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 19,
                                  ),
                                ),

                                const SizedBox(width: 10),

                                // Text takes the remaining space
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '$milestone Days',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: dark,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Another beautiful chapter',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: dark.withOpacity(0.5),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // Date remains aligned at the far right
                                SizedBox(
                                  width: 82,
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: lightPink,
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: Text(
                                      formattedDate,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        color: pink,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: pink),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            color: dark.withOpacity(0.55),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }
}
