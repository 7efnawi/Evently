import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_auth_provider.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_style.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AppAuthProvider>().currentUser;
    final userName = currentUser?.name.isNotEmpty == true ? currentUser!.name : 'John Safwat';
    final userEmail = currentUser?.email.isNotEmpty == true ? currentUser!.email : 'johnsafwat.route@gmail.com';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 24),
      decoration: const BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(64),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: Radius.circular(1000),
                bottomRight: Radius.circular(1000),
              ),
              border: Border.all(color: AppColor.white, width: 2),
            ),
            child: const Icon(Icons.person, size: 64, color: AppColor.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName,
                  style: AppStyle.bold24.copyWith(color: AppColor.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  userEmail,
                  style: AppStyle.medium16.copyWith(color: AppColor.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
