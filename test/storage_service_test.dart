import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ruang_cerita/models/reflection_record.dart';
import 'package:ruang_cerita/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    StorageService.instance.resetForTesting();
    SharedPreferences.setMockInitialValues({});
  });

  group('StorageService', () {
    test('saveReflection and getReflections work correctly', () async {
      final service = StorageService.instance;

      final now = DateTime.now();
      final record1 = ReflectionRecord(
        id: 'rec_1',
        timestamp: now.subtract(const Duration(hours: 1)),
        feelingId: 'cemas',
        situationId: 'pekerjaan',
        durationId: 'beberapa-hari',
        summary: 'Merasa cemas karena tenggat pekerjaan.',
      );

      final record2 = ReflectionRecord(
        id: 'rec_2',
        timestamp: now,
        feelingId: 'tenang',
        situationId: 'diri-sendiri',
        durationId: 'hari-ini',
        summary: 'Sudah mulai merasa lebih tenang.',
      );

      await service.saveReflection(record1);
      await service.saveReflection(record2);

      final list = await service.getReflections();
      expect(list.length, 2);
      // Newest first
      expect(list.first.id, 'rec_2');
      expect(list.last.id, 'rec_1');
      expect(list.first.summary, 'Sudah mulai merasa lebih tenang.');
    });

    test('update existing reflection updates record without duplicates', () async {
      final service = StorageService.instance;
      final now = DateTime.now();
      final record = ReflectionRecord(
        id: 'rec_1',
        timestamp: now,
        feelingId: 'cemas',
        situationId: 'pekerjaan',
        durationId: 'hari-ini',
        summary: 'Awalnya cemas.',
      );

      await service.saveReflection(record);
      final updated = record.copyWith(
        evaluation: 'lega',
        summary: 'Sekarang sudah lega.',
      );
      await service.saveReflection(updated);

      final list = await service.getReflections();
      expect(list.length, 1);
      expect(list.first.evaluation, 'lega');
      expect(list.first.summary, 'Sekarang sudah lega.');
    });

    test('deleteReflection removes target record', () async {
      final service = StorageService.instance;
      final record = ReflectionRecord(
        id: 'rec_to_delete',
        timestamp: DateTime.now(),
        feelingId: 'lelah',
        situationId: 'keluarga',
        durationId: 'hari-ini',
        summary: 'Perlu istirahat.',
      );

      await service.saveReflection(record);
      expect((await service.getReflections()).length, 1);

      await service.deleteReflection('rec_to_delete');
      expect((await service.getReflections()).isEmpty, isTrue);
    });

    test('clearAllReflections removes all stored reflections', () async {
      final service = StorageService.instance;
      await service.saveReflection(ReflectionRecord(
        id: 'r1',
        timestamp: DateTime.now(),
        feelingId: 'cemas',
        situationId: 'pekerjaan',
        durationId: 'hari-ini',
        summary: 'Satu',
      ));
      await service.saveReflection(ReflectionRecord(
        id: 'r2',
        timestamp: DateTime.now(),
        feelingId: 'tenang',
        situationId: 'diri-sendiri',
        durationId: 'hari-ini',
        summary: 'Dua',
      ));

      expect((await service.getReflections()).length, 2);
      await service.clearAllReflections();
      expect((await service.getReflections()).isEmpty, isTrue);
    });

    test('corrupted JSON entries are skipped gracefully without crashing', () async {
      SharedPreferences.setMockInitialValues({
        'ruang_cerita_reflections_v1': [
          '{"id":"valid_1","timestamp":"2026-10-20T10:00:00.000","feelingId":"cemas","situationId":"pekerjaan","durationId":"hari-ini","summary":"Valid","schemaVersion":1,"isSaved":true}',
          'CORRUPTED_NON_JSON_DATA{{{',
          '{"id":"valid_2","timestamp":"2026-10-20T11:00:00.000","feelingId":"tenang","situationId":"diri-sendiri","durationId":"hari-ini","summary":"Valid 2","schemaVersion":1,"isSaved":true}',
        ],
      });

      StorageService.instance.resetForTesting();
      final service = StorageService.instance;
      final list = await service.getReflections();
      expect(list.length, 2);
      expect(list.any((r) => r.id == 'valid_1'), isTrue);
      expect(list.any((r) => r.id == 'valid_2'), isTrue);
    });

    test('user settings are persisted properly', () async {
      final service = StorageService.instance;

      expect(await service.getAutoSaveEnabled(), isFalse);
      await service.setAutoSaveEnabled(true);
      expect(await service.getAutoSaveEnabled(), isTrue);

      expect(await service.getHideNotificationPreview(), isFalse);
      await service.setHideNotificationPreview(true);
      expect(await service.getHideNotificationPreview(), isTrue);

      expect(await service.getVoiceSpeed(), 1.0);
      await service.setVoiceSpeed(1.2);
      expect(await service.getVoiceSpeed(), 1.2);
    });
  });
}
