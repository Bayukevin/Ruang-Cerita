import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'sesi_selesai_screen.dart';

class LatihanPernapasanScreen extends StatefulWidget {
  final bool isTab;
  final VoidCallback? onBackToHome;

  const LatihanPernapasanScreen({
    super.key,
    this.isTab = false,
    this.onBackToHome,
  });

  @override
  State<LatihanPernapasanScreen> createState() =>
      _LatihanPernapasanScreenState();
}

class _LatihanPernapasanScreenState extends State<LatihanPernapasanScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  Timer? _countdownTimer;

  int _selectedDurationSeconds = 60;
  int _secondsRemaining = 60;
  bool _isPaused = false;
  bool _isSoundActive = true;
  bool _showTextGuide = false;

  int _breathPhase = 0; // 0: Tarik (4s), 1: Tahan (4s), 2: Hembus (4s)
  int _secondsInPhase = 4;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _startBreathingCycle();
  }

  void _startBreathingCycle() {
    _animController.forward(from: 0.0);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return;

      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _countdownTimer?.cancel();
          _finishSession();
          return;
        }

        _secondsInPhase--;
        if (_secondsInPhase <= 0) {
          _breathPhase = (_breathPhase + 1) % 3;
          _secondsInPhase = 4;
          if (_breathPhase == 0) {
            _animController.forward(from: 0.0);
          } else if (_breathPhase == 2) {
            _animController.reverse(from: 1.0);
          }
        }
      });
    });
  }

  void _finishSession() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SesiSelesaiScreen()),
    );
  }

  void _setDuration(int seconds) {
    setState(() {
      _selectedDurationSeconds = seconds;
      _secondsRemaining = seconds;
      _breathPhase = 0;
      _secondsInPhase = 4;
      _isPaused = false;
    });
    _animController.forward(from: 0.0);
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _animController.stop();
      } else {
        if (_breathPhase == 0) {
          _animController.forward();
        } else if (_breathPhase == 2) {
          _animController.reverse();
        }
      }
    });
  }

  void _restart() {
    setState(() {
      _secondsRemaining = _selectedDurationSeconds;
      _breathPhase = 0;
      _secondsInPhase = 4;
      _isPaused = false;
    });
    _animController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _phaseTitle {
    switch (_breathPhase) {
      case 0:
        return 'Tarik Napas';
      case 1:
        return 'Tahan';
      case 2:
        return 'Hembuskan';
      default:
        return 'Tarik Napas';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.textPrimary,
          onPressed: () {
            if (widget.onBackToHome != null) {
              widget.onBackToHome!();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ruang Refleksi',
              style: AppTypography.labelSm.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'Latihan Pernapasan Terpandu',
              style: AppTypography.headlineSm.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            children: [
              // Dismiss Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.tealSoft,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.tealAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Fokus Menenangkan',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      if (widget.onBackToHome != null) {
                        widget.onBackToHome!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(Icons.close_rounded, size: 16),
                    label: Text(
                      'Selesai Latihan',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                'Tarik Napas, Lepaskan Beban',
                textAlign: TextAlign.center,
                style: AppTypography.headlineLg.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ikuti irama lingkaran ini untuk membantu tubuhmu kembali seimbang dan rileks.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 16),

              // Duration selector pills
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _durationPill(label: '1 Menit', seconds: 60),
                  const SizedBox(width: 8),
                  _durationPill(label: '3 Menit', seconds: 180),
                  const SizedBox(width: 8),
                  _durationPill(label: '5 Menit', seconds: 300),
                ],
              ),

              const SizedBox(height: 20),

              // Center Breathing Orb Canvas
              SizedBox(
                height: 250,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      double scale;
                      if (_breathPhase == 0) {
                        scale = 0.85 + (_animController.value * 0.25);
                      } else if (_breathPhase == 1) {
                        scale = 1.1;
                      } else {
                        scale = 1.1 - ((1.0 - _animController.value) * 0.25);
                      }

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer ring
                          Transform.scale(
                            scale: scale * 1.15,
                            child: Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.tealSoft.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                          // Mid ring
                          Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 170,
                              height: 170,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primarySoft.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                          // Core tactile circle
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.tealAccent.withValues(alpha: 0.15),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.spa_rounded,
                                  size: 26,
                                  color: AppColors.tealAccent,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _phaseTitle,
                                  style: AppTypography.headlineSm.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$_secondsInPhase detik',
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.tealAccent,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Sound & Text mode toggles
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() => _isSoundActive = !_isSoundActive);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: _isSoundActive
                            ? AppColors.yellowSoft
                            : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isSoundActive
                                ? Icons.waves_rounded
                                : Icons.volume_off_rounded,
                            size: 16,
                            color: AppColors.feedbackWarning,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isSoundActive
                                ? 'Suara Ombak Lembut'
                                : 'Suara Mati',
                            style: AppTypography.labelSm.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() => _showTextGuide = !_showTextGuide);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: _showTextGuide
                            ? AppColors.primarySoft
                            : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.menu_book_rounded,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Mode Teks',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              if (_showTextGuide) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Panduan Pernapasan 4-4-4',
                            style: AppTypography.labelMd.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _showTextGuide = false),
                            child: const Icon(Icons.close_rounded, size: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Tarik Napas (4 dtk): Hirup udara perlahan melalui hidung, rasakan rongga dada mengembang.',
                        style: AppTypography.bodySm.copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '• Tahan (4 dtk): Biarkan tubuh beristirahat sejenak dalam ketenangan tanpa tegang.',
                        style: AppTypography.bodySm.copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '• Hembuskan (4 dtk): Buang udara lembut lewat mulut, lepaskan ketegangan pundak.',
                        style: AppTypography.bodySm.copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // Remaining Time telemetry
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Waktu tersisa',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _formatTime(_secondsRemaining),
                      style: AppTypography.headlineSm.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Control Actions
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _togglePause,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceContainerLow,
                          foregroundColor: AppColors.textPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isPaused
                                  ? Icons.play_arrow_rounded
                                  : Icons.pause_rounded,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _isPaused ? 'Lanjut' : 'Jeda',
                              style: AppTypography.labelMd.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _restart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceContainerLow,
                          foregroundColor: AppColors.textPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.replay_rounded, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              'Ulangi',
                              style: AppTypography.labelMd.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Finish button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _finishSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.sentiment_satisfied_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Aku Merasa Lebih Baik (Selesai)',
                        style: AppTypography.labelLg.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _durationPill({required String label, required int seconds}) {
    final isSelected = _selectedDurationSeconds == seconds;
    return GestureDetector(
      onTap: () => _setDuration(seconds),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: AppTypography.labelSm.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
