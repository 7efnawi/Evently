import 'package:flutter/material.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_style.dart';

class OrDividerWidget extends StatelessWidget {
  const OrDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          const Expanded(child: Divider(color: AppColor.primary, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Or',
              style: AppStyle.medium16.copyWith(color: AppColor.primary),
            ),
          ),
          const Expanded(child: Divider(color: AppColor.primary, thickness: 1)),
        ],
      ),
    );
  }
}
