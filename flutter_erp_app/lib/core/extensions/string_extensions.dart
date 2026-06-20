import 'package:email_validator/email_validator.dart';

extension StringExtensions on String {
  /// Check if string is a valid email
  bool isValidEmail() => EmailValidator.validate(this);

  /// Check if string is a valid phone number
  bool isValidPhoneNumber() => RegExp(r'^[0-9]{10,15}$').hasMatch(this);

  /// Check if string has minimum length
  bool isMinLength(int length) => this.length >= length;

  /// Check if string is empty or whitespace only
  bool isEmptyOrWhitespace() => trim().isEmpty;

  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Get initials from string (e.g., "John Doe" -> "JD")
  String getInitials() {
    final parts = split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0].toUpperCase()}${parts[parts.length - 1][0].toUpperCase()}';
  }

  /// Remove all whitespace
  String removeWhitespace() => replaceAll(RegExp(r'\s+'), '');

  /// Check if string contains only letters and spaces
  bool isAlphabetic() => RegExp(r'^[a-zA-Z\s]+$').hasMatch(this);

  /// Check if string contains only numbers
  bool isNumeric() => RegExp(r'^[0-9]+$').hasMatch(this);
}
