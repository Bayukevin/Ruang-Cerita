import 'package:flutter_test/flutter_test.dart';
import 'package:ruang_cerita/firebase_options.dart';
import 'package:ruang_cerita/services/auth_service.dart';

void main() {
  test('DefaultFirebaseOptions contains valid android configuration', () {
    final opts = DefaultFirebaseOptions.android;
    expect(opts.apiKey, isNotEmpty);
    expect(opts.appId, '1:993808199190:android:8baf4821de213c15650f37');
    expect(opts.projectId, 'ruang-cerita-c1e8a');
  });

  test('AuthService.getErrorMessage parses standard error codes', () {
    expect(
      AuthService.getErrorMessage('Custom error string'),
      'Custom error string',
    );
  });
}
