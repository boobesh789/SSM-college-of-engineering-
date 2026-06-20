import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/string_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _registrationNumberController;

  String _selectedRole = UserRole.student;
  String _selectedDepartment = Departments.cse;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _registrationNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _registrationNumberController.dispose();
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

  bool _validateForm() {
    if (_fullNameController.text.isEmpty) {
      _showErrorSnackBar('Please enter your full name');
      return false;
    }

    if (!_fullNameController.text.isAlphabetic()) {
      _showErrorSnackBar('Full name should contain only letters');
      return false;
    }

    if (_emailController.text.isEmpty || !_emailController.text.isValidEmail()) {
      _showErrorSnackBar(ErrorMessages.invalidEmailError);
      return false;
    }

    if (_passwordController.text.isEmpty ||
        _passwordController.text.length < ValidationConstants.minPasswordLength) {
      _showErrorSnackBar(ErrorMessages.invalidPasswordError);
      return false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar(ErrorMessages.passwordMismatchError);
      return false;
    }

    if (_phoneController.text.isNotEmpty &&
        !_phoneController.text.isValidPhoneNumber()) {
      _showErrorSnackBar('Please enter a valid phone number');
      return false;
    }

    if (_selectedRole == UserRole.student &&
        _registrationNumberController.text.isEmpty) {
      _showErrorSnackBar('Please enter your registration number');
      return false;
    }

    return true;
  }

  Future<void> _handleRegistration() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final params = {
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'fullName': _fullNameController.text.trim(),
        'role': _selectedRole,
        'department': _selectedDepartment,
        'phoneNumber': _phoneController.text.isNotEmpty
            ? _phoneController.text
            : null,
        'registrationNumber':
            _selectedRole == UserRole.student && _registrationNumberController.text.isNotEmpty
                ? _registrationNumberController.text
                : null,
      };

      // Filter out null values
      params.removeWhere((key, value) => value == null);

      await ref.read(registrationProvider(params).future);

      if (mounted) {
        _showSuccessSnackBar(SuccessMessages.registrationSuccess);
        // Navigate to email verification screen
        context.push(AppRoutes.emailVerification);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              'Create Your Account',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Join SSM Student Hub and manage your academics',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Full Name
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            // Email
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
            const SizedBox(height: 16),
            // Phone Number
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number (Optional)',
                hintText: 'Enter your phone number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            // Role Selection
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Role',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              items: [UserRole.student, UserRole.faculty, UserRole.hod]
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role.capitalize()),
                      ))
                  .toList(),
              onChanged: _isLoading
                  ? null
                  : (value) {
                      setState(() {
                        _selectedRole = value ?? UserRole.student;
                      });
                    },
            ),
            const SizedBox(height: 16),
            // Department Selection
            DropdownButtonFormField<String>(
              value: _selectedDepartment,
              decoration: const InputDecoration(
                labelText: 'Department',
                prefixIcon: Icon(Icons.domain_outlined),
              ),
              items: Departments.allDepartments
                  .map((dept) => DropdownMenuItem(
                        value: dept,
                        child: Text(dept),
                      ))
                  .toList(),
              onChanged: _isLoading
                  ? null
                  : (value) {
                      setState(() {
                        _selectedDepartment = value ?? Departments.cse;
                      });
                    },
            ),
            const SizedBox(height: 16),
            // Registration Number (for students)
            if (_selectedRole == UserRole.student)
              Column(
                children: [
                  TextFormField(
                    controller: _registrationNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Registration Number',
                      hintText: 'Enter your registration number',
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            // Password
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
              ),
              obscureText: !_isPasswordVisible,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            // Confirm Password
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Confirm your password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isConfirmPasswordVisible,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 32),
            // Register Button
            ElevatedButton(
              onPressed: _isLoading ? null : _handleRegistration,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: _isLoading ? null : () => context.pop(),
                  child: const Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
