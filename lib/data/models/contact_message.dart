/// The contact form payload. Kept as a value object so the provider never has
/// to know which fields the transport needs.
class ContactMessage {
  const ContactMessage({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
  });

  final String name;
  final String email;
  final String subject;
  final String message;

  bool get isEmpty =>
      name.trim().isEmpty &&
      email.trim().isEmpty &&
      subject.trim().isEmpty &&
      message.trim().isEmpty;
}

/// Result of a submission attempt.
enum ContactSubmitStatus { idle, submitting, success, failure }

/// A submission outcome, including a message safe to show to the visitor.
class ContactSubmitResult {
  const ContactSubmitResult.success()
    : status = ContactSubmitStatus.success,
      message = null;

  const ContactSubmitResult.failure(this.message)
    : status = ContactSubmitStatus.failure;

  final ContactSubmitStatus status;
  final String? message;

  bool get isSuccess => status == ContactSubmitStatus.success;
}
