import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/models/social_link.dart';

/// Brand marks for the contact / social links.
///
/// Material Icons has no brand glyphs, so the font that does is used for exactly
/// this one job while the rest of the UI stays on Material icons.
FaIconData brandIconFor(SocialPlatform platform) {
  return switch (platform) {
    SocialPlatform.email => FontAwesomeIcons.envelope,
    SocialPlatform.linkedin => FontAwesomeIcons.linkedin,
    SocialPlatform.github => FontAwesomeIcons.github,
    SocialPlatform.phone => FontAwesomeIcons.phone,
    SocialPlatform.website => FontAwesomeIcons.globe,
  };
}
