import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reflection_record.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  static const String _keyReflections = 'ruang_cerita_reflections_v1';
  static const String _keyAutoSave = 'ruang_cerita_setting_auto_save';
  static const String _keyHideNotification = 'ruang_cerita_setting_hide_notification';
  static const String _keyVoiceSpeed = 'ruang_cerita_setting_voice_speed';

  SharedPreferences? _prefs;

  @visibleForTesting
  void setMockPrefs(SharedPreferences mock) {
    _prefs = mock;
  }

  @visibleForTesting
  void resetForTesting() {
    _prefs = null;
  }

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Get all saved reflections, newest first. Resilient against corrupted entries.
  Future<List<ReflectionRecord>> getReflections() async {
    try {
      final prefs = await _getPrefs();
      final list = prefs.getStringList(_keyReflections);
      if (list == null || list.isEmpty) {
        return [];
      }

      final records = <ReflectionRecord>[];
      for (final jsonStr in list) {
        try {
          final decoded = jsonDecode(jsonStr);
          if (decoded is Map<String, dynamic>) {
            records.add(ReflectionRecord.fromJson(decoded));
          }
        } catch (_) {
          // Skip corrupted record to protect user experience
        }
      }

      records.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return records;
    } catch (_) {
      return [];
    }
  }

  /// Save or update a reflection record
  Future<bool> saveReflection(ReflectionRecord record) async {
    try {
      final prefs = await _getPrefs();
      final existing = await getReflections();
      final updated = existing.where((r) => r.id != record.id).toList();
      updated.insert(0, record);

      final stringList =
          updated.map((r) => jsonEncode(r.toJson())).toList();
      return await prefs.setStringList(_keyReflections, stringList);
    } catch (_) {
      return false;
    }
  }

  /// Delete a single reflection by id
  Future<bool> deleteReflection(String id) async {
    try {
      final prefs = await _getPrefs();
      final existing = await getReflections();
      final updated = existing.where((r) => r.id != id).toList();

      final stringList =
          updated.map((r) => jsonEncode(r.toJson())).toList();
      return await prefs.setStringList(_keyReflections, stringList);
    } catch (_) {
      return false;
    }
  }

  /// Clear all saved reflections
  Future<bool> clearAllReflections() async {
    try {
      final prefs = await _getPrefs();
      return await prefs.remove(_keyReflections);
    } catch (_) {
      return false;
    }
  }

  // --- User Preferences ---

  Future<bool> getAutoSaveEnabled() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getBool(_keyAutoSave) ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setAutoSaveEnabled(bool value) async {
    try {
      final prefs = await _getPrefs();
      return await prefs.setBool(_keyAutoSave, value);
    } catch (_) {
      return false;
    }
  }

  Future<bool> getHideNotificationPreview() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getBool(_keyHideNotification) ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setHideNotificationPreview(bool value) async {
    try {
      final prefs = await _getPrefs();
      return await prefs.setBool(_keyHideNotification, value);
    } catch (_) {
      return false;
    }
  }

  Future<double> getVoiceSpeed() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getDouble(_keyVoiceSpeed) ?? 1.0;
    } catch (_) {
      return 1.0;
    }
  }

  Future<bool> setVoiceSpeed(double value) async {
    try {
      final prefs = await _getPrefs();
      return await prefs.setDouble(_keyVoiceSpeed, value);
    } catch (_) {
      return false;
    }
  }
}
