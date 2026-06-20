import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/string_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool _validateForm() {
    if (_emailController.text.isEmpty) {
      _showErrorSnackBar('Please enter your email');
      return false;
    }

    if (!_emailController.text.isValidEmail()) {
      _showErrorSnackBar(ErrorMessages.invalidEmailError);
      return false;
    }

    if (_passwordController.text.isEmpty) {
      _showErrorSnackBar('Please enter your password');
      return false;
    }

    if (_passwordController.text.length < ValidationConstants.minPasswordLength) {
      _showErrorSnackBar(ErrorMessages.invalidPasswordError);
      return false;
    }

    return true;
  }

  Future<void> _handleLogin() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Use the loginProvider with proper parameters
      final result = await ref.read(
        loginProvider({
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        }).future,
      );

      if (mounted) {
        _showSuccessSnackBar('Login successful!');
        // Navigation is handled by the router based on user role
        // The GoRouter will automatically redirect to the appropriate dashboard
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
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Column(
            children: [
              // Header with gradient background
              Container(
                width: double.infinity,
                height: size.height * 0.25,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryColor,
                      Color(0xFF1565C0),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.school_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'SSM Student Hub',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'College ERP System',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              // Login form
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email field
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        keyboardType: TextInputType.emailAddress,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 20),
                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        obscureText: !_isPasswordVisible,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 12),
                      // Forgot password link
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _isLoading
                              ? null
                              : () => context.push(AppRoutes.forgotPassword),
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Login button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
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
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Register link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account? ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () => context.push(AppRoutes.registration),
                            child: const Text('Register Now'),
                          ),
                        ],
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
