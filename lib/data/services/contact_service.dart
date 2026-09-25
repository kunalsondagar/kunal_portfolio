import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/app_config.dart';
import '../models/contact_message.dart';

/// Sends the contact form to Web3Forms.
///
/// Web3Forms is a hosted form endpoint, so the site needs no backend of its
/// own. The access key lives in [AppConfig] and a honeypot field absorbs naive
/// bots.
class ContactService {
  ContactService({http.Client? client, String? endpoint, String? accessKey})
    : _client = client ?? http.Client(),
      _endpoint = endpoint ?? AppConfig.web3FormsEndpoint,
      _accessKey = accessKey ?? AppConfig.web3FormsAccessKey;

  final http.Client _client;
  final String _endpoint;
  final String _accessKey;

  static const Duration _timeout = Duration(seconds: 20);

  /// Bot trap: real users never see it, naive bots fill every input.
  static const String botValue = '';

  /// True when the owner has not pasted their access key yet, which lets the UI
  /// say something useful instead of silently failing.
  bool get isConfigured =>
      _accessKey.isNotEmpty && !_accessKey.toUpperCase().contains('PASTE_YOUR');

  Future<ContactSubmitResult> send({
    required ContactMessage message,
    required String fromName,
  }) async {
    if (!isConfigured) {
      return const ContactSubmitResult.failure(
        'The contact form is not configured yet. Please email me directly.',
      );
    }

    final Uri uri = Uri.parse(_endpoint);

    try {
      final http.Response response = await _client
          .post(
            uri,
            headers: const <String, String>{
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'access_key': _accessKey,
              'from_name': fromName,
              'name': message.name.trim(),
              'email': message.email.trim(),
              'subject': message.subject.trim(),
              'message': message.message.trim(),
              AppConfig.honeypotField: botValue,
            }),
          )
          .timeout(_timeout);

      return _parse(response);
    } on TimeoutException {
      return const ContactSubmitResult.failure(
        'The request timed out. Please try again, or email me directly.',
      );
    } on Object catch (error) {
      debugPrint('ContactService.send failed: $error');
      return const ContactSubmitResult.failure(
        'Something went wrong while sending. Please email me directly.',
      );
    }
  }

  ContactSubmitResult _parse(http.Response response) {
    if (response.statusCode != 200) {
      debugPrint('ContactService: unexpected status ${response.statusCode}');
      return const ContactSubmitResult.failure(
        'The message could not be sent. Please email me directly.',
      );
    }

    late final Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } on Object {
      debugPrint('ContactService: response was not JSON');
      return const ContactSubmitResult.failure(
        'Unexpected response from the form service. Please email me directly.',
      );
    }

    if (body['success'] == true) {
      return const ContactSubmitResult.success();
    }

    final String? message = body['message'] as String?;
    return ContactSubmitResult.failure(
      message ?? 'The message could not be sent. Please try again.',
    );
  }

  void dispose() => _client.close();
}
