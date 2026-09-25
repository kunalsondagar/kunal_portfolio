import 'package:web/web.dart' as web;

/// Web implementation of the file download helper.
///
/// Builds a real anchor element with the `download` attribute so the browser
/// saves the file instead of trying to render it in a tab.
Future<void> downloadFile(String relativePath, String fileName) async {
  final Uri uri = Uri.base.resolve(relativePath);
  final web.HTMLAnchorElement anchor =
      web.document.createElement('a') as web.HTMLAnchorElement
        ..href = uri.toString()
        ..download = fileName
        ..style.display = 'none';

  web.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
}
