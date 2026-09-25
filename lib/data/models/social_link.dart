import 'package:flutter/material.dart';

enum SocialPlatform { email, linkedin, github, phone, website }

/// A contact / social destination. [value] holds the raw text to show
/// (address, handle) and [uri] the target to open.
class SocialLink {
  const SocialLink({
    required this.platform,
    required this.label,
    required this.value,
    required this.uri,
    this.icon,
  });

  final SocialPlatform platform;

  /// Short name used in menus and the footer, e.g. "GitHub".
  final String label;

  /// The text shown to the visitor, e.g. "github.com/kunalsondagar".
  final String value;

  /// What actually gets opened. For email/phone this is a `mailto:` / `tel:` URI.
  final String uri;

  final IconData? icon;

  bool get opensApp =>
      platform == SocialPlatform.email || platform == SocialPlatform.phone;
}
