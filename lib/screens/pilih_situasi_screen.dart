import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'pertanyaan_adaptif_screen.dart';
import 'pusat_bantuan_aman_screen.dart';

class PilihSituasiScreen extends StatefulWidget {
  final String selectedFeeling;

  const PilihSituasiScreen({
    super.key,
    this.selectedFeeling = 'Cemas',
  });

  @override
  State<PilihSituasiScreen> createState() => _PilihSituasiScreenState();
}

class _PilihSituasiScreenState extends State<PilihSituasiScreen> {
  String _selectedSituation = 'pekerjaan';
  bool _isSpeaking = false;

  void _toggleSpeech() {
    setState(() {
      _isSpeaking = !_isSpeaking;
    });
    if (_isSpeaking) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Membacakan: "Hal ini paling berkaitan dengan apa?"',
            style: AppTypography.labelSm.copyWith(color: Colors.white),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        ),
      );
    }
  }

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
              'Pilih Situasi',
              style: AppTypography.headlineSm.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _toggleSpeech,
            icon: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isSpeaking ? Icons.volume_up_rounded : Icons.volume_mute_rounded,
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stepper Progress
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Langkah 2 dari 4',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          'Situasi',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        height: 6,
                        color: AppColors.surfaceContainer,
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: 0.5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Conversational Question Container
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'Hal ini paling berkaitan dengan apa?',
                                  style: AppTypography.headlineMd.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _toggleSpeech,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySoft,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.volume_up_rounded,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Dengarkan',
                                        style: AppTypography.labelSm.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.spa_rounded,
                                size: 16,
                                color: AppColors.tealAccent,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Kamu tidak perlu membagikan detail yang belum nyaman kamu ceritakan.',
                                  style: AppTypography.bodySm.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Ambient Illustration Banner
                    Container(
                      height: 90,
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.primarySoft,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBvx_Ic0hoO8C5-mM02XJqxGcg1OBRDSOCXVf4klSKGU5cRw-8_-2GvqgKHlF_adU_3I-yzCG_VN5Hm0pMRbEDaqIwk03OhVxyjLGWx5jxnfMtPYCK2FF9v68YVf96q1OcbkFZZHTa5swCcrHJRKUg44U7OZiECOFfkA4zJlNKGefh1MNdPUmOYo1hpDoGiOvN_WSrUObSGtAZzQmcfD89sua4QTlsP9JUO15usoErhReZEiJuexb-lxA',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: AppColors.primarySoft,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.textPrimary.withValues(alpha: 0.8),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.lightbulb_rounded,
                                  size: 16,
                                  color: AppColors.yellowAccent,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Pilih yang paling mendekati perasaanmu saat ini',
                                  style: AppTypography.labelSm.copyWith(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Top 2 mini cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildMiniCard(
                            id: 'keluarga',
                            title: 'Keluarga',
                            subtitle: 'Rumah & relasi',
                            icon: Icons.home_rounded,
                            bgColor: AppColors.coralSoft,
                            iconColor: AppColors.coralAccent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMiniCard(
                            id: 'pertemanan',
                            title: 'Pertemanan',
                            subtitle: 'Sahabat & teman',
                            icon: Icons.forum_rounded,
                            bgColor: AppColors.tealSoft,
                            iconColor: AppColors.tealAccent,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Featured Card: Sekolah atau Pekerjaan (selected by default)
                    GestureDetector(
                      onTap: () {
                        setState(() => _selectedSituation = 'pekerjaan');
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _selectedSituation == 'pekerjaan'
                              ? AppColors.primarySoft
                              : AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _selectedSituation == 'pekerjaan'
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: _selectedSituation == 'pekerjaan'
                                    ? AppColors.primary
                                    : Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.work_rounded,
                                size: 22,
                                color: _selectedSituation == 'pekerjaan'
                                    ? Colors.white
                                    : AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sekolah atau Pekerjaan',
                                    style: AppTypography.headlineSm.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Tugas, rekan, atau rutinitas harian',
                                    style: AppTypography.bodySm.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_selectedSituation == 'pekerjaan')
                              Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Row 2 cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildMiniCard(
                            id: 'hubungan',
                            title: 'Hubungan',
                            subtitle: 'Pasangan & cinta',
                            icon: Icons.favorite_rounded,
                            bgColor: AppColors.pinkSoft,
                            iconColor: AppColors.pinkAccent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMiniCard(
                            id: 'diri',
                            title: 'Diriku Sendiri',
                            subtitle: 'Pikiran & harapan',
                            icon: Icons.face_rounded,
                            bgColor: AppColors.yellowSoft,
                            iconColor: AppColors.feedbackWarning,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Row 3 cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildMiniCard(
                            id: 'lain',
                            title: 'Hal Lain',
                            subtitle: 'Sesuatu yang berbeda',
                            icon: Icons.auto_awesome_rounded,
                            bgColor: AppColors.surfaceContainerLow,
                            iconColor: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMiniCard(
                            id: 'belum-tahu',
                            title: 'Belum Tahu',
                            subtitle: 'Masih membingungkan',
                            icon: Icons.help_outline_rounded,
                            bgColor: AppColors.surfaceContainerLow,
                            iconColor: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Reassurance Pill
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSoft,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified_user_rounded,
                              size: 16,
                              color: AppColors.feedbackSuccess,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Pilihanmu tersimpan aman dan privat',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // Bottom Nav Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceContainerLow,
                          foregroundColor: AppColors.textPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: Text(
                          'Kembali',
                          style: AppTypography.labelLg.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PertanyaanAdaptifScreen(
                                selectedFeeling: widget.selectedFeeling,
                                selectedSituation: _selectedSituation,
                              ),
                            ),
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
                            Text(
                              'Lanjut',
                              style: AppTypography.labelLg.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
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

  Widget _buildMiniCard({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
  }) {
    final isSelected = _selectedSituation == id;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedSituation = id);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: iconColor),
                ),
                if (isSelected)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, size: 14, color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTypography.headlineSm.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
