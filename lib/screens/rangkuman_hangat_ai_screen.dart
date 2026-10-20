import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'latihan_pernapasan_screen.dart';
import 'sesi_selesai_screen.dart';
import 'pusat_bantuan_aman_screen.dart';

class RangkumanHangatAiScreen extends StatefulWidget {
  final String selectedFeeling;
  final String selectedSituation;
  final String selectedDuration;

  const RangkumanHangatAiScreen({
    super.key,
    this.selectedFeeling = 'Cemas',
    this.selectedSituation = 'pekerjaan',
    this.selectedDuration = 'beberapa-hari',
  });

  @override
  State<RangkumanHangatAiScreen> createState() =>
      _RangkumanHangatAiScreenState();
}

class _RangkumanHangatAiScreenState extends State<RangkumanHangatAiScreen> {
  bool _isTextHidden = false;
  bool _isPlayingAudio = false;
  bool _isSaved = false;
  int _selectedAction = 0; // 0 for screen pause, 1 for water/shoulder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.of(context).pop(),
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
              'Rangkuman Hangat AI',
              style: AppTypography.headlineSm.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => _isPlayingAudio = !_isPlayingAudio);
            },
            icon: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlayingAudio
                    ? Icons.volume_up_rounded
                    : Icons.volume_mute_rounded,
                size: 20,
                color: AppColors.primary,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PusatBantuanAmanScreen()),
              );
            },
            icon: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.tealSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.spa_rounded,
                      size: 14,
                      color: AppColors.tealAccent,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Refleksi Berhasil Diproses',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Terima kasih sudah meluangkan waktu untuk dirimu.',
                style: AppTypography.headlineLg.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Napasmu terasa lebih tenang sekarang. Mari resapi sejenak rangkuman dan pesan khusus untuk harimu.',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 18),

              // AI Response Container
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primarySoft,
                      AppColors.surfaceSoft,
                      AppColors.tealSoft,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome_rounded,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Respons dari Pendamping AI',
                                style: AppTypography.labelSm.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() => _isTextHidden = !_isTextHidden);
                          },
                          child: Row(
                            children: [
                              Text(
                                _isTextHidden
                                    ? 'Baca teks'
                                    : 'Sembunyikan teks',
                                style: AppTypography.labelSm.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(
                                _isTextHidden
                                    ? Icons.expand_more_rounded
                                    : Icons.expand_less_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    if (!_isTextHidden) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '"Wajar sekali merasa lelah dan cemas ketika pekerjaan menuntut banyak hal beberapa hari terakhir. Kamu sudah berusaha sebaik mungkin, dan mengakui rasa ini adalah langkah awal yang sangat berani."',
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.textPrimary,
                            height: 1.5,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 14),

                    // Audio Player Bar
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x08000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isPlayingAudio = !_isPlayingAudio;
                                      });
                                    },
                                    child: Container(
                                      width: 44,
                                      height: 44,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        _isPlayingAudio
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Suara Ramah & Teduh',
                                        style: AppTypography.labelMd.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        _isPlayingAudio
                                            ? '01:15 / 01:45 • Memutar'
                                            : '01:14 / 01:45',
                                        style: AppTypography.labelSm.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() => _isPlayingAudio = true);
                                },
                                icon: const Icon(
                                  Icons.replay_rounded,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Wave bars
                          Row(
                            children: List.generate(24, (index) {
                              final isPlayed = index < 14;
                              final height =
                                  (index % 5 == 0 ? 18.0 : (index % 3 == 0 ? 14.0 : 8.0));
                              return Expanded(
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 1.5),
                                  height: height,
                                  decoration: BoxDecoration(
                                    color: isPlayed
                                        ? AppColors.primary
                                        : AppColors.outlineVariant,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Practical recommendations
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Satu Hal Praktis yang Bisa Dicoba',
                    style: AppTypography.headlineSm.copyWith(fontSize: 16),
                  ),
                  Text(
                    'Pilih salah satu',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Option 1: 5 Min screen pause
              GestureDetector(
                onTap: () => setState(() => _selectedAction = 0),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _selectedAction == 0
                        ? AppColors.yellowSoft
                        : AppColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _selectedAction == 0
                          ? AppColors.yellowAccent
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.yellowSoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.phonelink_erase_rounded,
                          color: AppColors.feedbackWarning,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Aturan 5 Menit Rehat Layar',
                                  style: AppTypography.headlineSm.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (_selectedAction == 0)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.feedbackSuccess,
                                    size: 18,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Jauhkan gadget sebentar, pejamkan mata, dan rasakan ketenangan tanpa stimulasi visual.',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Option 2: Drink water & drop shoulders
              GestureDetector(
                onTap: () => setState(() => _selectedAction = 1),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _selectedAction == 1
                        ? AppColors.blueSoft
                        : AppColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _selectedAction == 1
                          ? AppColors.blueAccent
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.blueSoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.self_improvement_rounded,
                          color: AppColors.blueAccent,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Minum Air & Longgarkan Pundak',
                                  style: AppTypography.headlineSm.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (_selectedAction == 1)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.feedbackSuccess,
                                    size: 18,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Teguk perlahan air hangat, turunkan bahu yang tegang, lepaskan beban sejenak.',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const LatihanPernapasanScreen()),
                    );
                  },
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
                      const Icon(Icons.air_rounded, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Coba Latihan Napas (1 mnt)',
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

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _isSaved = !_isSaved);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _isSaved
                                    ? 'Refleksi berhasil disimpan ke arsip privatmu.'
                                    : 'Refleksi dihapus dari arsip.',
                              ),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.borderSubtle),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isSaved
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _isSaved ? 'Tersimpan' : 'Simpan Refleksi',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.textPrimary,
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
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SesiSelesaiScreen(),
                            ),
                          );
                        },
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
                            const Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Lanjut Sesi',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.textPrimary,
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

              const SizedBox(height: 14),

              Center(
                child: Text(
                  'Ini adalah dukungan umum refleksi diri, bukan diagnosis psikologis medis.',
                  textAlign: TextAlign.center,
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
