import 'package:flutter_test/flutter_test.dart';
import 'package:evently/utils/app_routes.dart';

void main() {
  group('AppRoutes Constants Verification', () {
    test('AppRoutes constants must have valid path names', () {
      expect(AppRoutes.splash, '/splash');
      expect(AppRoutes.onboarding, '/onboarding');
      expect(AppRoutes.login, '/login');
      expect(AppRoutes.register, '/register');
      expect(AppRoutes.forgetPassword, '/forget-password');
      expect(AppRoutes.mainLayout, '/main-layout');
      expect(AppRoutes.createEvent, '/create-event');
      expect(AppRoutes.eventDetails, '/event-details');
      expect(AppRoutes.editEvent, '/edit-event');
    });
  });
}
