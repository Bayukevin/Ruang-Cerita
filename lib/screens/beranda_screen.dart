import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'pilih_perasaan_screen.dart';
import 'latihan_pernapasan_screen.dart';
import 'riwayat_privasi_screen.dart';
import 'pusat_bantuan_aman_screen.dart';

typedef MainNavigationScreen = BerandaScreen;

class BerandaScreen extends StatefulWidget {
  final int initialIndex;

  const BerandaScreen({super.key, this.initialIndex = 0});

  static void switchTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_BerandaScreenState>();
    if (state != null) {
      state.setIndex(index);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => BerandaScreen(initialIndex: index),
        ),
        (route) => false,
      );
    }
  }

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _BerandaDashboardView(
              onNavigateToTab: setIndex,
            ),
            LatihanPernapasanScreen(
              isTab: true,
              onBackToHome: () => setIndex(0),
            ),
            RiwayatPrivasiScreen(
              isTab: true,
              onBackToHome: () => setIndex(0),
              onNavigateToTab: setIndex,
            ),
            PusatBantuanAmanScreen(
              isTab: true,
              onBackToHome: () => setIndex(0),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: setIndex,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: AppTypography.labelSm.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: AppTypography.labelSm,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.air_rounded),
                label: 'Latihan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_stories_rounded),
                label: 'Riwayat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded),
                label: 'Bantuan',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BerandaDashboardView extends StatefulWidget {
  final ValueChanged<int> onNavigateToTab;

  const _BerandaDashboardView({required this.onNavigateToTab});

  @override
  State<_BerandaDashboardView> createState() => _BerandaDashboardViewState();
}

class _BerandaDashboardViewState extends State<_BerandaDashboardView> {
  String _selectedMood = 'Tenang';

  final List<Map<String, dynamic>> _moods = [
    {'name': 'Senang', 'emoji': '✨', 'color': AppColors.yellowSoft},
    {'name': 'Tenang', 'emoji': '🌿', 'color': AppColors.tealSoft},
    {'name': 'Lelah', 'emoji': '☁️', 'color': AppColors.pinkSoft},
    {'name': 'Cemas', 'emoji': '🌊', 'color': AppColors.primarySoft},
    {'name': 'Sedih', 'emoji': '🌧️', 'color': AppColors.coralSoft},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.spa_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Ruang Cerita',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => widget.onNavigateToTab(3),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intro text
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
                  'RUANG AMAN PRIBADIMU',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Hai, kamu di sini.',
              style: AppTypography.headlineLg.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Apa yang ingin kamu beri ruang hari ini?',
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 18),

            // Hero Card: Mulai Sesi Baru
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primarySoft,
                    AppColors.surfaceContainerLow,
                    AppColors.surfaceSoft,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              Icons.psychology_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Mulai Sesi Baru',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '3-5 Menit',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Refleksi Mandiri Berbasis Empati',
                    style: AppTypography.headlineMd.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Urutkan isi pikiranmu tanpa takut dihakimi. AI kami mendengarkan dengan penuh empati dan menjaga privasimu.',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lock_rounded,
                              size: 12,
                              color: AppColors.feedbackSuccess,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '100% Privat',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.favorite_rounded,
                              size: 12,
                              color: AppColors.coralAccent,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Tanpa Label',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const PilihPerasaanScreen()),
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
                            'Mulai Refleksi Mandiri',
                            style: AppTypography.labelLg.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Mood Check-in
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bagaimana perasaanmu sekarang?',
                  style: AppTypography.headlineSm.copyWith(fontSize: 16),
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: _moods.map((mood) {
                  final isSelected = _selectedMood == mood['name'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMood = mood['name'] as String;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 12),
                      width: 76,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: mood['color'] as Color,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            mood['emoji'] as String,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mood['name'] as String,
                            style: AppTypography.labelMd.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Latihan Cepat Hari Ini
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Latihan Cepat Hari Ini',
                  style: AppTypography.headlineSm.copyWith(fontSize: 16),
                ),
                GestureDetector(
                  onTap: () => widget.onNavigateToTab(1),
                  child: Row(
                    children: [
                      Text(
                        'Lihat Semua',
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.tealSoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.air_rounded,
                      color: AppColors.tealAccent,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.tealAccent,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Relaksasi',
                                style: AppTypography.labelSm.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '2 Menit',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Napas Terkendali 2 Menit',
                          style: AppTypography.headlineSm.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Turunkan denyut jantung dan tenangkan dada',
                          style: AppTypography.bodySm.copyWith(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => widget.onNavigateToTab(1),
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.tealAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Visual Pause & Affirmation Card
            Container(
              height: 130,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: AppColors.primary,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBEu0213ZmyfGPX4m0exK4aJQou088HR3kcdC-quHnxSegBsMf9mruVXf467J1BH0h9D2bAVnqDmt27o3vZx7TWWmiGUYo1k6YWnu2tpzvBXwpZ2zq0Asjp_TdRA8mUpjiBS9WwbZQTsfKbLG1M1y5x3Fl6McbxWRBZYXJm-bXpKmq6tgQ3R38vAUDSINxmCna6sVo9ncLLPgPjSIoJ2iAKFVFl4QpHO5XFe9WH-8v5L0Cm0PmtA1Tipw',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.inverseSurface.withValues(alpha: 0.85),
                          AppColors.inverseSurface.withValues(alpha: 0.3),
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
                          Icons.auto_awesome_rounded,
                          color: AppColors.yellowAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '"Tidak semua hal harus diselesaikan hari ini. Istirahat juga sebuah langkah."',
                            style: AppTypography.bodySm.copyWith(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Arsip Jiwa
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ARSIP JIWA',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.lock_rounded,
                        size: 14, color: AppColors.feedbackSuccess),
                    const SizedBox(width: 4),
                    Text(
                      'Terenkripsi Privat',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.feedbackSuccess,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.blueSoft,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.verified_user_rounded,
                            size: 16,
                            color: AppColors.blueAccent,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Refleksi Terakhir',
                            style: AppTypography.labelMd.copyWith(
                              color: AppColors.blueAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Kemarin, 20:15',
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tenang & Terkendali',
                    style: AppTypography.headlineSm.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kamu berhasil menyelesaikan tugas yang tertunda dan meluangkan waktu 15 menit berjalan kaki sore tanpa distraksi ponsel.',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => widget.onNavigateToTab(2),
                        child: Row(
                          children: [
                            Text(
                              'Buka catatan jurnal',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_clock_rounded,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
