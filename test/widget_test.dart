import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ruang_cerita/screens/pilih_perasaan_screen.dart';
import 'package:ruang_cerita/screens/latihan_pernapasan_screen.dart';
import 'package:ruang_cerita/screens/beranda_screen.dart';

void main() {
  testWidgets('PilihPerasaanScreen renders emotion selection cards', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PilihPerasaanScreen(),
      ),
    );
    expect(find.text('Apa yang paling kamu rasakan saat ini?'), findsOneWidget);
    expect(find.text('Cemas'), findsOneWidget);
    expect(find.text('Lelah'), findsOneWidget);
    expect(find.text('Lanjut'), findsOneWidget);
  });

  testWidgets('LatihanPernapasanScreen renders breathing exercise guide', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LatihanPernapasanScreen(),
      ),
    );
    expect(find.text('Tarik Napas, Lepaskan Beban'), findsOneWidget);
    expect(find.text('1 Menit'), findsOneWidget);
    expect(find.text('3 Menit'), findsOneWidget);
  });

  testWidgets('BerandaScreen keeps persistent BottomNavigationBar across tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BerandaScreen(initialIndex: 2),
      ),
    );

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Riwayat Refleksi'), findsOneWidget);

    // Tap Bantuan tab in BottomNavigationBar
    await tester.tap(find.text('Bantuan'));
    await tester.pump();

    // Verify navigation bar is still present and Bantuan content is visible
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Layanan Konseling Profesional'), findsNothing);
    expect(find.text('Pusat Bantuan Aman'), findsWidgets);
  });
}
