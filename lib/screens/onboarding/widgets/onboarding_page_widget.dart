import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_style.dart';
import '../models/onboarding_model.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingModel model;

  const OnboardingPageWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Center(
            child: SvgPicture.asset(
              model.image,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            model.title,
            style: AppStyle.bold20.copyWith(
              color: isDark ? AppColor.white : AppColor.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            model.description,
            style: AppStyle.regular14.copyWith(
              color: isDark ? AppColor.white : AppColor.textBaseDark,
              height: 1.4,
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
