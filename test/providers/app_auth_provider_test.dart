import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/providers/app_auth_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppAuthProvider Unit Tests', () {
    test('Initial auth state is unauthenticated', () {
      final provider = AppAuthProvider();
      expect(provider.currentUser, isNull);
      expect(provider.isAuthenticated, isFalse);
      expect(provider.isLoading, isFalse);
    });

    test('login with valid credentials authenticates user and notifies listeners', () async {
      final provider = AppAuthProvider();
      bool notified = false;
      provider.addListener(() => notified = true);

      final success = await provider.login('test@example.com', '123456');

      expect(success, isTrue);
      expect(provider.isAuthenticated, isTrue);
      expect(provider.currentUser?.email, 'test@example.com');
      expect(notified, isTrue);
    });

    test('register creates user and authenticates successfully', () async {
      final provider = AppAuthProvider();

      final success = await provider.register('John Safwat', 'john@route.com', '123456');

      expect(success, isTrue);
      expect(provider.currentUser?.name, 'John Safwat');
      expect(provider.currentUser?.email, 'john@route.com');
    });

    test('logout clears user session', () async {
      final provider = AppAuthProvider();
      await provider.login('test@example.com', '123456');
      expect(provider.isAuthenticated, isTrue);

      await provider.logout();
      expect(provider.currentUser, isNull);
      expect(provider.isAuthenticated, isFalse);
    });
  });
}
