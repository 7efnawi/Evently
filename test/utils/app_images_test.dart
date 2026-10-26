import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:evently/utils/app_images.dart';

void main() {
  group('AppImages Constants Verification', () {
    test('AppImages constants should point to valid asset file paths', () {
      expect(AppImages.icSun, 'assets/icons/ic_sun.svg');
      expect(AppImages.icHome, 'assets/icons/ic_home.svg');
      expect(AppImages.icHeart, 'assets/icons/ic_heart.svg');
      expect(AppImages.icProfile, 'assets/icons/ic_profile.svg');
      expect(AppImages.icMapPin, 'assets/icons/ic_map_pin.svg');
      expect(AppImages.icGoogle, 'assets/icons/ic_google.svg');
      expect(AppImages.onboarding1, 'assets/images/onboarding_1.svg');
      expect(AppImages.onboarding2, 'assets/images/onboarding_2.svg');
      expect(AppImages.onboarding3, 'assets/images/onboarding_3.svg');
      expect(AppImages.onboarding4, 'assets/images/onboarding_4.svg');
      expect(AppImages.changeSetting, 'assets/images/change_setting.svg');
    });

    test('Referenced asset files must physically exist on disk', () {
      final assets = [
        AppImages.icSun,
        AppImages.icHome,
        AppImages.icHeart,
        AppImages.icProfile,
        AppImages.icMapPin,
        AppImages.icGoogle,
        AppImages.onboarding1,
        AppImages.onboarding2,
        AppImages.onboarding3,
        AppImages.onboarding4,
        AppImages.changeSetting,
      ];

      for (final assetPath in assets) {
        final file = File(assetPath);
        expect(file.existsSync(), isTrue, reason: 'Missing asset file: $assetPath');
      }
    });
  });
}
