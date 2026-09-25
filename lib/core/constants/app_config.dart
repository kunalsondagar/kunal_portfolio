/// Build-time configuration.
///
/// Values here are the ones a site owner has to fill in before going live.
/// They are deliberately kept out of the data layer so that content edits never
/// risk breaking a build.
abstract final class AppConfig {
  // ------------------------------------------------------------------ contact
  /// Web3Forms access key. Create a free form at https://web3forms.com and
  /// paste the key here; the contact form POSTs straight to their endpoint so
  /// this project needs no backend of its own.
  static const String web3FormsAccessKey = 'PASTE_YOUR_WEB3FORMS_ACCESS_KEY';

  static const String web3FormsEndpoint = 'https://api.web3forms.com/submit';

  // ------------------------------------------------------------------- resume
  /// Served as a static file from `web/resume/`. A placeholder PDF is already
  /// committed, so the button works before you swap in the real one.
  static const String resumeFileName = 'kunal-sondagar-resume.pdf';

  static const String resumePath = 'resume/$resumeFileName';

  // --------------------------------------------------------------------- meta
  static const String siteTitle = 'Kunal Sondagar — Flutter Developer';

  static const String siteDescription =
      'Flutter Developer building modern, scalable and user-focused mobile '
      'applications with Flutter, Dart and Firebase.';

  /// Hide the Web3Forms honeypot field name from real users but let bots fill it.
  static const String honeypotField = 'botcheck';
}
