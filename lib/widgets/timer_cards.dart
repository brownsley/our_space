import 'package:flutter/material.dart';

const Color _pink = Color(0xFFE05688);
const Color _dark = Color(0xFF30212A);
const Color _muted = Color(0xFF947D87);

class TotalDaysTimerCard extends StatelessWidget {
  final int totalDays;
  final int years;
  final int months;
  final int hours;
  final int minutes;
  final int seconds;

  const TotalDaysTimerCard({
    super.key,
    required this.totalDays,
    required this.years,
    required this.months,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  @override
  Widget build(BuildContext context) {
    return TimerCardWrapper(
      gradient: const LinearGradient(
        colors: [_pink, Color(0xFFFF9DBB)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _CardTitle('OUR LOVE JOURNEY', light: true),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$totalDays',
              style: const TextStyle(
                fontSize: 42,
                height: 1,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -1,
              ),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'DAYS TOGETHER ♡',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.3,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          _StatsRow(
            values: ['$years', '$months', '$hours', '$minutes', '$seconds'],
            labels: const ['YRS', 'MOS', 'HRS', 'MIN', 'SEC'],
            light: true,
          ),
        ],
      ),
    );
  }
}

class PastelPillTimerCard extends StatelessWidget {
  final int years;
  final int months;
  final int remainingDays;
  final int seconds;

  const PastelPillTimerCard({
    super.key,
    required this.years,
    required this.months,
    required this.remainingDays,
    required this.seconds,
  });

  @override
  Widget build(BuildContext context) {
    return TimerCardWrapper(
      bgColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _CardTitle('OUR TIME CAPSULE'),
          const SizedBox(height: 5),
          const Text(
            'Little moments, endless memories ♡',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: _muted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          _StatsRow(
            values: ['$years', '$months', '$remainingDays', '$seconds'],
            labels: const ['YEARS', 'MONTHS', 'DAYS', 'SECS'],
            backgrounds: const [
              Color(0xFFFFE8F0),
              Color(0xFFFFF0F5),
              Color(0xFFF8E8FA),
              Color(0xFFFFE8F0),
            ],
          ),
        ],
      ),
    );
  }
}

class SplitBannerTimerCard extends StatelessWidget {
  final int years;
  final int months;
  final int remainingDays;
  final int hour;
  final String? photoPath;

  const SplitBannerTimerCard({
    super.key,
    required this.years,
    required this.months,
    required this.hour,
    required this.remainingDays,
    this.photoPath,
  });

  @override
  Widget build(BuildContext context) {
    return TimerCardWrapper(
      bgColor: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: _FramedPhoto(
              photoPath: photoPath,
              width: double.infinity,
              height: 138,
              radius: 15,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.favorite_rounded, color: _pink, size: 15),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'TIME TOGETHER',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _dark,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                _StatsRow(
                  values: ['$years', '$months', '$remainingDays', '$hour'],
                  labels: const ['YRS', 'MOS', 'DAYS', 'HOURS'],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MinimalTimerCard extends StatelessWidget {
  final int years;
  final int months;
  final int remainingDays;
  final int totalDays;
  final int hour;
  final String? photoPath;

  const MinimalTimerCard({
    super.key,
    required this.years,
    required this.months,
    required this.hour,
    required this.remainingDays,
    required this.totalDays,
    this.photoPath,
  });

  @override
  Widget build(BuildContext context) {
    return TimerCardWrapper(
      bgColor: const Color(0xFFFFF7FA),
      borderColor: const Color(0xFFF1D1DF),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 11,
            child: Stack(
              children: [
                Expanded(
                  flex: 5,
                  child: _FramedPhoto(
                    photoPath: photoPath,
                    width: double.infinity,
                    height: 138,
                    radius: 15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),
          Expanded(
            flex: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.favorite_rounded, color: _pink, size: 13),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'OUR JOURNEY',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _pink,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _MinimalStat(label: 'YEARS', value: years),
                const SizedBox(height: 8),
                _MinimalStat(label: 'MONTHS', value: months),
                const SizedBox(height: 8),
                _MinimalStat(label: 'DAYS', value: remainingDays),
                const SizedBox(height: 8),
                _MinimalStat(label: 'HOURS', value: hour),
                const Spacer(),
                const FittedBox(fit: BoxFit.scaleDown),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MinimalStat extends StatelessWidget {
  final String label;
  final int value;

  const _MinimalStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _muted,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ),
        const SizedBox(width: 3),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$value',
              style: const TextStyle(
                color: _dark,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FramedPhoto extends StatelessWidget {
  final String? photoPath;
  final double width;
  final double height;
  final double radius;

  const _FramedPhoto({
    required this.photoPath,
    required this.width,
    required this.height,
    this.radius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius + 3),
        border: Border.all(color: const Color(0xFFF0C4D7), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: _pink.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox(
          width: width,
          height: height,
          child: photoPath != null && photoPath!.isNotEmpty
              ? Image.asset(
                  photoPath!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _PhotoPlaceholder(),
                )
              : const _PhotoPlaceholder(),
        ),
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFE5EF),
      alignment: Alignment.center,
      child: const Icon(Icons.favorite_rounded, color: _pink, size: 38),
    );
  }
}

class _CardTitle extends StatelessWidget {
  final String text;
  final bool light;

  const _CardTitle(this.text, {this.light = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: light ? Colors.white : _dark,
        fontSize: 12,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.1,
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final List<String> values;
  final List<String> labels;
  final bool light;
  final List<Color>? backgrounds;

  const _StatsRow({
    required this.values,
    required this.labels,
    this.light = false,
    this.backgrounds,
  }) : assert(values.length == labels.length);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(values.length, (index) {
        final Color valueColor = light ? Colors.white : _dark;
        final Color labelColor = light
            ? Colors.white.withOpacity(0.85)
            : _muted;

        final Color? background =
            backgrounds != null && index < backgrounds!.length
            ? backgrounds![index]
            : null;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: EdgeInsets.symmetric(
              horizontal: 1,
              vertical: background != null ? 8 : 1,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    values[index],
                    style: TextStyle(
                      color: valueColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      color: labelColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class TimerCardWrapper extends StatelessWidget {
  final Color? bgColor;
  final Gradient? gradient;
  final Color? borderColor;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const TimerCardWrapper({
    super.key,
    this.bgColor,
    this.gradient,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        gradient: gradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor ?? const Color(0xFFF1E5EA)),
        boxShadow: [
          BoxShadow(
            color: _pink.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int count;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) {
      return const SizedBox.shrink();
    }

    final int active = currentPage.clamp(0, count - 1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (index) {
          final bool selected = index == active;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: selected ? 23 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: selected ? _pink : _pink.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
            ),
          );
        }),
      ),
    );
  }
}
