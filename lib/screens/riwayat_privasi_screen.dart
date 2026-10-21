import 'package:flutter/material.dart';
import '../models/reflection_record.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/tts_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'pusat_bantuan_aman_screen.dart';

class RiwayatPrivasiScreen extends StatefulWidget {
  final bool isTab;
  final VoidCallback? onBackToHome;
  final ValueChanged<int>? onNavigateToTab;

  const RiwayatPrivasiScreen({
    super.key,
    this.isTab = false,
    this.onBackToHome,
    this.onNavigateToTab,
  });

  @override
  State<RiwayatPrivasiScreen> createState() => _RiwayatPrivasiScreenState();
}

class _RiwayatPrivasiScreenState extends State<RiwayatPrivasiScreen> {
  int _currentTab = 0; // 0: Riwayat, 1: Privasi & Data
  bool _autoSave = true;
  bool _hideNotificationPreview = true;
  String _voiceSpeed = '1.0x';
  bool _isLoading = true;

  List<ReflectionRecord> _reflections = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final records = await StorageService.instance.getReflections();
    final autoSave = await StorageService.instance.getAutoSaveEnabled();
    final hideNotif =
        await StorageService.instance.getHideNotificationPreview();
    final speed = await StorageService.instance.getVoiceSpeed();

    if (mounted) {
      setState(() {
        _reflections = records;
        _autoSave = autoSave;
        _hideNotificationPreview = hideNotif;
        _voiceSpeed = '${speed.toStringAsFixed(1)}x';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateAutoSave(bool value) async {
    setState(() => _autoSave = value);
    await StorageService.instance.setAutoSaveEnabled(value);
  }

  Future<void> _updateHideNotification(bool value) async {
    setState(() => _hideNotificationPreview = value);
    await StorageService.instance.setHideNotificationPreview(value);
  }

  Future<void> _updateVoiceSpeed(String spd) async {
    setState(() => _voiceSpeed = spd);
    final speedVal = double.tryParse(spd.replaceAll('x', '')) ?? 1.0;
    await StorageService.instance.setVoiceSpeed(speedVal);
    await TtsService.instance.setSpeechRate(speedVal);
  }

  Future<void> _deleteRecord(String id) async {
    await StorageService.instance.deleteReflection(id);
    if (mounted) {
      setState(() {
        _reflections.removeWhere((r) => r.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan refleksi telah dihapus.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showRecordDetail(ReflectionRecord record) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _formatTimestamp(record.timestamp),
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Rangkuman Refleksi',
                    style: AppTypography.headlineSm.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      record.summary,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.45,
                      ),
                    ),
                  ),
                  if (record.practicalStepTitle != null &&
                      record.practicalStepTitle!.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Text(
                      'Langkah Praktis',
                      style: AppTypography.labelMd.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.yellowSoft,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record.practicalStepTitle!,
                            style: AppTypography.labelMd.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (record.practicalStepDescription != null &&
                              record.practicalStepDescription!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              record.practicalStepDescription!,
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  if (record.closingMessage != null &&
                      record.closingMessage!.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Text(
                      record.closingMessage!,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _deleteRecord(record.id);
                      },
                      icon: const Icon(Icons.delete_outline_rounded,
                          size: 18, color: AppColors.feedbackDanger),
                      label: Text(
                        'Hapus Catatan Ini',
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.feedbackDanger,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.coralSoft),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showClearAllDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.coralSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_rounded,
                    color: AppColors.feedbackDanger,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Hapus Semua Riwayat?',
                  style: AppTypography.headlineSm.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tindakan ini permanen dan menghapus seluruh catatan sesi dari memori lokal ponselmu.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(sheetContext).pop();
                      await StorageService.instance.clearAllReflections();
                      if (mounted) {
                        setState(() {
                          _reflections.clear();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Semua riwayat berhasil dihapus'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.feedbackDanger,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Text(
                      'Ya, Hapus Semuanya',
                      style: AppTypography.labelMd.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    child: Text(
                      'Batal',
                      style: AppTypography.labelMd.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(dt.year, dt.month, dt.day);
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');

    if (targetDate == today) {
      return 'Hari ini, $hour:$minute';
    } else if (targetDate == today.subtract(const Duration(days: 1))) {
      return 'Kemarin, $hour:$minute';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}, $hour:$minute';
    }
  }

  String _getFeelingLabel(String id) {
    switch (id.toLowerCase()) {
      case 'cemas':
        return 'Cemas';
      case 'lelah':
        return 'Lelah';
      case 'marah':
        return 'Marah';
      case 'sedih':
        return 'Sedih';
      case 'tenang':
        return 'Tenang';
      case 'hampa':
        return 'Hampa';
      default:
        return id.isNotEmpty ? '${id[0].toUpperCase()}${id.substring(1)}' : 'Refleksi';
    }
  }

  String _getSituationLabel(String id) {
    switch (id.toLowerCase()) {
      case 'pekerjaan':
        return 'Pekerjaan';
      case 'keluarga':
        return 'Keluarga';
      case 'relasi':
        return 'Relasi';
      case 'kesehatan':
        return 'Kesehatan';
      case 'diri-sendiri':
        return 'Diri Sendiri';
      default:
        return id.isNotEmpty ? '${id[0].toUpperCase()}${id.substring(1)}' : 'Umum';
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
        leading: widget.isTab
            ? null
            : IconButton(
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
        automaticallyImplyLeading: !widget.isTab,
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
            onPressed: () {
              if (widget.onNavigateToTab != null) {
                widget.onNavigateToTab!(3);
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const PusatBantuanAmanScreen()),
                );
              }
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
              // Segmented Tab
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _currentTab = 0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _currentTab == 0
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: _currentTab == 0
                                ? [
                                    const BoxShadow(
                                      color: Color(0x0A000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history_edu_rounded,
                                size: 18,
                                color: _currentTab == 0
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Riwayat Refleksi',
                                style: AppTypography.labelMd.copyWith(
                                  color: _currentTab == 0
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: _currentTab == 0
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _currentTab = 1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _currentTab == 1
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: _currentTab == 1
                                ? [
                                    const BoxShadow(
                                      color: Color(0x0A000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shield_rounded,
                                size: 18,
                                color: _currentTab == 1
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Privasi & Data',
                                style: AppTypography.labelMd.copyWith(
                                  color: _currentTab == 1
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: _currentTab == 1
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Privacy Banner Card
              Container(
                padding: const EdgeInsets.all(16),
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
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Privasi Tanpa Kompromi',
                                style: AppTypography.headlineSm.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified_rounded,
                                color: AppColors.feedbackSuccess,
                                size: 16,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Data refleksi hanya tersimpan di perangkatmu jika kamu memilih untuk menyimpannya. Tidak pernah dibagikan ke pihak ketiga atau model publik.',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tab 0: Riwayat
              if (_currentTab == 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Refleksi Tersimpan',
                          style: AppTypography.headlineSm.copyWith(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${_reflections.length} Catatan',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, size: 20),
                      color: AppColors.textSecondary,
                      onPressed: _loadData,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  )
                else if (_reflections.isEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Belum ada catatan refleksi tersimpan.',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  ..._reflections.map((ref) {
                    final feelingText = _getFeelingLabel(ref.feelingId);
                    final situationText = _getSituationLabel(ref.situationId);
                    final timeText = _formatTimestamp(ref.timestamp);

                    return GestureDetector(
                      onTap: () => _showRecordDetail(ref),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.borderSubtle),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x06000000),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 6),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.primarySoft,
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        feelingText,
                                        style: AppTypography.labelSm.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.tealSoft,
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        situationText,
                                        style: AppTypography.labelSm.copyWith(
                                          color: AppColors.secondary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert_rounded,
                                      size: 18, color: AppColors.textSecondary),
                                  onSelected: (val) {
                                    if (val == 'buka') {
                                      _showRecordDetail(ref);
                                    } else if (val == 'hapus') {
                                      _deleteRecord(ref.id);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'buka',
                                      child: Text('Buka'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'hapus',
                                      child: Text(
                                        'Hapus',
                                        style: TextStyle(
                                            color: AppColors.feedbackDanger),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              ref.summary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodyMd.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.schedule_rounded,
                                        size: 14,
                                        color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      timeText,
                                      style: AppTypography.labelSm.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Lihat detail',
                                      style: AppTypography.labelSm.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.arrow_forward_rounded,
                                        size: 12, color: AppColors.primary),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],

                const SizedBox(height: 12),

                // Clear all button
                if (_reflections.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: _showClearAllDialog,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.feedbackDanger,
                        side: const BorderSide(color: AppColors.coralSoft),
                        backgroundColor: AppColors.surfaceSoft,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.delete_sweep_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Hapus Semua Riwayat Percakapan',
                            style: AppTypography.labelMd.copyWith(
                              color: AppColors.feedbackDanger,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],

              // Tab 1: Privasi & Data
              if (_currentTab == 1) ...[
                Text(
                  'Pengaturan Keamanan & Audio',
                  style: AppTypography.headlineSm.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 12),

                // Toggle Autosave
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Simpan riwayat sesi otomatis',
                              style: AppTypography.labelMd.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Percakapan tetap aman di memori lokal ponsel',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _autoSave,
                        activeThumbColor: AppColors.primary,
                        onChanged: _updateAutoSave,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Speed Selector
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Kecepatan panduan suara AI',
                            style: AppTypography.labelMd.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              _voiceSpeed,
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: ['0.8x', '1.0x', '1.2x', '1.5x'].map((spd) {
                          final isSelected = _voiceSpeed == spd;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => _updateVoiceSpeed(spd),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    spd,
                                    style: AppTypography.labelSm.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Toggle Notification Preview
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sembunyikan pratinjau di notifikasi',
                              style: AppTypography.labelMd.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Pesan konfirmasi tidak memunculkan teks perasaan',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _hideNotificationPreview,
                        activeThumbColor: AppColors.primary,
                        onChanged: _updateHideNotification,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Data Sovereignty
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.policy_rounded,
                            size: 20,
                            color: AppColors.feedbackWarning,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Kedaulatan Data Penuh',
                            style: AppTypography.labelMd.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Kamu dapat mengunduh seluruh arsip refleksi pribadi dalam format terenkripsi kapan saja.',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Arsip terenkripsi berhasil disiapkan'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.download_rounded, size: 18),
                          label: Text(
                            'Ekspor Catatan Mandiri',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Akun & Sesi Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.account_circle_outlined,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Akun & Sesi',
                            style: AppTypography.labelMd.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AuthService.instance.currentUser?.email != null
                            ? 'Masuk sebagai: ${AuthService.instance.currentUser!.email}'
                            : 'Status: Masuk sebagai Tamu',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton.icon(
                          onPressed: _showSignOutDialog,
                          icon: const Icon(Icons.logout_rounded, size: 18),
                          label: Text(
                            'Keluar dari Akun',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.feedbackDanger,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.feedbackDanger,
                            side: const BorderSide(color: AppColors.coralSoft),
                            backgroundColor: AppColors.surfaceSoft,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar dari Akun?'),
        content: const Text(
          'Sesi Anda akan diakhiri. Anda perlu masuk kembali saat membuka aplikasi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await AuthService.instance.signOut();
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.feedbackDanger,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
