import 'dart:async';

import 'package:bcall/services/update_service.dart';
import 'package:flutter/material.dart';

import '../widgets/home_header.dart';
import '../widgets/timer_cards.dart';
import '../widgets/virtual_love_actions.dart';
import '../widgets/milestone_progress_bar.dart';
import '../widgets/love_note_card.dart';
import '../widgets/mini_apps_quick_access.dart';
import '../widgets/about_app_card.dart';
import '../model/book_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DateTime anniversaryDate = DateTime(2024, 2, 9);

  Timer? _timer;
  final PageController _pageController = PageController();

  int _years = 0;
  int _months = 0;
  int _remainingDays = 0;
  int _totalDays = 0;
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  int _currentPage = 0;
  int _noteIndex = 0;

  final List<Book> _savedBooks = [];
  static const Color _muted = Color(0xFF947D87);
  static const Color _background = Color(0xFFFFF6F9);

  final List<String> _loveNotes = [
    '"Distance means so little when someone means so much."',
    '"I carry your heart with me (I carry it in my heart)."',
    '"Close together or far apart, you are forever in my heart."',
    '"Every mile between us is just proof of how strong our love is."',
    '"In all the world, there is no heart for me like yours."',
    '"If I had a flower for every time I thought of you, I could walk in my garden forever."',
    '"No matter where you are, you will always be home to me."',
    '"My heart is, and always will be, yours."',
    '"I love you not only for what you are, but for what I am when I am with you."',
    '"You are my today and all of my tomorrows."',
    '"Even when we are miles apart, a single thought of you brings you right to my side."',
    '"Time zones and distances cannot change the love I have for you."',
    '"You are the best part of my everyday, whether near or far."',
    '"Thinking of you is a habit I never want to break."',
    '"A thousand miles is just a number when two souls are this connected."',
    '"You are my favorite notification."',
    '"Counting down the days until I can see you again."',
    '"Your voice is my favorite sound, and your smile is my favorite view."',
    '"Distance is just a test to see how far love can travel."',
    '"I loved you yesterday, I love you still, always have, always will."',
  ];

  @override
  void initState() {
    super.initState();

    _updateTimer();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTimer());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        UpdateService().checkForUpdate(context);
      }
    });
  }

  DateTime _addMonths(DateTime date, int amount) {
    final int monthIndex = date.month - 1 + amount;
    final int year = date.year + monthIndex ~/ 12;
    final int month = monthIndex % 12 + 1;
    final int lastDay = DateTime(year, month + 1, 0).day;

    return DateTime(
      year,
      month,
      date.day > lastDay ? lastDay : date.day,
      date.hour,
      date.minute,
      date.second,
    );
  }

  void _updateTimer() {
    if (!mounted) return;

    final DateTime now = DateTime.now();

    if (now.isBefore(anniversaryDate)) {
      setState(() {
        _years = 0;
        _months = 0;
        _remainingDays = 0;
        _totalDays = 0;
        _hours = 0;
        _minutes = 0;
        _seconds = 0;
      });
      return;
    }

    int totalMonths =
        (now.year - anniversaryDate.year) * 12 +
        now.month -
        anniversaryDate.month;

    DateTime monthAnchor = _addMonths(anniversaryDate, totalMonths);

    if (now.isBefore(monthAnchor)) {
      totalMonths--;
      monthAnchor = _addMonths(anniversaryDate, totalMonths);
    }

    final Duration elapsed = now.difference(anniversaryDate);
    final Duration monthElapsed = now.difference(monthAnchor);

    setState(() {
      _years = totalMonths ~/ 12;
      _months = totalMonths % 12;
      _remainingDays = monthElapsed.inDays;
      _totalDays = elapsed.inDays;
      _hours = elapsed.inHours % 24;
      _minutes = elapsed.inMinutes % 60;
      _seconds = elapsed.inSeconds % 60;
    });
  }

  void _nextNote() {
    setState(() {
      _noteIndex = (_noteIndex + 1) % _loveNotes.length;
    });
  }

  void _onBookDownloaded(Book book) {
    if (_savedBooks.any((item) => item.title == book.title)) {
      return;
    }

    setState(() {
      _savedBooks.add(book);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: Stack(
        children: [
          Positioned(
            top: -90,
            right: -70,
            child: _backgroundCircle(220, const Color(0xFFFFE0EB)),
          ),
          Positioned(
            top: 360,
            left: -100,
            child: _backgroundCircle(180, const Color(0xFFFFEAF2)),
          ),
          Positioned(
            bottom: 100,
            right: -80,
            child: _backgroundCircle(200, const Color(0xFFF8E9F8)),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeHeader(),
                  const SizedBox(height: 10),
                  Text("Old Version"),
                  SizedBox(
                    height: 180,
                    child: PageView(
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                      children: [
                        TotalDaysTimerCard(
                          totalDays: _totalDays,
                          years: _years,
                          months: _months,
                          hours: _hours,
                          minutes: _minutes,
                          seconds: _seconds,
                        ),
                        PastelPillTimerCard(
                          years: _years,
                          months: _months,
                          remainingDays: _remainingDays,
                          seconds: _seconds,
                        ),
                        SplitBannerTimerCard(
                          years: _years,
                          months: _months,
                          remainingDays: _remainingDays,
                          hour: _hours,

                          photoPath: 'assets/icon/image.png',
                        ),
                        MinimalTimerCard(
                          years: _years,
                          months: _months,
                          remainingDays: _remainingDays,
                          totalDays: _totalDays,
                          hour: _hours,
                          photoPath: 'assets/icon/image2.png',
                        ),
                      ],
                    ),
                  ),

                  Center(
                    child: PageIndicator(currentPage: _currentPage, count: 4),
                  ),

                  const SizedBox(height: 12),

                  const VirtualLoveActions(),

                  const SizedBox(height: 12),

                  MiniAppsQuickAccess(
                    savedBooks: _savedBooks,
                    onBookDownloaded: _onBookDownloaded,
                  ),

                  const SizedBox(height: 12),
                  LoveNoteCard(
                    note: _loveNotes[_noteIndex],
                    onRefresh: _nextNote,
                  ),
                  const SizedBox(height: 12),

                  MilestoneProgressBar(anniversaryDate: anniversaryDate),

                  const SizedBox(height: 12),

                  const AboutAppCard(),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      'Made with love ♡',
                      style: TextStyle(
                        color: _muted.withOpacity(0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _backgroundCircle(double size, Color color) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.55),
        ),
      ),
    );
  }
}
