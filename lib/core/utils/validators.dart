/// Form validators. Kept as pure functions so they can be unit tested without
/// pumping a widget.
abstract final class Validators {
  static final RegExp _emailPattern = RegExp(
    r'^[\w.!#$%&*+/=?^`{|}~-]+@[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?'
    r'(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?)+$',
  );

  /// Returns an error message, or `null` when [value] is acceptable.
  static String? required(
    String? value, {
    int minLength = 1,
    String field = 'This field',
  }) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return '$field is required';
    if (trimmed.length < minLength) {
      return '$field must be at least $minLength characters';
    }
    return null;
  }

  static String? email(String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Email is required';
    if (trimmed.length > 254) return 'Email is too long';
    if (!_emailPattern.hasMatch(trimmed)) return 'Enter a valid email address';
    return null;
  }

  static String? name(String? value) {
    return required(value, minLength: 2, field: 'Name');
  }

  static String? message(String? value) {
    return required(value, minLength: 10, field: 'Message');
  }

  /// Rejects obvious spam without being annoying to real visitors.
  static String? noUrls(String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.contains('http://') ||
        trimmed.contains('https://') ||
        trimmed.contains('www.')) {
      return 'Links are not allowed in this field';
    }
    return null;
  }
}
