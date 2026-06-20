import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/string_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  late TextEditingController _emailController;
  bool _isLoading = false;
  bool _isEmailSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  Future<void> _handlePasswordReset() async {
    if (_emailController.text.isEmpty ||
        !_emailController.text.isValidEmail()) {
      _showErrorSnackBar(ErrorMessages.invalidEmailError);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(
        passwordResetProvider(_emailController.text.trim()).future,
      );

      if (mounted) {
        setState(() {
          _isEmailSent = true;
        });
        _showSuccessSnackBar(SuccessMessages.passwordResetSent);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height - 56,
          child: Column(
            children: [
              if (!_isEmailSent)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Icon
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryColor.withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.lock_reset_outlined,
                            size: 50,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Title
                        Text(
                          'Reset Your Password',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        // Subtitle
                        Text(
                          'Enter your email address and we\'ll send you a link to reset your password.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        // Email field
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          enabled: !_isLoading,
                        ),
                        const SizedBox(height: 32),
                        // Send button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handlePasswordReset,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Send Reset Link',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Success icon
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.successColor.withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.check_circle_outline,
                            size: 50,
                            color: AppTheme.successColor,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Title
                        Text(
                          'Check Your Email',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        // Message
                        Text(
                          'We\'ve sent a password reset link to ${_emailController.text}. Click the link in the email to reset your password.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        // Back to login button
                        ElevatedButton(
                          onPressed: () => context.go(AppRoutes.login),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              'Back to Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
