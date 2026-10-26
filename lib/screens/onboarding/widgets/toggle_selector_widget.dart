import 'package:flutter/material.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_style.dart';

class ToggleSelectorWidget extends StatelessWidget {
  final String title;
  final Widget firstOption;
  final Widget secondOption;
  final bool isFirstSelected;
  final VoidCallback onFirstSelected;
  final VoidCallback onSecondSelected;
  final TextStyle? titleStyle;

  const ToggleSelectorWidget({
    super.key,
    required this.title,
    required this.firstOption,
    required this.secondOption,
    required this.isFirstSelected,
    required this.onFirstSelected,
    required this.onSecondSelected,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: titleStyle ?? AppStyle.bold20),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColor.primary, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: onFirstSelected,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isFirstSelected ? AppColor.primary : AppColor.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: firstOption,
                  ),
                ),
                InkWell(
                  onTap: onSecondSelected,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: !isFirstSelected ? AppColor.primary : AppColor.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: secondOption,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
