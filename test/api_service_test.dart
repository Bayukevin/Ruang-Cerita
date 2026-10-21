import 'package:flutter_test/flutter_test.dart';
import 'package:ruang_cerita/models/ai_reflection_response.dart';
import 'package:ruang_cerita/models/session_request.dart';
import 'package:ruang_cerita/services/api_service.dart';

void main() {
  group('SessionRequest & Payload Serialization', () {
    test('SessionRequest builds expected JSON payload matching PRD', () {
      final req = SessionRequest.fromSelection(
        feelingId: 'cemas',
        situationId: 'pekerjaan',
        durationId: 'beberapa-hari',
        supportGoalId: 'sort_thoughts',
        safetyConcern: 'none',
      );

      final payload = req.toApiPayload(idToken: 'mock_token');
      expect(payload['action'], 'generate_reflection');
      expect(payload['idToken'], 'mock_token');
      expect(payload['data']['feeling'], 'cemas');
      expect(payload['data']['situation'], 'pekerjaan');
      expect(payload['data']['duration'], 'beberapa-hari');
      expect(payload['data']['supportGoal'], 'sort_thoughts');
      expect(payload['data']['safetyConcern'], 'none');
      expect(payload['data']['answers'], isA<List>());
      expect(payload['data']['answers'].first['optionId'], 'beberapa-hari');
    });
  });

  group('AiReflectionResponse Parsing', () {
    test('AiReflectionResponse parses resiliently from standard JSON', () {
      final json = {
        'summary': 'Wajar sekali merasa cemas.',
        'validation': 'Perasaanmu valid.',
        'practicalStep': {
          'id': 'step_1',
          'title': 'Ambil jeda',
          'description': 'Tarik napas dalam-dalam',
        },
        'additionalSteps': ['Langkah 2'],
        'audioScript': 'Versi audio',
        'closingMessage': 'Tetap semangat.',
        'suggestedExercise': {
          'title': 'Latihan napas 1 menit',
          'durationMinutes': 1,
        },
        'isCrisis': false,
        'disclaimer': 'Bukan diagnosis.',
      };

      final resp = AiReflectionResponse.fromJson(json);
      expect(resp.summary, 'Wajar sekali merasa cemas.');
      expect(resp.validation, 'Perasaanmu valid.');
      expect(resp.practicalStep?.title, 'Ambil jeda');
      expect(resp.additionalSteps.length, 1);
      expect(resp.audioScript, 'Versi audio');
      expect(resp.closingMessage, 'Tetap semangat.');
      expect(resp.suggestedExercise?.durationMinutes, 1);
      expect(resp.isCrisis, false);
    });

    test('AiReflectionResponse identifies crisis condition', () {
      final json = {
        'summary': 'Kami mendeteksi kebutuhan bantuan darurat.',
        'isCrisis': true,
      };

      final resp = AiReflectionResponse.fromJson(json);
      expect(resp.isCrisis, isTrue);
    });

    test('AiReflectionResponse handles snake_case alternate fields', () {
      final json = {
        'text': 'Ringkasan refleksi alternatif.',
        'practical_step': {
          'title': 'Rehat 5 menit',
          'description': 'Jeda sejenak',
        },
        'additional_steps': ['Langkah ekstra'],
        'audio_script': 'Teks audio alternatif',
        'closing_message': 'Pesan penutup alternatif',
        'suggested_exercise': {
          'title': 'Napas 3 menit',
          'duration_minutes': 3,
        },
        'is_crisis': false,
      };

      final resp = AiReflectionResponse.fromJson(json);
      expect(resp.summary, 'Ringkasan refleksi alternatif.');
      expect(resp.practicalStep?.title, 'Rehat 5 menit');
      expect(resp.additionalSteps.first, 'Langkah ekstra');
      expect(resp.audioScript, 'Teks audio alternatif');
      expect(resp.suggestedExercise?.durationMinutes, 3);
      expect(resp.isCrisis, isFalse);
    });
  });

  group('ApiService Integration', () {
    test('ApiService checkHealth succeeds against live GAS endpoint', () async {
      final ok = await ApiService.instance.checkHealth();
      expect(ok, isTrue);
    });

    test('generateReflection throws AUTH_REQUIRED when no user logged in', () async {
      final session = SessionRequest.fromSelection(
        feelingId: 'cemas',
        situationId: 'pekerjaan',
        durationId: 'hari-ini',
      );

      expect(
        () => ApiService.instance.generateReflection(session),
        throwsA(
          isA<ApiException>().having(
            (e) => e.code,
            'code',
            'AUTH_REQUIRED',
          ),
        ),
      );
    });
  });

  group('Failure & Safety Conditions (Mock Controlled)', () {
    test('Empty reflection summary is detected as empty', () {
      final json = {
        'summary': '   ',
        'isCrisis': false,
      };
      final resp = AiReflectionResponse.fromJson(json);
      expect(resp.summary.trim().isEmpty, isTrue);
    });

    test('Crisis payload flags isCrisis true and isolates from normal flow', () {
      final mockCrisisJson = {
        'summary': 'Bantuan darurat terdeteksi.',
        'isCrisis': true,
      };
      final resp = AiReflectionResponse.fromJson(mockCrisisJson);
      expect(resp.isCrisis, isTrue);
    });

    test('ApiException holds accurate error code and user-facing message', () {
      const ex1 = ApiException(
        code: 'AUTH_INVALID_OR_EXPIRED_TOKEN',
        message: 'Sesi masukmu perlu diperbarui. Silakan masuk kembali.',
      );
      expect(ex1.code, 'AUTH_INVALID_OR_EXPIRED_TOKEN');
      expect(ex1.message, contains('Sesi masukmu'));

      const ex2 = ApiException(
        code: 'OFFLINE',
        message: 'Koneksi internet belum tersedia. Coba lagi saat koneksi kembali.',
      );
      expect(ex2.code, 'OFFLINE');

      const ex3 = ApiException(
        code: 'TIMEOUT',
        message: 'Respons belum berhasil diterima. Kamu bisa mencoba lagi.',
      );
      expect(ex3.code, 'TIMEOUT');
    });
  });
}
