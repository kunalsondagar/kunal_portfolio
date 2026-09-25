import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'download/download_native.dart'
    if (dart.library.js_interop) 'download/download_web.dart'
    as impl;

/// Opens external URLs and downloads static files, without ever letting a
/// platform error bubble up into the widget tree.
abstract final class ExternalLink {
  /// Opens [url] in a new tab / external app.
  static Future<bool> open(String url) async {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      debugPrint('ExternalLink: refusing to open malformed url "$url"');
      return false;
    }
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Object catch (error) {
      debugPrint('ExternalLink: failed to open "$url" -> $error');
      return false;
    }
  }

  /// Opens a `mailto:` with an optional prefilled subject and body.
  static Future<bool> email({
    required String address,
    String? subject,
    String? body,
  }) {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: address,
      queryParameters: <String, String>{
        if (subject != null && subject.isNotEmpty) 'subject': subject,
        if (body != null && body.isNotEmpty) 'body': body,
      },
    );
    return open(uri.toString());
  }

  /// Saves a file that is served next to the app (see `web/`).
  static Future<void> download(
    String relativePath, {
    required String fileName,
  }) {
    return impl.downloadFile(relativePath, fileName);
  }
}
