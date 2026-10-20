import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'theme/app_colors.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_1_screen.dart';
import 'screens/onboarding_2_screen.dart';
import 'screens/onboarding_3_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/beranda_screen.dart';
import 'screens/pilih_perasaan_screen.dart';
import 'screens/pilih_situasi_screen.dart';
import 'screens/pertanyaan_adaptif_screen.dart';
import 'screens/rangkuman_hangat_ai_screen.dart';
import 'screens/sesi_selesai_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }
  final isLoggedIn = FirebaseAuth.instance.currentUser != null;
  runApp(RuangCeritaApp(isLoggedIn: isLoggedIn));
}

class RuangCeritaApp extends StatelessWidget {
  final bool isLoggedIn;
  const RuangCeritaApp({super.key, this.isLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      Theme.of(context).textTheme,
    );

    return MaterialApp(
      title: 'Ruang Cerita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: textTheme,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
      ),
      initialRoute: isLoggedIn ? '/beranda' : '/onboarding_1',
      routes: {
        '/': (context) => const Onboarding1Screen(),
        '/onboarding_1': (context) => const Onboarding1Screen(),
        '/splash': (context) => const SplashScreen(),
        '/onboarding_2': (context) => const Onboarding2Screen(),
        '/onboarding_3': (context) => const Onboarding3Screen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/beranda': (context) => const BerandaScreen(),
        '/pilih_perasaan': (context) => const PilihPerasaanScreen(),
        '/pilih_situasi': (context) => const PilihSituasiScreen(),
        '/pertanyaan_adaptif': (context) => const PertanyaanAdaptifScreen(),
        '/rangkuman_hangat_ai': (context) => const RangkumanHangatAiScreen(),
        '/latihan_pernapasan': (context) => const BerandaScreen(initialIndex: 1),
        '/sesi_selesai': (context) => const SesiSelesaiScreen(),
        '/riwayat_privasi': (context) => const BerandaScreen(initialIndex: 2),
        '/pusat_bantuan_aman': (context) => const BerandaScreen(initialIndex: 3),
      },
    );
  }
}
