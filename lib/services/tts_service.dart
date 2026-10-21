import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService._();
  static final TtsService instance = TtsService._();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  bool _isSpeaking = false;
  double _speechRate = 0.5;

  final StreamController<bool> _speakingStateController =
      StreamController<bool>.broadcast();

  bool get isSpeaking => _isSpeaking;
  Stream<bool> get speakingStream => _speakingStateController.stream;

  @visibleForTesting
  void setMockTts(FlutterTts mock) {
    _flutterTts = mock;
    _isInitialized = true;
  }

  @visibleForTesting
  void resetForTesting() {
    _flutterTts = null;
    _isInitialized = false;
    _isSpeaking = false;
  }

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      _flutterTts ??= FlutterTts();
      final tts = _flutterTts!;

      // Configure Indonesian voice if available
      final isIdAvailable = await tts.isLanguageAvailable('id-ID');
      if (isIdAvailable == true || isIdAvailable == 1) {
        await tts.setLanguage('id-ID');
      }

      await tts.setSpeechRate(_speechRate);
      await tts.setVolume(1.0);
      await tts.setPitch(1.0);

      tts.setStartHandler(() {
        _isSpeaking = true;
        _speakingStateController.add(true);
      });

      tts.setCompletionHandler(() {
        _isSpeaking = false;
        _speakingStateController.add(false);
      });

      tts.setCancelHandler(() {
        _isSpeaking = false;
        _speakingStateController.add(false);
      });

      tts.setErrorHandler((dynamic message) {
        _isSpeaking = false;
        _speakingStateController.add(false);
      });

      _isInitialized = true;
    } catch (_) {
      // Platform channel not available or permission denied; fail gracefully
      _isInitialized = false;
    }
  }

  Future<void> speak(String text) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) {
      await stop();
      return;
    }

    await stop();

    if (!_isInitialized) {
      await init();
    }

    try {
      _isSpeaking = true;
      _speakingStateController.add(true);
      await _flutterTts?.speak(cleanText);
    } catch (_) {
      _isSpeaking = false;
      _speakingStateController.add(false);
    }
  }

  Future<void> stop() async {
    if (!_isInitialized) {
      await init();
    }
    try {
      await _flutterTts?.stop();
    } catch (_) {
      // ignore
    } finally {
      _isSpeaking = false;
      _speakingStateController.add(false);
    }
  }

  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate.clamp(0.1, 1.0);
    if (!_isInitialized) {
      await init();
    }
    try {
      await _flutterTts?.setSpeechRate(_speechRate);
    } catch (_) {
      // ignore
    }
  }
}
