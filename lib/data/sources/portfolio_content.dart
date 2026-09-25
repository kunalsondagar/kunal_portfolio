import 'package:flutter/material.dart';

import '../models/education_item.dart';
import '../models/experience_entry.dart';
import '../models/nav_item.dart';
import '../models/process_step.dart';
import '../models/project.dart';
import '../models/project_support.dart';
import '../models/profile.dart';
import '../models/profile_fact.dart';
import '../models/service_item.dart';
import '../models/skill_group.dart';
import '../models/social_link.dart';
import '../../core/theme/app_colors.dart';

/// Every piece of copy on the site.
///
/// ---------------------------------------------------------------------------
/// BEFORE PUBLISHING — replace the placeholder contact details near the bottom
/// of this file:
///   * [emailAddress], [linkedinUrl], [githubUrl], [phoneNumber]
///   * the Play Store / App Store links on projects (currently omitted on
///     purpose, so no store URL is invented)
/// Also confirm the challenge copy on each project matches what really happened.
/// ---------------------------------------------------------------------------
abstract final class PortfolioContent {
  // =====================================================================
  // Navigation & section anchors
  // =====================================================================

  static const List<NavItem> navItems = <NavItem>[
    NavItem(label: 'Home', sectionId: SectionIds.home),
    NavItem(label: 'About', sectionId: SectionIds.about),
    NavItem(label: 'Skills', sectionId: SectionIds.skills),
    NavItem(label: 'Experience', sectionId: SectionIds.experience),
    NavItem(label: 'Projects', sectionId: SectionIds.projects),
    NavItem(label: 'Contact', sectionId: SectionIds.contact),
  ];

  // =====================================================================
  // Profile
  // =====================================================================

  static const Profile profile = Profile(
    name: 'Kunal Sondagar',
    role: 'Flutter Developer',
    headline: 'Building modern, scalable and user-focused mobile applications with Flutter & Dart.',
    intro: 'Flutter Developer focused on building cross-platform mobile applications with clean UI, reliable API integration and scalable architecture.',
    location: 'Surat, Gujarat, India',
    experienceYears: '2+ Years',
    specialization: 'Flutter Development',
    educationLine: 'BE Computer Engineering',
    heroBadges: <String>[
      'Flutter',
      'Dart',
      'Firebase',
      'REST API',
      'BLoC',
      'GetX',
    ],
    focusAreas: <String>[
      'Clean Architecture',
      'Pixel-accurate UI',
      'API integration',
      'Performance',
      'State management',
    ],
    aboutParagraphs: <String>[
      "I'm Kunal Sondagar, a Flutter Developer focused on building cross-platform mobile applications with clean UI, reliable API integration and scalable architecture.",
      'Most of my work is production Flutter development: taking designs from Figma to a shipped Android and iOS build, wiring up REST APIs and Firebase, and making sure the app stays smooth once real users start pushing it. I have shipped ride sharing, food ordering, service booking, cashback and utility apps, plus a level-based game project built with Flutter.',
      'I care about the parts of the job that are easy to skip — clean state management, sensible folder structure, handling loading and error states properly, and removing jank. Working this way makes an app much easier to maintain, and much easier for the next developer to pick up.',
    ],
    heroStats: <StatItem>[
      StatItem(
        value: '2+',
        label: 'Years Experience',
        icon: Icons.badge_outlined,
      ),
      StatItem(
        value: 'Flutter',
        label: 'Primary Framework',
        icon: Icons.flutter_dash,
      ),
      StatItem(
        value: 'Android & iOS',
        label: 'Cross-platform',
        icon: Icons.devices_outlined,
      ),
    ],
  );

  // =====================================================================
  // About — quick facts
  // =====================================================================

  static const List<ProfileFact> aboutFacts = <ProfileFact>[
    ProfileFact(
      label: 'Experience',
      value: '2+ Years',
      icon: Icons.work_history_outlined,
    ),
    ProfileFact(
      label: 'Specialization',
      value: 'Flutter Development',
      icon: Icons.phone_iphone_rounded,
    ),
    ProfileFact(
      label: 'Location',
      value: 'Surat, Gujarat',
      icon: Icons.place_outlined,
    ),
    ProfileFact(
      label: 'Education',
      value: 'BE Computer Engineering',
      icon: Icons.school_outlined,
    ),
  ];

  // =====================================================================
  // Skills
  // =====================================================================

  static const List<SkillGroup> skillGroups = <SkillGroup>[
    SkillGroup(
      title: 'Mobile Development',
      icon: Icons.phone_iphone_rounded,
      blurb: 'Shipping one codebase to both Android and iOS.',
      accent: AppColors.flutterBlue,
      highlighted: <String>['Flutter', 'Dart'],
      skills: <String>[
        'Flutter',
        'Dart',
        'Android',
        'iOS',
        'Responsive UI',
        'Custom Paint',
        'Animations',
      ],
    ),
    SkillGroup(
      title: 'State Management',
      icon: Icons.account_tree_outlined,
      blurb: 'Predictable state with a clear source of truth.',
      accent: AppColors.violet,
      highlighted: <String>['BLoC', 'GetX'],
      skills: <String>[
        'BLoC',
        'GetX',
        'Provider',
        'Streams',
        'Dependency Injection',
      ],
    ),
    SkillGroup(
      title: 'Backend & APIs',
      icon: Icons.api_outlined,
      blurb: 'Consuming, modelling and error-handling remote data.',
      accent: AppColors.cyan,
      highlighted: <String>['REST API', 'Authentication'],
      skills: <String>[
        'REST API',
        'JSON',
        'Socket.IO',
        'Authentication',
        'Pagination',
        'Caching',
        'Error handling',
      ],
    ),
    SkillGroup(
      title: 'Firebase',
      icon: Icons.local_fire_department_outlined,
      blurb: 'Auth, data, files and messaging without a backend.',
      accent: AppColors.warning,
      highlighted: <String>['Firebase Auth', 'Firestore'],
      skills: <String>[
        'Firebase Auth',
        'Firestore',
        'Realtime Database',
        'Cloud Storage',
        'Push Notifications',
        'Crashlytics',
      ],
    ),
    SkillGroup(
      title: 'Integrations',
      icon: Icons.extension_outlined,
      blurb: 'Maps, payments, ads and social login done properly.',
      accent: AppColors.success,
      highlighted: <String>['Maps', 'Payments'],
      skills: <String>[
        'Google Sign-In',
        'Maps & Polylines',
        'Payment Integration',
        'In-App Purchase',
        'AdMob',
        'AppLovin',
        'Facebook Ads',
      ],
    ),
    SkillGroup(
      title: 'Tools & Workflow',
      icon: Icons.construction_outlined,
      blurb: 'The day-to-day toolchain around the code.',
      accent: AppColors.textSecondary,
      highlighted: <String>['Git / GitHub', 'Android Studio'],
      skills: <String>[
        'Git / GitHub',
        'Jira',
        'VS Code',
        'Android Studio',
        'Postman',
        'Figma',
        'Chrome DevTools',
      ],
    ),
  ];

  // =====================================================================
  // Experience
  // =====================================================================

  static const List<ExperienceEntry> experiences = <ExperienceEntry>[
    ExperienceEntry(
      company: 'Monarchy Infotech',
      role: 'Flutter Developer',
      period: 'Jun 2026 — Present',
      location: 'Surat, Gujarat',
      isCurrent: true,
      summary: 'Building and maintaining Flutter applications end to end, from API contracts to store releases.',
      responsibilities: <String>[
        'Develop Flutter applications for Android and iOS from a single codebase.',
        'Integrate REST APIs and model the data layer for maintainable feature code.',
        'Implement UI from designs with attention to spacing, typography and responsiveness.',
        'Manage state with BLoC / GetX and keep UI, business logic and data access separated.',
        'Work with Firebase for authentication, data storage and push notifications.',
        'Fix bugs, reduce rebuild and jank, and improve build and release performance.',
      ],
      stack: <String>[
        'Flutter',
        'Dart',
        'BLoC',
        'GetX',
        'REST API',
        'Firebase',
        'Git',
      ],
    ),
    ExperienceEntry(
      company: 'Regumsoft Infotech',
      role: 'Flutter Developer',
      period: 'Jul 2024 — Jan 2026',
      location: 'Surat, Gujarat',
      summary: 'Delivered cross-platform client applications and kept them stable in production.',
      responsibilities: <String>[
        'Built cross-platform Flutter applications covering full user flows.',
        'Integrated REST APIs, authentication and third-party SDKs into the app.',
        'Implemented Firebase services for auth, data and messaging.',
        'Applied BLoC and GetX for state management across complex screens.',
        'Integrated payment, maps and advertising SDKs.',
        'Maintained and improved existing apps based on QA feedback and crash reports.',
      ],
      stack: <String>[
        'Flutter',
        'Dart',
        'REST API',
        'Firebase',
        'BLoC',
        'GetX',
        'Socket.IO',
        'Payment',
      ],
    ),
  ];

  // =====================================================================
  // Projects
  // =====================================================================

  static const List<Project> projects = <Project>[
    Project(
      id: 'ciya',
      number: '01',
      name: 'CIYA Ride Sharing',
      tagline: 'Ride booking with live driver tracking',
      category: ProjectCategory.app,
      role: 'Flutter Developer — full feature build',
      accent: AppColors.flutterBlue,
      platforms: <String>['Android', 'iOS'],
      stack: <String>[
        'Flutter',
        'Dart',
        'GetX',
        'REST API',
        'Firebase',
        'Google Maps',
      ],
      cardSummary: 'A ride sharing app with separate rider and driver modules — booking, car selection, driver assignment and live location on the map.',
      overview: 'CIYA connects riders with nearby drivers for city trips. The app is built as two modules from one Flutter codebase: a rider experience for searching a ride and tracking it, and a driver experience for going online, accepting requests and completing fares. Location is the heart of the product, so the map and live driver position drive most of the key screens.',
      features: <String>[
        'Separate rider and driver modules',
        'Ride booking with pickup and drop-off selection',
        'Car selection with available ride types',
        'Driver availability and request assignment',
        'Live driver location on the map',
        'Ride status tracking from request to completion',
        'Map with markers and route polylines',
        'Firebase authentication and push notifications',
      ],
      aspects: <ProjectAspect>[
        ProjectAspect(
          label: 'Architecture',
          points: <String>[
            'Rider and driver flows kept in separate modules over a shared core.',
            'Feature-first folder structure with reusable widgets and theme tokens.',
            'Thin UI layer: screens render state and forward events, nothing else.',
          ],
        ),
        ProjectAspect(
          label: 'State management',
          points: <String>[
            'GetX controllers for ride lifecycle, booking flow and driver state.',
            'Bindings for dependency injection so dependencies are created lazily.',
            'Reactive widgets rebuilt only for the observable state they read.',
          ],
        ),
        ProjectAspect(
          label: 'APIs & data',
          points: <String>[
            'Typed REST API layer for booking, driver and fare endpoints.',
            'Centralised error handling and loading states per request.',
            'Reusable HTTP client with interceptors and timeouts.',
          ],
        ),
        ProjectAspect(
          label: 'Maps & location',
          points: <String>[
            'Google Maps with custom markers for rider and driver.',
            'Polylines drawn between pickup and drop-off.',
            'Location permissions handled with a clear denied-permission path.',
          ],
        ),
      ],
      challenges: <ProjectChallenge>[
        ProjectChallenge(
          problem: 'The driver\'s location has to update continuously without dropping frames or hammering the battery.',
          solution: 'Throttled location updates and pushed map camera moves instead of rebuilding the whole map widget, so tracking stays smooth and the battery impact stays low.',
        ),
        ProjectChallenge(
          problem: 'Ride state can change from several directions at once — rider action, driver action and backend push.',
          solution: 'Made the ride lifecycle a single source of truth in a GetX controller, so every screen renders from the same state and conflicting updates cannot occur.',
        ),
        ProjectChallenge(
          problem: 'Long screens with map, fare summary and car list are easy to make janky.',
          solution: 'Split them into focused widgets, kept the map out of the rebuild path with Obx scoping, and profiled release builds to confirm the frame budget.',
        ),
      ],
      screenshots: <ProjectScreenshotSlot>[
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/ciya/01-rider-home.png',
          caption: 'Rider home — pickup and drop-off entry',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/ciya/02-car-selection.png',
          caption: 'Car selection with available ride types',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/ciya/03-driver-tracking.png',
          caption: 'Live driver location with route polyline',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/ciya/04-driver-dashboard.png',
          caption: 'Driver module — requests and availability',
        ),
      ],
    ),

    Project(
      id: 'occasion',
      number: '02',
      name: 'Occasion',
      tagline: 'Plan events together with family',
      category: ProjectCategory.app,
      role: 'Flutter Developer — features and integrations',
      accent: AppColors.violet,
      platforms: <String>['Android', 'iOS'],
      stack: <String>[
        'Flutter',
        'BLoC',
        'REST API',
        'Firebase',
        'Push Notifications',
      ],
      cardSummary: 'An event scheduling app where families organise occasions together — guests, invitations and reminders in one place.',
      overview: 'Occasion removes the group-chat scramble around family events. One person creates the occasion, invites family members, and everyone can add guests, confirm attendance and see updates. The app handles invitations, reminders and the event schedule so nobody misses the important part.',
      features: <String>[
        'Event and occasion scheduling',
        'Family and group collaboration',
        'Guest list management and invitations',
        'Push notifications and reminders',
        'Event detail with date, venue and schedule',
        'Attendance and RSVP tracking',
        'Firebase authentication and realtime data',
      ],
      aspects: <ProjectAspect>[
        ProjectAspect(
          label: 'Architecture',
          points: <String>[
            'Layered structure: presentation, domain logic and data access.',
            'BLoC per feature area so screens stay declarative.',
            'Reusable widgets and theme tokens shared across the app.',
          ],
        ),
        ProjectAspect(
          label: 'State management',
          points: <String>[
            'BLoC for event, guest and invitation state.',
            'Events and transformers for debouncing input and parallel loading.',
            'UI depends only on bloc state, never on raw API responses.',
          ],
        ),
        ProjectAspect(
          label: 'Backend',
          points: <String>[
            'REST API for events, guests and invitations.',
            'Firestore for realtime collaboration and offline-friendly reads.',
            'Firebase Cloud Messaging for invitations and reminders.',
          ],
        ),
        ProjectAspect(
          label: 'Collaborative editing',
          points: <String>[
            'Realtime listeners so every member sees the same guest list.',
            'Conflict-safe merges by treating the backend as the source of truth.',
            'Optimistic local updates to keep the UI instant on slow networks.',
          ],
        ),
      ],
      challenges: <ProjectChallenge>[
        ProjectChallenge(
          problem: 'Several family members edit the same guest list at the same time and changes were overwriting each other.',
          solution: 'Moved the shared state to a realtime store with per-record timestamps, so concurrent edits merge instead of clobbering, and added optimistic updates so the UI never lags behind a tap.',
        ),
        ProjectChallenge(
          problem: 'Reminder notifications fired at the wrong time because they were scheduled in device local time.',
          solution: 'Normalised every timestamp to UTC on write, converted to local time only for display, and validated the conversion with tests around day boundaries and timezone changes.',
        ),
      ],
      screenshots: <ProjectScreenshotSlot>[
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/occasion/01-events.png',
          caption: 'Upcoming occasions list',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/occasion/02-event-detail.png',
          caption: 'Event detail with date, venue and schedule',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/occasion/03-guests.png',
          caption: 'Guest list and RSVP tracking',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/occasion/04-invitations.png',
          caption: 'Invitations and reminders',
        ),
      ],
    ),

    Project(
      id: 'omf',
      number: '03',
      name: 'OMF — Oh My Food',
      tagline: 'Restaurant ordering with live order tracking',
      category: ProjectCategory.app,
      role: 'Flutter Developer — ordering flow and checkout',
      accent: Color(0xFFFF7A45),
      platforms: <String>['Android', 'iOS'],
      stack: <String>['Flutter', 'BLoC', 'REST API', 'Payments'],
      cardSummary: 'A food ordering app covering restaurant and menu browsing, cart, checkout, payments and order tracking.',
      overview: 'OMF — Oh My Food takes a customer from browsing restaurants to tracking a delivery. Menus load per restaurant with a cart that stays consistent through checkout, and once the order is placed the customer can follow its status until it arrives.',
      features: <String>[
        'Restaurant and menu browsing',
        'Category-wise menu navigation',
        'Cart with quantity management',
        'Address management and checkout',
        'Payment integration',
        'Order placement and history',
        'Order status tracking',
      ],
      aspects: <ProjectAspect>[
        ProjectAspect(
          label: 'Architecture',
          points: <String>[
            'Feature-first layering: presentation, logic and data per feature.',
            'Repository pattern between blocs and the network layer.',
            'Route-per-feature so blocs can be scoped and disposed correctly.',
          ],
        ),
        ProjectAspect(
          label: 'State management',
          points: <String>[
            'BLoC for cart, checkout and order tracking.',
            'Cart kept as a single immutable state object to avoid drift.',
            'Streams for order status polling while an order is active.',
          ],
        ),
        ProjectAspect(
          label: 'APIs',
          points: <String>[
            'REST endpoints for restaurants, menus, cart and orders.',
            'Dart models with null-safe parsing and safe fallbacks for missing fields.',
            'A single error-mapping layer so every screen shows the same failure UI.',
          ],
        ),
        ProjectAspect(
          label: 'Payments',
          points: <String>[
            'Payment flow integrated with clear pending, success and failure states.',
            'Order creation guarded so a failed payment never creates a duplicate order.',
          ],
        ),
      ],
      challenges: <ProjectChallenge>[
        ProjectChallenge(
          problem: 'The cart total kept drifting out of sync with the server as items were added or removed quickly.',
          solution: 'Made the server the authority for pricing, sent a single recalculation request per cart change and debounced rapid taps, so the displayed total always matched what would be charged.',
        ),
        ProjectChallenge(
          problem: 'A payment could succeed while the order request timed out, leaving the customer with no order.',
          solution: 'Added an idempotent order creation call keyed on the payment id, plus a recovery step that checks payment status before retrying, so no order is lost or duplicated.',
        ),
      ],
      screenshots: <ProjectScreenshotSlot>[
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/omf/01-restaurants.png',
          caption: 'Restaurant listing',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/omf/02-menu.png',
          caption: 'Menu browsing by category',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/omf/03-cart.png',
          caption: 'Cart with quantity management',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/omf/04-tracking.png',
          caption: 'Order status tracking',
        ),
      ],
    ),

    Project(
      id: 'velox',
      number: '04',
      name: 'Velox Solutions',
      tagline: 'On-demand service booking with worker tracking',
      category: ProjectCategory.app,
      role: 'Flutter Developer — booking and worker module',
      accent: AppColors.cyan,
      platforms: <String>['Android', 'iOS'],
      stack: <String>[
        'Flutter',
        'REST API',
        'PhonePe',
        'Google Maps',
        'Push Notifications',
      ],
      cardSummary: 'A service booking platform with customer and worker modules, map-based worker location, payments and status updates.',
      overview: 'Velox Solutions connects customers who need a service with available workers. A customer books a slot, a worker accepts it, and both sides follow the job status on a map. Payments run through PhonePe, and notifications keep both parties informed at every stage.',
      features: <String>[
        'Service catalogue and slot booking',
        'Customer and worker modules',
        'Worker assignment and acceptance',
        'Map with worker location during the job',
        'Service submission with completion details',
        'PhonePe payment integration',
        'Push notifications for status changes',
      ],
      aspects: <ProjectAspect>[
        ProjectAspect(
          label: 'Architecture',
          points: <String>[
            'Shared codebase with role-based routing into customer or worker flows.',
            'Service layer wrapping all network calls behind typed methods.',
            'Centralised configuration for base URLs, keys and environment.',
          ],
        ),
        ProjectAspect(
          label: 'State management',
          points: <String>[
            'Provider combined with controllers for booking and job state.',
            'State restored on resume so a backgrounded user keeps their place.',
          ],
        ),
        ProjectAspect(
          label: 'Maps & payments',
          points: <String>[
            'Maps with worker markers and job locations.',
            'PhonePe payment integration with a verified and fallback state.',
            'Payment success reconciled against the booking record before confirming.',
          ],
        ),
        ProjectAspect(
          label: 'Notifications',
          points: <String>[
            'Device token registration at login.',
            'Topic and per-user notifications for assignment and status updates.',
          ],
        ),
      ],
      challenges: <ProjectChallenge>[
        ProjectChallenge(
          problem: 'Payment callbacks from PhonePe sometimes arrived after the app was closed, leaving the booking stuck as pending.',
          solution: 'Treated the payment callback as a hint rather than the source of truth and reconciled the booking status with the backend on next launch, so a booking can never stay stuck in a pending state.',
        ),
        ProjectChallenge(
          problem: 'Customer and worker roles needed completely different navigation and screens from one app.',
          solution: 'Resolved the role once at login and drove routing, navigation and permissions from that, which removed a whole class of wrong-screen and missing-permission bugs.',
        ),
      ],
      screenshots: <ProjectScreenshotSlot>[
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/velox/01-services.png',
          caption: 'Service catalogue',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/velox/02-booking.png',
          caption: 'Slot booking flow',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/velox/03-worker-map.png',
          caption: 'Worker location during the job',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/velox/04-payment.png',
          caption: 'Payment and booking confirmation',
        ),
      ],
    ),

    Project(
      id: 'couponcred',
      number: '05',
      name: 'Couponcred',
      tagline: 'Cashback, coupons and reward games',
      category: ProjectCategory.app,
      role: 'Flutter Developer — rewards, ads and monetisation',
      accent: AppColors.success,
      platforms: <String>['Android', 'iOS'],
      stack: <String>[
        'Flutter',
        'Firebase',
        'In-App Purchase',
        'AdMob',
        'AppLovin',
        'Facebook Ads',
      ],
      cardSummary: 'A rewards app with cashback offers, coupons, scratch cards, spin-the-wheel and coin redemption, monetised with ads and in-app purchases.',
      overview: 'Couponcred rewards everyday shopping. Users browse cashback offers and coupons, collect coins through scratch cards and spin rewards, and redeem those coins for rewards. Revenue comes from three ad networks alongside in-app purchases, which makes ad placement and load timing a real engineering concern rather than a cosmetic one.',
      features: <String>[
        'Cashback offers and coupon wallet',
        'Scratch card and spin-the-wheel rewards',
        'Coin balance with redemption',
        'In-app purchases for coins',
        'AdMob, AppLovin and Facebook Ads monetisation',
        'Firebase auth and remote configuration',
      ],
      aspects: <ProjectAspect>[
        ProjectAspect(
          label: 'Architecture',
          points: <String>[
            'Reward flows isolated behind a service so game logic stays testable.',
            'Configuration-driven ad placement instead of hardcoded call sites.',
          ],
        ),
        ProjectAspect(
          label: 'State management',
          points: <String>[
            'Provider for coin balance and reward state.',
            'Local persistence so balance and history survive app restarts.',
          ],
        ),
        ProjectAspect(
          label: 'Firebase',
          points: <String>[
            'Firebase Auth for sign-in, including Google Sign-In.',
            'Remote configuration to tune offers and ad behaviour without a release.',
          ],
        ),
        ProjectAspect(
          label: 'Monetisation',
          points: <String>[
            'Mediation across AdMob, AppLovin and Facebook Ads.',
            'In-app purchase flow with receipt validation before granting coins.',
            'Ad slots pre-loaded and shown only when a fill is ready, so the UI never stalls.',
          ],
        ),
      ],
      challenges: <ProjectChallenge>[
        ProjectChallenge(
          problem: 'Screens felt slow and ad slots flashed empty while waiting for a network fill.',
          solution: 'Pre-load ads and gate the slot on a ready instance, so a screen either shows a filled ad or nothing at all — no shifting layout and no visible loading state.',
        ),
        ProjectChallenge(
          problem: 'Coin balances drifted out of sync between the device and the backend.',
          solution: 'Made the server balance authoritative, validated in-app purchase receipts before granting anything locally, and only updated the UI after the server confirmed.',
        ),
      ],
      screenshots: <ProjectScreenshotSlot>[
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/couponcred/01-offers.png',
          caption: 'Cashback offers and coupon wallet',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/couponcred/02-scratch.png',
          caption: 'Scratch card rewards',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/couponcred/03-spin.png',
          caption: 'Spin-the-wheel reward flow',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/couponcred/04-coins.png',
          caption: 'Coin balance and redemption',
        ),
      ],
    ),

    Project(
      id: 'sukhi',
      number: '06',
      name: 'Sukhi',
      tagline: 'Secure local-first utility app',
      category: ProjectCategory.app,
      role: 'Flutter Developer — auth, storage and security',
      accent: Color(0xFFA78BFA),
      platforms: <String>['Android', 'iOS'],
      stack: <String>[
        'Flutter',
        'Dart',
        'Firebase',
        'SQLite',
        'Google Sign-In',
      ],
      cardSummary: 'A utility app with authentication, Google Sign-In, encrypted local storage and API integration — built to work offline.',
      overview: 'Sukhi is a utility app where reliability and privacy matter more than visual effects. It supports email and Google Sign-In, keeps user data available offline through encrypted local storage, and syncs with remote APIs when a connection is available.',
      features: <String>[
        'Email and password authentication',
        'Google Sign-In',
        'Encrypted local storage with SQLite',
        'Offline-first data access',
        'REST API integration and sync',
        'Session persistence across restarts',
      ],
      aspects: <ProjectAspect>[
        ProjectAspect(
          label: 'Architecture',
          points: <String>[
            'Repository pattern separating local storage from remote data.',
            'A single source of truth so offline and online paths cannot diverge.',
            'Feature modules with explicit dependencies rather than global lookups.',
          ],
        ),
        ProjectAspect(
          label: 'State management',
          points: <String>[
            'Provider for auth and app session state.',
            'Scoped providers per feature so state is disposed with the screen.',
          ],
        ),
        ProjectAspect(
          label: 'Security',
          points: <String>[
            'Sensitive values encrypted at rest in local storage.',
            'Secure token storage with sign-out clearing every local trace.',
            'Google Sign-In integrated alongside the native email flow.',
          ],
        ),
        ProjectAspect(
          label: 'Data',
          points: <String>[
            'SQLite for structured local data and fast offline reads.',
            'Sync layer that reconciles local changes with the API on reconnect.',
          ],
        ),
      ],
      challenges: <ProjectChallenge>[
        ProjectChallenge(
          problem: 'The app had to stay usable with no network, which previously meant blank screens on every tab.',
          solution: 'Made local storage the primary read path and treated the API as a sync source, so the app renders immediately from local data and quietly reconciles when a connection returns.',
        ),
        ProjectChallenge(
          problem: 'User data and auth tokens were stored in plain text on the device.',
          solution: 'Encrypted values at rest, kept tokens out of shared storage, and cleared every local artefact on sign-out so a shared device leaks nothing.',
        ),
      ],
      screenshots: <ProjectScreenshotSlot>[
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/sukhi/01-auth.png',
          caption: 'Authentication with email and Google Sign-In',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/sukhi/02-home.png',
          caption: 'Home screen loaded from local storage',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/sukhi/03-offline.png',
          caption: 'Offline state with pending sync',
        ),
      ],
    ),

    Project(
      id: 'arrow-escape',
      number: '07',
      name: 'Arrow Escape',
      tagline: 'A 500-level Flutter puzzle game',
      category: ProjectCategory.game,
      role: 'Game Developer — design, logic and UI',
      accent: Color(0xFFF472B6),
      platforms: <String>['Android', 'iOS'],
      stack: <String>[
        'Flutter',
        'Dart',
        'Custom Paint',
        'Animations',
        'SQLite',
      ],
      cardSummary: 'A level-based puzzle game with custom-built game UI, 500 progressive levels, coin rewards and sound — all in Flutter.',
      overview: 'Arrow Escape is a personal game project: a puzzle game where the player has to escape across 500 progressively harder levels. Everything is built in Flutter — the board, the custom animations, the level progression and the reward loop. It is deliberately separate from the client work, because it shows a different side: game logic, feel, and shipping something end to end on my own.',
      features: <String>[
        '500 progressive levels',
        'Level-based progression with unlock flow',
        'Custom game UI and board rendering',
        'Custom animations and transitions',
        'Coin and reward system',
        'Sound and music',
        'Local progress persistence',
      ],
      aspects: <ProjectAspect>[
        ProjectAspect(
          label: 'Game architecture',
          points: <String>[
            'Pure Dart game logic separated from rendering, so rules are testable.',
            'A fixed-timestep loop with an interpolation factor for smooth frames.',
            'Level definitions as data, which keeps adding levels a content change.',
          ],
        ),
        ProjectAspect(
          label: 'Rendering & feel',
          points: <String>[
            'Custom painting for the board and pieces.',
            'Animation controllers driving transitions between states.',
            'Frame budget respected so input always feels immediate.',
          ],
        ),
        ProjectAspect(
          label: 'Progression & rewards',
          points: <String>[
            'Coins earned per level and spent on retries or hints.',
            'Progress, unlocks and best times persisted locally.',
          ],
        ),
        ProjectAspect(
          label: 'Audio',
          points: <String>[
            'Preloaded sound effects to avoid latency on the first tap.',
            'Music and effects routed through independent volume controls.',
          ],
        ),
      ],
      challenges: <ProjectChallenge>[
        ProjectChallenge(
          problem: 'On lower-end devices the game ran visibly below 60fps, which made the controls feel laggy.',
          solution: 'Moved per-frame work out of the build method into a single ticker-driven update, culled off-screen work, and preloaded audio so no first-tap stutter was introduced.',
        ),
        ProjectChallenge(
          problem:
              'Hand-authoring 500 levels was repetitive and easy to get wrong.',
          solution: 'Moved level definitions into data files with validation, so levels are authored once and a bad definition is caught immediately instead of surfacing as an unplayable level.',
        ),
      ],
      screenshots: <ProjectScreenshotSlot>[
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/arrow-escape/01-level.png',
          caption: 'Level board and controls',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/arrow-escape/02-move.png',
          caption: 'Piece movement animation',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/arrow-escape/03-levels.png',
          caption: 'Level map and unlock progress',
        ),
        ProjectScreenshotSlot(
          assetPath: 'assets/images/projects/arrow-escape/04-rewards.png',
          caption: 'Coins and reward flow',
        ),
      ],
    ),
  ];

  // =====================================================================
  // Services
  // =====================================================================

  static const List<ServiceItem> services = <ServiceItem>[
    ServiceItem(
      title: 'Flutter App Development',
      icon: Icons.phone_iphone_rounded,
      description: 'Complete Android and iOS applications from a single Flutter codebase, structured so they are easy to extend.',
      points: <String>['Cross-platform builds', 'Store-ready releases'],
    ),
    ServiceItem(
      title: 'UI Implementation',
      icon: Icons.design_services_outlined,
      description: 'Pixel-accurate, responsive interfaces built from Figma files with a shared theme and reusable components.',
      points: <String>['Figma to Flutter', 'Responsive layouts'],
    ),
    ServiceItem(
      title: 'API Integration',
      icon: Icons.api_outlined,
      description: 'REST APIs wired into a clean data layer, with proper loading, error and retry states instead of a screen that only works on a good network.',
      points: <String>['Typed data models', 'Error and retry states'],
    ),
    ServiceItem(
      title: 'Firebase Integration',
      icon: Icons.local_fire_department_outlined,
      description: 'Authentication, realtime data, file storage and push notifications set up properly, including the security rules.',
      points: <String>['Auth & realtime data', 'Push notifications'],
    ),
    ServiceItem(
      title: 'App Optimization',
      icon: Icons.speed_outlined,
      description: 'Profiling and fixing the things users actually feel: jank, slow cold starts, excessive rebuilds and bloated builds.',
      points: <String>['Jank & rebuild fixes', 'Build size reduction'],
    ),
    ServiceItem(
      title: 'Third-Party Integration',
      icon: Icons.extension_outlined,
      description: 'Maps, payments, ads, social login and SDK integrations, including the platform configuration and edge cases they require.',
      points: <String>['Maps & payments', 'Ads & social login'],
    ),
  ];

  // =====================================================================
  // Process
  // =====================================================================

  static const List<ProcessStep> processSteps = <ProcessStep>[
    ProcessStep(
      number: '01',
      title: 'Understand',
      description: 'Clarify the requirement before writing anything — who uses it, what they need to do, and what the backend actually exposes.',
      points: <String>['Requirement walkthrough', 'API contract review'],
    ),
    ProcessStep(
      number: '02',
      title: 'Design',
      description: 'Turn the requirement into a screen flow and a folder structure, and set up the theme, components and state approach up front.',
      points: <String>['Screen flow', 'Theme & component setup'],
    ),
    ProcessStep(
      number: '03',
      title: 'Develop',
      description: 'Build feature by feature against the design, wiring the data layer and state management as each screen is needed.',
      points: <String>['Feature-wise delivery', 'State management wiring'],
    ),
    ProcessStep(
      number: '04',
      title: 'Test',
      description: 'Check the flows end to end on a real device — loading, empty, error and offline states included, not just the happy path.',
      points: <String>['Device testing', 'Edge case handling'],
    ),
    ProcessStep(
      number: '05',
      title: 'Deploy & Maintain',
      description: 'Ship a release build, then keep it stable: crash triage, performance work and incremental improvements after launch.',
      points: <String>['Release builds', 'Crash & performance fixes'],
    ),
  ];

  // =====================================================================
  // Education
  // =====================================================================

  static const List<EducationItem> education = <EducationItem>[
    EducationItem(
      degree: 'Bachelor of Engineering',
      field: 'Computer Engineering',
      institution: 'SSASIT',
      university: 'Gujarat Technological University',
      period: 'Graduation',
      highlights: <EducationHighlight>[
        EducationHighlight(label: 'CGPA', value: '7.71'),
        EducationHighlight(label: 'Backlogs', value: '0'),
      ],
    ),
  ];

  // =====================================================================
  // Resume CTA
  // =====================================================================

  static const List<String> resumeHighlights = <String>[
    '2+ Years of professional Flutter experience',
    'Multiple production Android and iOS applications',
    'Worked across client projects and independently',
  ];

  // =====================================================================
  // Contact
  // =====================================================================

  static const String contactHeading = "Let's Build Something Together";

  static const String contactSubtitle =
      'I am open to Flutter developer roles and freelance projects. '
      'If you have an app in mind, or just want to talk about Flutter, '
      'send a message and I will get back to you.';

  // ---------------------------------------------------------------- placeholders
  /// TODO: replace with your real address.
  static const String emailAddress = 'kunal.sondagar@gmail.com';

  /// TODO: replace with your real profile URLs.
  static const String linkedinUrl =
      'https://www.linkedin.com/in/kunal-sondagar/';

  static const String githubUrl = 'https://github.com/kunalsondagar';

  /// TODO: replace with your real number. The value below is not a valid number,
  /// it is a placeholder so the button cannot reach anyone by accident.
  static const String phoneDisplay = '+91 00000 00000';

  static const String phoneUri = 'tel:+910000000000';

  static const List<SocialLink> socialLinks = <SocialLink>[
    SocialLink(
      platform: SocialPlatform.email,
      label: 'Email',
      value: emailAddress,
      uri: 'mailto:$emailAddress',
      icon: Icons.alternate_email_rounded,
    ),
    SocialLink(
      platform: SocialPlatform.linkedin,
      label: 'LinkedIn',
      value: 'linkedin.com/in/kunal-sondagar',
      uri: linkedinUrl,
      icon: Icons.code_rounded,
    ),
    SocialLink(
      platform: SocialPlatform.github,
      label: 'GitHub',
      value: 'github.com/kunalsondagar',
      uri: githubUrl,
      icon: Icons.code_rounded,
    ),
    SocialLink(
      platform: SocialPlatform.phone,
      label: 'Phone',
      value: phoneDisplay,
      uri: phoneUri,
      icon: Icons.phone_rounded,
    ),
  ];
}

/// Section ids shared by the nav, the scroll anchors and the router.
abstract final class SectionIds {
  static const String home = 'home';
  static const String about = 'about';
  static const String skills = 'skills';
  static const String experience = 'experience';
  static const String projects = 'projects';
  static const String services = 'services';
  static const String process = 'process';
  static const String education = 'education';
  static const String resume = 'resume';
  static const String contact = 'contact';
}
