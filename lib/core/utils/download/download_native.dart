import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Default (non-web) implementation of the file download helper.
///
/// `url_launcher` cannot write to the filesystem, so on native platforms we
/// resolve the asset against the bundle and hand it to the platform viewer,
/// which is the best available behaviour there.
Future<void> downloadFile(String relativePath, String fileName) async {
  final Uri uri = Uri.base.resolve(relativePath);
  debugPrint('downloadFile (native): $fileName -> $uri');
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
