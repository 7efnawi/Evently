import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/app_auth_provider.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_style.dart';

class GoogleSignInBottomSheet extends StatefulWidget {
  const GoogleSignInBottomSheet({super.key});

  @override
  State<GoogleSignInBottomSheet> createState() =>
      _GoogleSignInBottomSheetState();
}

class _GoogleSignInBottomSheetState extends State<GoogleSignInBottomSheet> {
  final List<Map<String, String>> _defaultAccounts = const [
    {
      'name': 'Ahmed Ali',
      'email': 'ahmed.ali@gmail.com',
    },
    {
      'name': 'Sara Mohamed',
      'email': 'sara.mohamed@gmail.com',
    },
  ];

  Future<void> _handleAccountSelect(String name, String email) async {
    final authProvider = context.read<AppAuthProvider>();
    final success = await authProvider.signInWithGoogle(
      name: name,
      email: email,
    );
    if (!mounted) return;
    if (success) {
      Navigator.pop(context, true);
    }
  }

  void _showAddAccountDialog() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(
          context.l10n.useAnotherAccount,
          style: AppStyle.bold16,
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: context.l10n.enterName,
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  labelText: context.l10n.enterEmail,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Required';
                  if (!val.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final name = nameCtrl.text.trim();
                final email = emailCtrl.text.trim();
                Navigator.pop(dialogCtx);
                await _handleAccountSelect(name, email);
              }
            },
            child: Text(context.l10n.signIn),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColor.cardDark : AppColor.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            // Google header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppImages.icGoogle,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Google',
                  style: AppStyle.bold20.copyWith(
                    color: isDark ? AppColor.white : AppColor.textBaseDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.chooseAccount,
              style: AppStyle.bold16.copyWith(
                color: isDark ? AppColor.white : AppColor.textBaseDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.continueToEvently,
              style: AppStyle.regular14.copyWith(
                color: AppColor.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            // Pre-configured accounts
            ..._defaultAccounts.map((account) {
              final name = account['name']!;
              final email = account['email']!;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColor.primary,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'G',
                    style: const TextStyle(
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  name,
                  style: AppStyle.bold14.copyWith(
                    color: isDark ? AppColor.white : AppColor.textBaseDark,
                  ),
                ),
                subtitle: Text(
                  email,
                  style: AppStyle.regular14.copyWith(
                    fontSize: 12,
                    color: AppColor.textSecondary,
                  ),
                ),
                onTap: () => _handleAccountSelect(name, email),
              );
            }),
            // Use another account option
            ListTile(
              leading: CircleAvatar(
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                child: Icon(
                  Icons.person_add_alt,
                  color: isDark ? AppColor.white : AppColor.textBaseDark,
                ),
              ),
              title: Text(
                l10n.useAnotherAccount,
                style: AppStyle.bold14.copyWith(
                  color: isDark ? AppColor.white : AppColor.textBaseDark,
                ),
              ),
              onTap: _showAddAccountDialog,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
