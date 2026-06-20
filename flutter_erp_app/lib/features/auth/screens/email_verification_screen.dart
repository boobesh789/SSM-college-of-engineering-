import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends ConsumerState<EmailVerificationScreen> {
  late Future<void> _verificationCheckFuture;
  bool _isChecking = false;
  int _resendCooldown = 0;

  @override
  void initState() {
    super.initState();
    _startVerificationCheck();
  }

  void _startVerificationCheck() {
    _verificationCheckFuture = Future.delayed(const Duration(seconds: 2), () async {
      while (mounted) {
        try {
          final isVerified =
              await ref.read(emailVerificationProvider.future);
          if (isVerified && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Email verified successfully!'),
                backgroundColor: AppTheme.successColor,
              ),
            );
            context.go(AppRoutes.login);
            return;
          }
        } catch (e) {
          // Continue checking
        }
        await Future.delayed(const Duration(seconds: 3));
      }
    });
  }

  Future<void> _handleResendEmail() async {
    setState(() {
      _isChecking = true;
    });

    try {
      await ref.read(resendEmailVerificationProvider.future);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      _startResendCooldown();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  void _startResendCooldown() {
    setState(() {
      _resendCooldown = 60;
    });
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendCooldown--;
        });
      }
      return _resendCooldown > 0 && mounted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryColor.withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.mark_email_unread_outlined,
                    size: 60,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 32),
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Verify Your Email',
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'We\'ve sent a verification link to your email address. Click the link to verify your email and activate your account.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                // Status indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.05),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outlined,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Checking verification status...',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppTheme.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Resend button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ElevatedButton(
                    onPressed: _resendCooldown > 0 || _isChecking
                        ? null
                        : _handleResendEmail,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: _isChecking
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
                          : Text(
                              _resendCooldown > 0
                                  ? 'Resend in $_resendCooldown seconds'
                                  : 'Resend Verification Email',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Back to login button
                TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: const Text('Back to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
