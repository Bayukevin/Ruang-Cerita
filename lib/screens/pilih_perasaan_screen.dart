import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'pilih_situasi_screen.dart';
import 'pusat_bantuan_aman_screen.dart';

class PilihPerasaanScreen extends StatefulWidget {
  const PilihPerasaanScreen({super.key});

  @override
  State<PilihPerasaanScreen> createState() => _PilihPerasaanScreenState();
}

class _PilihPerasaanScreenState extends State<PilihPerasaanScreen> {
  String _selectedFeeling = 'cemas';
  bool _isSpeaking = false;

  final List<Map<String, dynamic>> _feelings = [
    {
      'id': 'cemas',
      'title': 'Cemas',
      'subtitle': 'Gelisah, tegang',
      'icon': Icons.waves_rounded,
      'bgColor': AppColors.primarySoft,
      'accentColor': AppColors.primary,
    },
    {
      'id': 'sedih',
      'title': 'Sedih',
      'subtitle': 'Sendu, hampa',
      'icon': Icons.water_drop_rounded,
      'bgColor': AppColors.coralSoft,
      'accentColor': AppColors.coralAccent,
    },
    {
      'id': 'marah',
      'title': 'Marah',
      'subtitle': 'Kesal, jengkel',
      'icon': Icons.local_fire_department_rounded,
      'bgColor': AppColors.pinkSoft,
      'accentColor': AppColors.feedbackDanger,
    },
    {
      'id': 'lelah',
      'title': 'Lelah',
      'subtitle': 'Habis energi',
      'icon': Icons.bedtime_rounded,
      'bgColor': AppColors.tealSoft,
      'accentColor': AppColors.tealAccent,
    },
    {
      'id': 'kesepian',
      'title': 'Kesepian',
      'subtitle': 'Terasing, sunyi',
      'icon': Icons.wb_twilight_rounded,
      'bgColor': AppColors.blueSoft,
      'accentColor': AppColors.blueAccent,
    },
    {
      'id': 'bingung',
      'title': 'Bingung',
      'subtitle': 'Bimbang, kalut',
      'icon': Icons.cyclone_rounded,
      'bgColor': AppColors.surfaceContainerLow,
      'accentColor': AppColors.primaryContainer,
    },
    {
      'id': 'baik',
      'title': 'Baik saja',
      'subtitle': 'Tenang, lega',
      'icon': Icons.wb_sunny_rounded,
      'bgColor': AppColors.yellowSoft,
      'accentColor': AppColors.feedbackWarning,
    },
    {
      'id': 'belum-tahu',
      'title': 'Belum tahu',
      'subtitle': 'Masih mencari',
      'icon': Icons.help_center_rounded,
      'bgColor': AppColors.surfaceContainer,
      'accentColor': AppColors.textSecondary,
    },
  ];

  void _toggleSpeech() {
    setState(() {
      _isSpeaking = !_isSpeaking;
    });
    if (_isSpeaking) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Membacakan: "Apa yang paling kamu rasakan saat ini?"',
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
              'Pilih Perasaan',
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
                    // Step Progress
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Langkah 1 dari 4',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '25%',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
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
                          widthFactor: 0.25,
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

                    // Prompt & Audio card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Apa yang paling kamu rasakan saat ini?',
                                      style: AppTypography.headlineMd.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Pilih yang paling mendekati. Tidak harus sempurna.',
                                      style: AppTypography.bodySm.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _toggleSpeech,
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primarySoft,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.graphic_eq_rounded,
                                    color: AppColors.primary,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_isSpeaking) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.volume_up_rounded,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Membacakan pertanyaan untukmu...',
                                    style: AppTypography.labelSm.copyWith(
                                      color: AppColors.primary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Grid of 8 emotions
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: _feelings.length,
                      itemBuilder: (context, index) {
                        final item = _feelings[index];
                        final isSelected = _selectedFeeling == item['id'];
                        final bgColor = item['bgColor'] as Color;
                        final accentColor = item['accentColor'] as Color;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFeeling = item['id'] as String;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        item['icon'] as IconData,
                                        size: 20,
                                        color: accentColor,
                                      ),
                                    ),
                                    if (isSelected)
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      style: AppTypography.headlineSm.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      item['subtitle'] as String,
                                      style: AppTypography.labelSm.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Empathy Capsule
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: AppColors.yellowSoft,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              size: 16,
                              color: AppColors.feedbackWarning,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Setiap emosi yang hadir bernilai valid. Ambil napas sejenak, kita jalan bersama perlahan.',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Bottom CTA
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
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final currentItem = _feelings.firstWhere(
                      (e) => e['id'] == _selectedFeeling,
                      orElse: () => _feelings.first,
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PilihSituasiScreen(
                          selectedFeeling: currentItem['title'] as String,
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
    );
  }
}
