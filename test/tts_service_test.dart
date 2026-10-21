import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ruang_cerita/services/tts_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final List<MethodCall> channelCalls = [];

  setUp(() {
    channelCalls.clear();
    TtsService.instance.resetForTesting();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter_tts'),
      (MethodCall methodCall) async {
        channelCalls.add(methodCall);
        switch (methodCall.method) {
          case 'isLanguageAvailable':
            return 1;
          case 'setLanguage':
          case 'setSpeechRate':
          case 'setVolume':
          case 'setPitch':
          case 'speak':
          case 'stop':
            return 1;
          default:
            return 1;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_tts'), null);
  });

  group('TtsService', () {
    test('init sets language to id-ID and default audio params', () async {
      final tts = TtsService.instance;
      await tts.init();

      expect(
          channelCalls.any((c) =>
              c.method == 'setLanguage' && c.arguments == 'id-ID'),
          isTrue);
      expect(channelCalls.any((c) => c.method == 'setVolume'), isTrue);
      expect(channelCalls.any((c) => c.method == 'setPitch'), isTrue);
    });

    test('speak sends text to native flutter_tts channel', () async {
      final tts = TtsService.instance;
      await tts.speak('Halo, ini uji coba suara.');

      expect(
          channelCalls.any((c) =>
              c.method == 'speak' &&
              c.arguments == 'Halo, ini uji coba suara.'),
          isTrue);
    });

    test('stop sends stop command', () async {
      final tts = TtsService.instance;
      await tts.stop();

      expect(channelCalls.any((c) => c.method == 'stop'), isTrue);
    });

    test('setSpeechRate configures speech rate', () async {
      final tts = TtsService.instance;
      await tts.setSpeechRate(0.8);

      expect(channelCalls.any((c) => c.method == 'setSpeechRate'), isTrue);
    });

    test('speakingStream emits state updates', () async {
      final tts = TtsService.instance;
      final states = <bool>[];
      final sub = tts.speakingStream.listen(states.add);

      await tts.speak('Coba suara');
      await tts.stop();

      await Future.delayed(const Duration(milliseconds: 50));
      expect(states.contains(true), isTrue);
      expect(states.contains(false), isTrue);

      await sub.cancel();
    });
  });
}
