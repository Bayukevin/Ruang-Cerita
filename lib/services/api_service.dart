import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/ai_reflection_response.dart';
import '../models/session_request.dart';
import 'auth_service.dart';

class ApiException implements Exception {
  final String code;
  final String message;

  const ApiException({
    required this.code,
    required this.message,
  });

  @override
  String toString() => 'ApiException($code): $message';
}

class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  static const String baseUrl =
      'https://script.google.com/macros/s/AKfycbwXI_wDt3OInJYy610B24-AZ0WAzITUgvnZnX3U0mXWEmLU70_Ajlrzc50hlc9NElzPqA/exec';

  static const Duration requestTimeout = Duration(seconds: 30);

  /// Health check probe
  Future<bool> checkHealth() async {
    try {
      final res = await _postJson({'action': 'health'});
      return res['ok'] == true;
    } catch (_) {
      return false;
    }
  }

  /// Request reflection generation from backend/Gemini
  Future<AiReflectionResponse> generateReflection(SessionRequest session) async {
    final token = await AuthService.instance.getIdToken();
    if (token == null || token.isEmpty) {
      throw const ApiException(
        code: 'AUTH_REQUIRED',
        message: 'Sesi masukmu perlu diperbarui. Silakan masuk kembali.',
      );
    }

    final payload = session.toApiPayload(idToken: token);
    final responseMap = await _postJson(payload);

    if (responseMap['ok'] != true) {
      final err = responseMap['error'];
      String code = 'API_ERROR';
      String message = 'Terjadi kendala saat memproses refleksi.';

      if (err is Map<String, dynamic>) {
        code = err['code']?.toString() ?? code;
        message = err['message']?.toString() ?? message;
      } else if (err is String) {
        code = err;
        message = _friendlyMessageForCode(err);
      }

      print('DEBUG: backend error code: $code, message: $message');
      throw ApiException(code: code, message: message);
    }

    final rawData = responseMap['data'] ?? responseMap['reflection'] ?? responseMap;
    if (rawData is! Map<String, dynamic>) {
      throw const ApiException(
        code: 'INVALID_DATA',
        message: 'Format data refleksi dari server tidak sesuai.',
      );
    }

    return AiReflectionResponse.fromJson(rawData);
  }

  /// Core HTTP POST implementation with manual 302/303 redirect follow for Google Apps Script
  Future<Map<String, dynamic>> _postJson(Map<String, dynamic> body) async {
    final client = HttpClient();
    client.connectionTimeout = requestTimeout;

    try {
      final uri = Uri.parse(baseUrl);
      final request = await client.postUrl(uri).timeout(requestTimeout);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(body));

      final initialResponse = await request.close().timeout(requestTimeout);

      HttpClientResponse finalResponse = initialResponse;
      if (initialResponse.statusCode == HttpStatus.movedTemporarily ||
          initialResponse.statusCode == HttpStatus.seeOther ||
          initialResponse.statusCode == HttpStatus.movedPermanently) {
        final redirectLocation =
            initialResponse.headers.value(HttpHeaders.locationHeader);
        if (redirectLocation != null && redirectLocation.isNotEmpty) {
          final redirectRequest =
              await client.getUrl(Uri.parse(redirectLocation)).timeout(requestTimeout);
          finalResponse = await redirectRequest.close().timeout(requestTimeout);
        }
      }

      final responseBody = await utf8.decodeStream(finalResponse).timeout(requestTimeout);
      final parsed = jsonDecode(responseBody);
      if (parsed is Map<String, dynamic>) {
        return parsed;
      }
      return {'ok': false, 'error': 'INVALID_JSON_STRUCTURE'};
    } on SocketException {
      throw const ApiException(
        code: 'OFFLINE',
        message: 'Koneksi internet belum tersedia. Coba lagi saat koneksi kembali.',
      );
    } on TimeoutException {
      throw const ApiException(
        code: 'TIMEOUT',
        message: 'Respons belum berhasil diterima. Kamu bisa mencoba lagi.',
      );
    } on FormatException {
      throw const ApiException(
        code: 'INVALID_FORMAT',
        message: 'Ruang Cerita sedang mengalami kendala respons. Coba lagi nanti.',
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        code: 'INTERNAL_ERROR',
        message: 'Terjadi kendala saat menghubungi server.',
      );
    } finally {
      client.close();
    }
  }

  static String _friendlyMessageForCode(String code) {
    switch (code) {
      case 'AUTH_TOKEN_REQUIRED':
      case 'AUTH_REQUIRED':
      case 'AUTH_INVALID_OR_EXPIRED_TOKEN':
        return 'Sesi masukmu perlu diperbarui. Silakan masuk kembali.';
      case 'RATE_LIMITED':
        return 'Terlalu banyak permintaan. Mohon tunggu sejenak.';
      case 'GEMINI_REQUEST_FAILED':
      case 'GEMINI_INVALID_RESPONSE':
        return 'AI pendamping sedang mengalami kendala. Silakan coba lagi.';
      default:
        return 'Terjadi kendala pada layanan. Kamu bisa mencoba lagi.';
    }
  }
}
