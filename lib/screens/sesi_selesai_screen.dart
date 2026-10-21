import 'package:flutter/material.dart';
import '../models/reflection_record.dart';
import '../services/storage_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'beranda_screen.dart';
import 'pusat_bantuan_aman_screen.dart';

class SesiSelesaiScreen extends StatefulWidget {
  final ReflectionRecord? record;

  const SesiSelesaiScreen({super.key, this.record});

  @override
  State<SesiSelesaiScreen> createState() => _SesiSelesaiScreenState();
}

class _SesiSelesaiScreenState extends State<SesiSelesaiScreen> {
  String _selectedEvaluation = 'lega';
  ReflectionRecord? _currentRecord;

  final List<Map<String, dynamic>> _evaluations = [
    {
      'id': 'lega',
      'title': 'Sedikit lebih lega',
      'subtitle': 'Napas terasa longgar',
      'icon': Icons.sentiment_satisfied_rounded,
      'bgColor': AppColors.tealSoft,
      'accentColor': AppColors.tealAccent,
    },
    {
      'id': 'sama',
      'title': 'Masih sama',
      'subtitle': 'Perlu adaptasi pelan',
      'icon': Icons.sentiment_neutral_rounded,
      'bgColor': AppColors.surfaceContainerLow,
      'accentColor': AppColors.textSecondary,
    },
    {
      'id': 'berat',
      'title': 'Terasa lebih berat',
      'subtitle': 'Emosi baru muncul',
      'icon': Icons.filter_drama_rounded,
      'bgColor': AppColors.coralSoft,
      'accentColor': AppColors.coralAccent,
    },
    {
      'id': 'belum',
      'title': 'Belum tahu',
      'subtitle': 'Sedang mengamati',
      'icon': Icons.help_outline_rounded,
      'bgColor': AppColors.surfaceContainerLow,
      'accentColor': AppColors.blueAccent,
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentRecord = widget.record;
    if (_currentRecord?.evaluation != null &&
        _currentRecord!.evaluation!.isNotEmpty) {
      _selectedEvaluation = _currentRecord!.evaluation!;
    }
  }

  Future<void> _updateEvaluation(String evalId) async {
    setState(() => _selectedEvaluation = evalId);
    if (_currentRecord != null) {
      _currentRecord = _currentRecord!.copyWith(evaluation: evalId);
      await StorageService.instance.saveReflection(_currentRecord!);
    }
  }

  Future<void> _onFinishAndGoHome() async {
    if (_currentRecord != null) {
      _currentRecord = _currentRecord!.copyWith(evaluation: _selectedEvaluation);
      await StorageService.instance.saveReflection(_currentRecord!);
    }
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const BerandaScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _onSaveToHistory() async {
    if (_currentRecord != null) {
      _currentRecord = _currentRecord!.copyWith(
        isSaved: true,
        evaluation: _selectedEvaluation,
      );
      await StorageService.instance.saveReflection(_currentRecord!);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Refleksi tersimpan ke riwayat privat.'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const BerandaScreen(initialIndex: 2),
        ),
        (route) => false,
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
          onPressed: _onFinishAndGoHome,
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
              'Sesi Selesai',
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
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const PusatBantuanAmanScreen()),
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
              // Hero Celebration Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    // Avatar / Badge
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: AppColors.tealSoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.spa_rounded,
                          size: 38,
                          color: AppColors.tealAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Selesai dalam 4 menit',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Terima kasih sudah hadir untuk dirimu hari ini.',
                      textAlign: TextAlign.center,
                      style: AppTypography.headlineMd.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Kamu telah meluangkan waktu sejenak untuk mengenali emosimu secara jujur dan penuh kelembutan.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.borderSubtle),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
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
                              'Pernapasan: Stabil',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.yellowAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Refleksi: 1 Catatan',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Post-Session Evaluation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.psychology_alt_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Bagaimana perasaanmu?',
                        style: AppTypography.headlineSm.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  Text(
                    'Pilih satu',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.25,
                ),
                itemCount: _evaluations.length,
                itemBuilder: (context, index) {
                  final item = _evaluations[index];
                  final isSelected = _selectedEvaluation == item['id'];
                  final bgColor = item['bgColor'] as Color;
                  final accentColor = item['accentColor'] as Color;

                  return GestureDetector(
                    onTap: () => _updateEvaluation(item['id'] as String),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                child: Icon(
                                  item['icon'] as IconData,
                                  size: 20,
                                  color: accentColor,
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  width: 20,
                                  height: 20,
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
                                style: AppTypography.labelMd.copyWith(
                                  fontWeight: FontWeight.w700,
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

              const SizedBox(height: 24),

              // CTA 1: Back to Home
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onFinishAndGoHome,
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
                        'Selesai & Kembali ke Beranda',
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

              const SizedBox(height: 10),

              // CTA 2: Save to History
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _onSaveToHistory,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.borderSubtle),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.bookmark_add_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Simpan Refleksi ke Riwayat',
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: Text(
                  'Data ini disimpan privat di perangkat ponselmu.',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
