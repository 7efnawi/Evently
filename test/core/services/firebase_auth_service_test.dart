import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:evently/core/services/firebase_auth_service.dart';

void main() {
  group('FirebaseAuthService', () {
    late MockFirebaseAuth mockAuth;
    late FirebaseAuthService service;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      service = FirebaseAuthService(firebaseAuth: mockAuth);
    });

    test('signUpWithEmail returns UserModel on success', () async {
      final user = await service.signUpWithEmail(
        name: 'Ahmed Ali',
        email: 'ahmed@test.com',
        password: 'password123',
      );
      expect(user, isNotNull);
      expect(user!.email, 'ahmed@test.com');
      expect(user.name, 'Ahmed Ali');
      expect(user.id, isNotEmpty);
    });

    test('signInWithEmail returns UserModel on success', () async {
      await service.signUpWithEmail(
        name: 'Ahmed Ali',
        email: 'ahmed@test.com',
        password: 'password123',
      );
      final user = await service.signInWithEmail(
        email: 'ahmed@test.com',
        password: 'password123',
      );
      expect(user, isNotNull);
      expect(user!.email, 'ahmed@test.com');
    });

    test('sendPasswordResetEmail completes without throwing', () async {
      await expectLater(
        service.sendPasswordResetEmail(email: 'any@test.com'),
        completes,
      );
    });

    test('signOut clears current user', () async {
      await service.signUpWithEmail(
        name: 'Test',
        email: 'test@test.com',
        password: '123456',
      );
      await service.signOut();
      expect(mockAuth.currentUser, isNull);
    });

    test('currentUser returns null when not signed in', () {
      expect(service.currentUser, isNull);
    });
  });
}
