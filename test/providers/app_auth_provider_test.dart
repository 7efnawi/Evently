import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/core/services/firebase_auth_service.dart';
import 'package:evently/providers/app_auth_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FirebaseAuthService fakeService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    fakeService = FirebaseAuthService(firebaseAuth: MockFirebaseAuth());
  });

  group('AppAuthProvider Unit Tests', () {
    test('Initial auth state is unauthenticated', () {
      final provider = AppAuthProvider(authService: fakeService);
      expect(provider.currentUser, isNull);
      expect(provider.isAuthenticated, isFalse);
      expect(provider.isLoading, isFalse);
    });

    test('login with valid credentials authenticates user and notifies listeners', () async {
      final provider = AppAuthProvider(authService: fakeService);
      await provider.register('Test User', 'test@example.com', '123456');

      final loginProvider = AppAuthProvider(authService: fakeService);
      bool notified = false;
      loginProvider.addListener(() => notified = true);

      final success = await loginProvider.login('test@example.com', '123456');

      expect(success, isTrue);
      expect(loginProvider.isAuthenticated, isTrue);
      expect(loginProvider.currentUser?.email, 'test@example.com');
      expect(notified, isTrue);
    });

    test('register creates user and authenticates successfully', () async {
      final provider = AppAuthProvider(authService: fakeService);
      final success = await provider.register('John Safwat', 'john@route.com', '123456');
      expect(success, isTrue);
      expect(provider.currentUser?.name, 'John Safwat');
      expect(provider.currentUser?.email, 'john@route.com');
    });

    test('logout clears user session', () async {
      final provider = AppAuthProvider(authService: fakeService);
      await provider.register('Test', 'test@example.com', '123456');
      expect(provider.isAuthenticated, isTrue);

      await provider.logout();
      expect(provider.currentUser, isNull);
      expect(provider.isAuthenticated, isFalse);
    });

    test('resetPassword calls service and returns true on success', () async {
      final provider = AppAuthProvider(authService: fakeService);
      final success = await provider.resetPassword('any@test.com');
      expect(success, isTrue);
    });

    test('login with empty fields sets errorMessage and returns false', () async {
      final provider = AppAuthProvider(authService: fakeService);
      final success = await provider.login('', '');
      expect(success, isFalse);
      expect(provider.errorMessage, isNotNull);
    });

    test('signInWithGoogle with name and email authenticates fallback', () async {
      final provider = AppAuthProvider(authService: fakeService);
      final success = await provider.signInWithGoogle(
        name: 'Karim Ahmed',
        email: 'karim.ahmed@gmail.com',
      );
      expect(success, isTrue);
      expect(provider.isAuthenticated, isTrue);
      expect(provider.currentUser?.name, 'Karim Ahmed');
      expect(provider.currentUser?.email, 'karim.ahmed@gmail.com');
    });
  });
}
