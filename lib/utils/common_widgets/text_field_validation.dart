class FormValidation {
  static String? nameValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (!RegExp(r"^[A-Za-z ]+$").hasMatch(value)) {
      return 'Please input alphabet characters only';
    }
    return null;
  }

  static String? emailValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  static String? usernameValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    // This allows email or username format
    if (value.contains('@')) {
      return emailValidation(value);
    }

    // For username only validation (if not an email)
    if (value.length < 4) {
      return 'Username must be at least 4 characters';
    }

    if (!RegExp(r'^[a-zA-Z0-9._]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, dots and underscores';
    }

    return null;
  }

  static String? passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  static String? phoneValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    if (!RegExp(r'^\d{10}$')
        .hasMatch(value.replaceAll(RegExp(r'[^0-9]'), ''))) {
      return 'Please enter a valid 10-digit phone number';
    }

    return null;
  }

  // A more user-friendly validation for the login screen
  static String? loginPasswordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    // For login, we might want less strict validation
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }
}
