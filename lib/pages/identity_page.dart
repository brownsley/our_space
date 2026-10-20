import 'package:flutter/material.dart';
import 'package:bcall/pages/home.dart';
import 'package:bcall/services/user_identity_service.dart';

class IdentityPage extends StatefulWidget {
  const IdentityPage({super.key});

  @override
  State<IdentityPage> createState() => _IdentityPageState();
}

class _IdentityPageState extends State<IdentityPage> {
  final UserIdentityService _identityService = UserIdentityService();

  bool _loading = true;
  bool _saving = false;

  static const Color _pink = Color(0xFFE887AD);
  static const Color _darkPink = Color(0xFFAD3F70);
  static const Color _blue = Color(0xFF5C8DDE);

  @override
  void initState() {
    super.initState();
    _loadIdentity();
  }

  Future<void> _loadIdentity() async {
    try {
      final user = await _identityService.getCurrentUser();

      if (!mounted) return;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        setState(() => _loading = false);
      }
    } catch (e, stackTrace) {
      debugPrint('Load identity error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _loading = false;
        _saving = false;
      });

      _showMessage('Failed to load saved identity: $e');
    }
  }

  Future<void> _selectUser(String user) async {
    if (_saving) return;

    setState(() => _saving = true);

    try {
      await _identityService.setIdentity(user);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _saving = false);
      _showMessage('Failed to save identity. Please try again.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _darkPink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF1F6), Color(0xFFF9E8FF), Color(0xFFEAF1FF)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: 70,
              right: -35,
              child: _GlowCircle(size: 150, color: Color(0x33E887AD)),
            ),
            const Positioned(
              bottom: 100,
              left: -50,
              child: _GlowCircle(size: 170, color: Color(0x225C8DDE)),
            ),
            SafeArea(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: _pink))
                  : Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 28,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // App icon
                              Container(
                                width: 108,
                                height: 108,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.85),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _pink.withOpacity(0.22),
                                      blurRadius: 30,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.favorite_rounded,
                                  size: 54,
                                  color: _pink,
                                ),
                              ),

                              const SizedBox(height: 28),

                              const Text(
                                'Our Little World',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.8,
                                  color: _darkPink,
                                ),
                              ),

                              const SizedBox(height: 10),

                              const Text(
                                'Two hearts, one little world ✨',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF8D7C91),
                                  height: 1.5,
                                ),
                              ),

                              const SizedBox(height: 34),

                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.78),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFB89AC7)
                                          .withOpacity(0.12),
                                      blurRadius: 28,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Who are you? 💌',
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF51415A),
                                      ),
                                    ),

                                    const SizedBox(height: 7),

                                    const Text(
                                      'Choose your identity to enter our world.',
                                      style: TextStyle(
                                        fontSize: 13,
                                        height: 1.5,
                                        color: Color(0xFF96879B),
                                      ),
                                    ),

                                    const SizedBox(height: 22),

                                    _IdentityOption(
                                      name: 'I am Phyoe',
                                      subtitle: 'Your blue heart',
                                      emoji: '💙',
                                      icon: Icons.favorite_rounded,
                                      color: _blue,
                                      background: const Color(0xFFEDF3FF),
                                      onTap: () => _selectUser('me'),
                                    ),

                                    const SizedBox(height: 14),

                                    _IdentityOption(
                                      name: 'I am Nway',
                                      subtitle: 'Your pink heart',
                                      emoji: '💗',
                                      icon: Icons.favorite_rounded,
                                      color: _pink,
                                      background: const Color(0xFFFFEDF4),
                                      onTap: () => _selectUser('girlfriend'),
                                    ),

                                    if (_saving) ...[
                                      const SizedBox(height: 22),
                                      const Center(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                color: _pink,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'Preparing your little world...',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF96879B),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.lock_rounded,
                                    size: 14,
                                    color: _darkPink.withOpacity(0.65),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Made with love, just for us',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _darkPink.withOpacity(0.75),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Text('💕'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdentityOption extends StatelessWidget {
  final String name;
  final String subtitle;
  final String emoji;
  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onTap;
  final bool loading;

  const _IdentityOption({
    required this.name,
    required this.subtitle,
    required this.emoji,
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
    // ignore: unused_element_parameter
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 25, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: color, size: 22),
          ],
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
