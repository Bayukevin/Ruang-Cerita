import 'dart:async';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'login_screen.dart';
import 'beranda_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _consentChecked = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_consentChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Silakan centang persetujuan terlebih dahulu',
            style: AppTypography.labelSm.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.feedbackDanger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Email dan kata sandi wajib diisi',
            style: AppTypography.labelSm.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.feedbackDanger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Kata sandi minimal 6 karakter',
            style: AppTypography.labelSm.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.feedbackDanger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.instance.registerWithEmail(
        email: email,
        password: password,
        name: name.isNotEmpty ? name : null,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Akun berhasil dibuat. Selamat datang!',
            style: AppTypography.labelSm.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.textPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const BerandaScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AuthService.getErrorMessage(e),
            style: AppTypography.labelSm.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.feedbackDanger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleRegister() async {
    setState(() => _isLoading = true);
    try {
      final cred = await AuthService.instance.signInWithGoogle();
      if (!mounted) return;
      if (cred != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Berhasil mendaftar dengan Google!',
              style: AppTypography.labelSm.copyWith(color: Colors.white),
            ),
            backgroundColor: AppColors.textPrimary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const BerandaScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AuthService.getErrorMessage(e),
            style: AppTypography.labelSm.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.feedbackDanger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: AppColors.textPrimary,
                  ),
                  Row(
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
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 48), // spacer
                ],
              ),

              const SizedBox(height: 16),

              // Title badge & info
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.spa_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Ruang Aman Tanpa Penghakiman',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Buat Akun Baru',
                style: AppTypography.headlineLg.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Mulai perjalanan merawat pikiranmu bersama Ruang Cerita.',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 20),

              // Google Quick Sign up
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _handleGoogleRegister,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.borderSubtle),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.g_mobiledata_rounded,
                          size: 32, color: Color(0xFF4285F4)),
                      const SizedBox(width: 6),
                      Text(
                        'Daftar dengan Google',
                        style: AppTypography.labelLg.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.borderSubtle)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'atau daftar dengan email',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.borderSubtle)),
                ],
              ),

              const SizedBox(height: 16),

              // Inputs
              Text(
                'Nama Lengkap atau Panggilan',
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surfaceContainerLow,
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.textSecondary,
                  ),
                  hintText: 'Misal: Rian',
                  hintStyle: AppTypography.bodyMd.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'Email',
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surfaceContainerLow,
                  prefixIcon: const Icon(
                    Icons.mail_outline_rounded,
                    color: AppColors.textSecondary,
                  ),
                  hintText: 'nama@email.com',
                  hintStyle: AppTypography.bodyMd.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'Kata Sandi',
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surfaceContainerLow,
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textSecondary,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  hintText: 'Minimal 8 karakter',
                  hintStyle: AppTypography.bodyMd.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    'Gunakan kombinasi huruf dan angka',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Consent checkbox card
              GestureDetector(
                onTap: () {
                  setState(() {
                    _consentChecked = !_consentChecked;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: _consentChecked
                              ? AppColors.primary
                              : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _consentChecked
                                ? AppColors.primary
                                : AppColors.borderSubtle,
                          ),
                        ),
                        child: _consentChecked
                            ? const Icon(Icons.check,
                                size: 14, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              height: 1.4,
                            ),
                            children: const [
                              TextSpan(text: 'Saya memahami '),
                              TextSpan(
                                text: 'Ruang Cerita',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              TextSpan(
                                text:
                                    ' adalah pendamping AI dan bukan layanan darurat medis.',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Buat Akun',
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

              const SizedBox(height: 16),

              // Grounding Micro-Note
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.tealSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        size: 18,
                        color: AppColors.tealAccent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Privasimu aman sepenuhnya. Data percakapanmu dienkripsi dan terlindungi.',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Sign in footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sudah memiliki akun? ',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      'Masuk',
                      style: AppTypography.labelMd.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
