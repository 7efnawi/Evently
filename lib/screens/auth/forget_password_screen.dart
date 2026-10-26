import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/app_auth_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_images.dart';
import '../../utils/app_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AppAuthProvider>();
    final success =
        await authProvider.resetPassword(_emailController.text.trim());

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset link sent to your email.'),
          backgroundColor: AppColor.primary,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLoading = context.watch<AppAuthProvider>().isLoading;

    return Scaffold(
      backgroundColor:
          isDark ? AppColor.backgroundDark : AppColor.backgroundLight,
      appBar: AppBar(
        title: Text('Forget Password', style: AppStyle.bold20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: SvgPicture.asset(
                    AppImages.changeSetting,
                    height: 280,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  hint: 'E-mail',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColor.textSecondary,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomElevatedButton(
                  title: 'Reset Password',
                  isLoading: isLoading,
                  onPressed: _handleReset,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
