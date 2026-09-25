import 'package:flutter/foundation.dart';

import '../core/utils/validators.dart';
import '../data/models/contact_message.dart';
import '../data/services/contact_service.dart';

/// Owns every piece of contact form state: the values, per-field validation,
/// submission status and the result message.
///
/// The widget layer binds to this and never talks to [ContactService] directly,
/// which is what makes the form testable with a fake service.
class ContactFormProvider extends ChangeNotifier {
  ContactFormProvider({
    required ContactService service,
    required String fromName,
  })
    // ignore: prefer_initializing_formals
    : _service = service,
       // ignore: prefer_initializing_formals
       _fromName = fromName;

  final ContactService _service;
  final String _fromName;

  // ------------------------------------------------------------------- fields
  String _name = '';
  String _email = '';
  String _subject = '';
  String _message = '';

  // ------------------------------------------------------------------ errors
  final Map<String, String?> _errors = <String, String?>{};
  final Set<String> _touched = <String>{};

  // ------------------------------------------------------------------- state
  ContactSubmitStatus _status = ContactSubmitStatus.idle;
  String? _statusMessage;
  bool _hasSubmitted = false;

  String get name => _name;
  String get email => _email;
  String get subject => _subject;
  String get message => _message;

  ContactSubmitStatus get status => _status;

  String? get statusMessage => _statusMessage;

  bool get isSubmitting => _status == ContactSubmitStatus.submitting;

  bool get isSuccess => _status == ContactSubmitStatus.success;

  /// The form starts in this state when the access key has not been set.
  bool get isConfigured => _service.isConfigured;

  /// Error for [field], but only once the user has interacted with it or tried to
  /// submit — an untouched field should not be red.
  String? errorFor(String field) {
    if (!_touched.contains(field) && !_hasSubmitted) return null;
    return _errors[field];
  }

  void nameChanged(String value) {
    _name = value;
    _validateField('name', Validators.name(value));
  }

  void emailChanged(String value) {
    _email = value;
    _validateField('email', Validators.email(value));
  }

  void subjectChanged(String value) {
    _subject = value;
    _validateField(
      'subject',
      Validators.required(value, minLength: 3, field: 'Subject'),
    );
  }

  void messageChanged(String value) {
    _message = value;
    _validateField(
      'message',
      Validators.message(value) ?? Validators.noUrls(value),
    );
  }

  /// Records a field's validation result and repaints.
  void _validateField(String field, String? error) {
    _errors[field] = error;
    _touched.add(field);
    _clearTransientStatus();
    notifyListeners();
  }

  /// Marks a field as touched so its error appears on blur.
  void markTouched(String field) {
    if (_touched.add(field)) notifyListeners();
  }

  void _clearTransientStatus() {
    if (_status == ContactSubmitStatus.failure ||
        _status == ContactSubmitStatus.success) {
      _status = ContactSubmitStatus.idle;
      _statusMessage = null;
    }
  }

  /// Validates everything and sends the message.
  Future<void> submit() async {
    if (isSubmitting) return;

    _hasSubmitted = true;
    _touched.addAll(<String>['name', 'email', 'subject', 'message']);
    _errors['name'] = Validators.name(_name);
    _errors['email'] = Validators.email(_email);
    _errors['subject'] = Validators.required(
      _subject,
      minLength: 3,
      field: 'Subject',
    );
    _errors['message'] =
        Validators.message(_message) ?? Validators.noUrls(_message);
    notifyListeners();

    if (_errors.values.any((String? error) => error != null)) return;

    _status = ContactSubmitStatus.submitting;
    _statusMessage = null;
    notifyListeners();

    final ContactSubmitResult result = await _service.send(
      message: ContactMessage(
        name: _name,
        email: _email,
        subject: _subject,
        message: _message,
      ),
      fromName: _fromName,
    );

    if (result.isSuccess) {
      _status = ContactSubmitStatus.success;
      _statusMessage = 'Thanks for reaching out. I will get back to you soon.';
      _resetFields();
    } else {
      _status = ContactSubmitStatus.failure;
      _statusMessage = result.message;
    }
    notifyListeners();
  }

  void _resetFields() {
    _name = '';
    _email = '';
    _subject = '';
    _message = '';
    _errors.clear();
    _touched.clear();
  }

  /// Clears a shown success/failure banner without touching the entered values.
  void dismissStatus() {
    if (_status == ContactSubmitStatus.idle) return;
    _status = ContactSubmitStatus.idle;
    _statusMessage = null;
    notifyListeners();
  }

  void reset() {
    _resetFields();
    _hasSubmitted = false;
    _status = ContactSubmitStatus.idle;
    _statusMessage = null;
    notifyListeners();
  }
}
