import 'package:bcall/services/telegram_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VirtualLoveActions extends StatefulWidget {
  const VirtualLoveActions({super.key});

  @override
  State<VirtualLoveActions> createState() => _VirtualLoveActionsState();
}

class _VirtualLoveActionsState extends State<VirtualLoveActions> {
  bool _isOpening = false;

  static const Color _primary = Color(0xFFE65388);
  static const Color _dark = Color(0xFF40263A);
  static const Color _muted = Color(0xFF88677F);

  Future<void> _showLoveActionsModal() async {
    if (_isOpening) return;

    setState(() => _isOpening = true);
    HapticFeedback.selectionClick();

    try {
      final result = await showModalBottomSheet<LoveAction>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        barrierColor: const Color(0x990F0718),
        builder: (_) => const _LoveActionsSheet(),
      );

      if (!mounted || result == null) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF30223A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Row(
              children: [
                const Icon(Icons.favorite_rounded, color: Color(0xFFFF91B9)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    result.successMessage,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _isOpening = false);
      }
    }
  }

  Widget _buildLoveIcon() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _primary.withValues(alpha: 0.08)),
      ),
      child: const Icon(Icons.favorite_rounded, color: _primary, size: 25),
    );
  }

  Widget _buildExploreButton({required bool compact}) {
    return FilledButton(
      onPressed: _isOpening ? null : _showLoveActionsModal,
      style: FilledButton.styleFrom(
        backgroundColor: _primary,
        disabledBackgroundColor: _primary.withValues(alpha: 0.6),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 15,
          vertical: 12,
        ),
        minimumSize: const Size(0, 44),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isOpening)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          else
            const Icon(Icons.auto_awesome_rounded, size: 17),
          if (!compact) ...[
            const SizedBox(width: 7),
            Text(
              _isOpening ? 'Opening...' : 'Explore',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ],
        ],
      ),
    );
  }

  Widget _decorativeCircle(double size, Color color) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFE1ED), Color(0xFFFFF0F6), Color(0xFFF0E8FF)],
        ),
        border: Border.all(color: _primary.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: _primary.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned(
              top: -34,
              right: -22,
              child: _decorativeCircle(
                95,
                Colors.white.withValues(alpha: 0.30),
              ),
            ),
            Positioned(
              bottom: -42,
              left: 85,
              child: _decorativeCircle(
                85,
                Colors.white.withValues(alpha: 0.22),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 330;

                  return Row(
                    children: [
                      _buildLoveIcon(),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Little Love Moments',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: _dark,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Send a little happiness today',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12, color: _muted),
                            ),
                            if (_isOpening) ...[
                              const SizedBox(height: 5),
                              const LinearProgressIndicator(
                                minHeight: 2,
                                color: _primary,
                                backgroundColor: Color(0x33E65388),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildExploreButton(compact: compact),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoveAction {
  final IconData icon;
  final String label;
  final String description;
  final String data;
  final String successMessage;
  final Color color;
  final Color backgroundColor;

  const LoveAction({
    required this.icon,
    required this.label,
    required this.description,
    required this.data,
    required this.successMessage,
    required this.color,
    required this.backgroundColor,
  });
}

class _LoveActionsSheet extends StatefulWidget {
  const _LoveActionsSheet();

  @override
  State<_LoveActionsSheet> createState() => _LoveActionsSheetState();
}

class _LoveActionsSheetState extends State<_LoveActionsSheet> {
  bool _isSending = false;
  String? _sendingLabel;

  static const List<LoveAction> _actions = [
    LoveAction(
      icon: Icons.favorite_rounded,
      label: 'Virtual Hug',
      description: 'A warm little hug',
      data: 'Virtual Hug 🤗',
      successMessage: 'Your virtual hug is on its way!',
      color: Color(0xFFE65388),
      backgroundColor: Color(0xFFFFE5EF),
    ),
    LoveAction(
      icon: Icons.face_3_rounded,
      label: 'Sweet Kiss',
      description: 'A kiss full of love',
      data: 'Sweet Kiss 😘',
      successMessage: 'Your sweet kiss is on its way!',
      color: Color(0xFFE85D75),
      backgroundColor: Color(0xFFFFE8E8),
    ),
    LoveAction(
      icon: Icons.mail_rounded,
      label: 'I Miss You',
      description: 'Thinking of you',
      data: 'I Miss You 🥺💕',
      successMessage: 'Your message is ready to spread love!',
      color: Color(0xFF8D6BE8),
      backgroundColor: Color(0xFFF0E9FF),
    ),
    LoveAction(
      icon: Icons.volunteer_activism_rounded,
      label: 'Love You',
      description: 'A little reminder',
      data: 'Love You ❤️',
      successMessage: 'Your love message is on its way!',
      color: Color(0xFFD94E86),
      backgroundColor: Color(0xFFFFE7F0),
    ),
    LoveAction(
      icon: Icons.nightlight_round,
      label: 'Good Night',
      description: 'Sweet dreams tonight',
      data: 'Good Night 🌙💗',
      successMessage: 'Your good-night wishes are on their way!',
      color: Color(0xFF6575C9),
      backgroundColor: Color(0xFFE9EDFF),
    ),
    LoveAction(
      icon: Icons.wb_sunny_rounded,
      label: 'Good Morning',
      description: 'Start with a smile',
      data: 'Good Morning ☀️💖',
      successMessage: 'Your morning wishes are on their way!',
      color: Color(0xFFE39A35),
      backgroundColor: Color(0xFFFFF1D9),
    ),
  ];

  Future<void> _sendAction(LoveAction action) async {
    if (_isSending) return;

    setState(() {
      _isSending = true;
      _sendingLabel = action.label;
    });

    HapticFeedback.lightImpact();

    try {
      await TelegramService.sendMessage(action.data);

      if (!mounted) return;

      Navigator.of(context).pop(action);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isSending = false;
        _sendingLabel = null;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF392633),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            content: const Text(
              'Could not send your message. Please try again.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.88),
        decoration: const BoxDecoration(
          color: Color(0xFFFFF7FB),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 11),
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2D5E0),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 18, 14),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD9E8), Color(0xFFE9DFFF)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Color(0xFFE65388),
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Send Some Love',
                            style: TextStyle(
                              color: Color(0xFF39263A),
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Choose a moment to share',
                            style: TextStyle(
                              color: Color(0xFF927C91),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: _isSending
                          ? null
                          : () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF7B6477),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth < 350 ? 2 : 3;

                    return GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(16, 2, 16, 12),
                      itemCount: _actions.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: columns == 2 ? 1.05 : 0.84,
                      ),
                      itemBuilder: (context, index) {
                        final action = _actions[index];
                        final isCurrent = _sendingLabel == action.label;

                        return _LoveActionCard(
                          action: action,
                          enabled: !_isSending,
                          isSending: isCurrent,
                          onTap: () => _sendAction(action),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  18,
                  8,
                  18,
                  MediaQuery.of(context).padding.bottom + 14,
                ),
                child: _isSending
                    ? Column(
                        children: [
                          const LinearProgressIndicator(
                            minHeight: 3,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xFFE65388),
                            backgroundColor: Color(0xFFF1DCE7),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Sending ${_sendingLabel ?? 'your message'}...',
                            style: const TextStyle(
                              color: Color(0xFF886C83),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.favorite_rounded,
                                size: 14,
                                color: Color(0xFFE65388),
                              ),
                              const SizedBox(width: 7),
                              Text(
                                'A small message can mean a lot',
                                style: TextStyle(
                                  color: Colors.pink.shade300,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF806A7D),
                                side: const BorderSide(
                                  color: Color(0xFFEADCE7),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                'Maybe Later',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoveActionCard extends StatelessWidget {
  final LoveAction action;
  final bool enabled;
  final bool isSending;
  final VoidCallback onTap;

  const _LoveActionCard({
    required this.action,
    required this.enabled,
    required this.isSending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: enabled || isSending ? 1 : 0.48,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(21),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              border: Border.all(
                color: isSending
                    ? action.color.withValues(alpha: 0.65)
                    : const Color(0xFFF2E7EF),
                width: isSending ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: action.color.withValues(alpha: 0.055),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: action.backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: isSending
                        ? SizedBox(
                            width: 21,
                            height: 21,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.3,
                              color: action.color,
                            ),
                          )
                        : Icon(action.icon, color: action.color, size: 24),
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  action.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.15,
                    color: Color(0xFF432F41),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    action.description,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      height: 1.2,
                      color: Color(0xFF9A8798),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
