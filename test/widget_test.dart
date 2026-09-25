import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kunal_sondagar_portfolio/app.dart';
import 'package:kunal_sondagar_portfolio/core/utils/validators.dart';
import 'package:kunal_sondagar_portfolio/data/models/contact_message.dart';
import 'package:kunal_sondagar_portfolio/data/models/project.dart';
import 'package:kunal_sondagar_portfolio/data/repositories/portfolio_repository.dart';
import 'package:kunal_sondagar_portfolio/data/repositories/static_portfolio_repository.dart';
import 'package:kunal_sondagar_portfolio/data/services/contact_service.dart';
import 'package:kunal_sondagar_portfolio/features/not_found/view/not_found_view.dart';
import 'package:kunal_sondagar_portfolio/features/project/view/project_view.dart';
import 'package:kunal_sondagar_portfolio/features/project/widgets/project_card.dart';
import 'package:kunal_sondagar_portfolio/providers/contact_form_provider.dart';
import 'package:kunal_sondagar_portfolio/providers/portfolio_provider.dart';
import 'package:kunal_sondagar_portfolio/routing/app_router.dart';

/// A contact service that records calls instead of making them.
class _FakeContactService implements ContactService {
  _FakeContactService({this.result = const ContactSubmitResult.success()});

  ContactSubmitResult result;
  int sendCount = 0;
  ContactMessage? lastMessage;

  @override
  bool get isConfigured => true;

  @override
  Future<ContactSubmitResult> send({
    required ContactMessage message,
    required String fromName,
  }) async {
    sendCount++;
    lastMessage = message;
    return result;
  }

  @override
  void dispose() {}
}

/// Each test gets its own [GoRouter]: sharing the app-wide router across trees
/// leaks navigation state between tests and the delegate is not designed to be
/// re-parented.
Future<void> _pumpPortfolio(
  WidgetTester tester, {
  String initialLocation = '/',
  Size size = const Size(1440, 3200),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final GoRouter router = createAppRouter(initialLocation: initialLocation);
  addTearDown(router.dispose);

  await tester.pumpWidget(PortfolioApp(router: router));
  // Runs the reveal cascade (staggered delays up to 420ms plus the fade) and
  // settles any pending scroll-spy updates.
  await tester.pump(const Duration(milliseconds: 900));
  await tester.pump();
}

void main() {
  group('repository', () {
    const PortfolioRepository repository = StaticPortfolioRepository();

    test('exposes every project with a unique id and route', () {
      final List<Project> projects = repository.projects;
      expect(projects, isNotEmpty);

      final Set<String> ids = projects.map((Project p) => p.id).toSet();
      expect(ids.length, projects.length, reason: 'project ids must be unique');

      for (final Project project in projects) {
        expect(project.route, '/projects/${project.id}');
        expect(project.features, isNotEmpty);
        expect(project.aspects, isNotEmpty);
        expect(project.challenges, isNotEmpty);
        expect(project.stack, isNotEmpty);
        expect(project.screenshots, isNotEmpty);
      }
    });

    test('every screenshot slot points inside its own project folder', () {
      for (final Project project in repository.projects) {
        for (final dynamic slot in project.screenshots) {
          expect(
            (slot.assetPath as String).startsWith('${project.assetFolder}/'),
            isTrue,
            reason:
                '${slot.assetPath} should live under ${project.assetFolder}',
          );
        }
      }
    });

    test('projectById resolves known ids and rejects unknown ones', () {
      expect(repository.projectById('ciya')?.name, 'CIYA Ride Sharing');
      expect(repository.projectById('does-not-exist'), isNull);
      expect(repository.projectById(''), isNull);
    });

    test('nextProject wraps around the end of the list', () {
      final List<Project> projects = repository.projects;
      final Project last = projects.last;
      expect(repository.nextProject(last.id)?.id, projects.first.id);
    });

    test('nav targets all resolve to a real section id', () {
      const Set<String> known = <String>{
        'home',
        'about',
        'skills',
        'experience',
        'projects',
        'services',
        'process',
        'education',
        'resume',
        'contact',
      };
      for (final dynamic item in repository.navItems) {
        expect(known, contains(item.sectionId));
      }
    });
  });

  group('PortfolioProvider', () {
    test('splits game projects out of the app projects', () {
      final PortfolioProvider provider = PortfolioProvider(
        const StaticPortfolioRepository(),
      );
      expect(provider.appProjects, isNotEmpty);
      expect(provider.gameProjects, isNotEmpty);
      expect(
        provider.appProjects.length + provider.gameProjects.length,
        provider.projects.length,
      );
    });
  });

  group('Validators', () {
    test('email accepts valid addresses and rejects malformed ones', () {
      expect(Validators.email('kunal@example.com'), isNull);
      expect(Validators.email('a.b+tag@sub.domain.co'), isNull);
      expect(Validators.email('kunal.sondagar@gmail.com'), isNull);

      expect(Validators.email(''), isNotNull);
      expect(Validators.email('kunal'), isNotNull);
      expect(Validators.email('kunal@'), isNotNull);
      expect(Validators.email('@example.com'), isNotNull);
      expect(Validators.email('kunal @example.com'), isNotNull);
    });

    test('message requires enough characters and rejects links', () {
      expect(Validators.message('Hello there'), isNull);
      expect(Validators.message('short'), isNotNull);
      expect(Validators.message('see https://spam.example.com'), isNull);
      expect(Validators.noUrls('see https://spam.example.com'), isNotNull);
      expect(Validators.noUrls('see www.spam.example.com'), isNotNull);
    });
  });

  group('ContactFormProvider', () {
    test('blocks submission and reports field errors when empty', () async {
      final _FakeContactService service = _FakeContactService();
      final ContactFormProvider form = ContactFormProvider(
        service: service,
        fromName: 'Kunal Sondagar',
      );

      await form.submit();

      expect(service.sendCount, 0);
      expect(form.errorFor('name'), isNotNull);
      expect(form.errorFor('email'), isNotNull);
      expect(form.errorFor('subject'), isNotNull);
      expect(form.errorFor('message'), isNotNull);
    });

    test('does not show errors on untouched fields before submitting', () {
      final ContactFormProvider form = ContactFormProvider(
        service: _FakeContactService(),
        fromName: 'Kunal Sondagar',
      );
      expect(form.errorFor('name'), isNull);
      expect(form.errorFor('email'), isNull);
    });

    test('submits and clears the fields on success', () async {
      final _FakeContactService service = _FakeContactService();
      final ContactFormProvider form = ContactFormProvider(
        service: service,
        fromName: 'Kunal Sondagar',
      );

      form
        ..nameChanged('Kunal Sondagar')
        ..emailChanged('kunal@example.com')
        ..subjectChanged('Flutter role')
        ..messageChanged('I would like to discuss a Flutter position.');

      await form.submit();

      expect(service.sendCount, 1);
      expect(service.lastMessage?.email, 'kunal@example.com');
      expect(form.isSuccess, isTrue);
      expect(form.statusMessage, isNotNull);
      expect(form.name, isEmpty);
      expect(form.message, isEmpty);
    });

    test('surfaces a failure without clearing what was typed', () async {
      final _FakeContactService service = _FakeContactService(
        result: const ContactSubmitResult.failure('Nope.'),
      );
      final ContactFormProvider form = ContactFormProvider(
        service: service,
        fromName: 'Kunal Sondagar',
      );

      form
        ..nameChanged('Kunal')
        ..emailChanged('kunal@example.com')
        ..subjectChanged('Subject')
        ..messageChanged('A message long enough to pass validation.');

      await form.submit();

      expect(form.statusMessage, 'Nope.');
      expect(form.name, 'Kunal');
    });
  });

  group('PortfolioApp', () {
    testWidgets('renders the home page with the hero content', (
      WidgetTester tester,
    ) async {
      await _pumpPortfolio(tester);

      expect(find.text('Kunal Sondagar'), findsWidgets);
      expect(find.text('Flutter Developer'), findsWidgets);
      expect(find.text('View My Work'), findsOneWidget);
      expect(find.text('Download Resume'), findsWidgets);
    });

    testWidgets('renders every project card on the home page', (
      WidgetTester tester,
    ) async {
      await _pumpPortfolio(tester);

      for (final Project project
          in const StaticPortfolioRepository().projects) {
        expect(
          find.text(project.name),
          findsWidgets,
          reason: '${project.name} should appear on the home page',
        );
      }
    });

    testWidgets('navigates to a project detail page', (
      WidgetTester tester,
    ) async {
      await _pumpPortfolio(tester);

      // Tap the whole card rather than the "View project" label: ensureVisible
      // parks a target at the very top of the scroll view, right under the
      // fixed navbar, which would swallow the tap.
      final Finder cta = find.text('View project').first;
      final Finder card = find.ancestor(
        of: cta,
        matching: find.byType(ProjectCard),
      );
      await tester.ensureVisible(card);
      await tester.pumpAndSettle();
      await tester.tap(card);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 900));

      expect(find.byType(ProjectView), findsOneWidget);
      expect(
        find.text('What this app does'),
        findsOneWidget,
        reason: 'the detail page should render its overview block',
      );
      expect(
        // SectionEyebrow upper-cases its label.
        find.text('CHALLENGES & SOLUTIONS'),
        findsOneWidget,
        reason: 'the detail page should render its challenges block',
      );
    });

    testWidgets('shows a not-found state for an unknown project id', (
      WidgetTester tester,
    ) async {
      await _pumpPortfolio(
        tester,
        initialLocation: '/projects/does-not-exist',
        size: const Size(1440, 2000),
      );

      expect(find.byType(ProjectView), findsOneWidget);
      expect(find.text('Project not found'), findsOneWidget);
      expect(
        find.textContaining('does-not-exist'),
        findsOneWidget,
        reason: 'the message should name the id that was not found',
      );
      expect(find.text('Back to all projects'), findsOneWidget);
    });

    testWidgets('renders the 404 page for an unknown route', (
      WidgetTester tester,
    ) async {
      await _pumpPortfolio(
        tester,
        initialLocation: '/nope/nope',
        size: const Size(1440, 2000),
      );

      expect(find.byType(NotFoundView), findsOneWidget);
      expect(find.text('404'), findsOneWidget);
      expect(find.text('This page does not exist'), findsOneWidget);
    });

    testWidgets('opens a project directly from a deep link', (
      WidgetTester tester,
    ) async {
      await _pumpPortfolio(
        tester,
        initialLocation: '/projects/occasion',
        size: const Size(1440, 2400),
      );

      final Project project = const StaticPortfolioRepository().projectById(
        'occasion',
      )!;

      expect(find.byType(ProjectView), findsOneWidget);
      expect(find.text('What this app does'), findsOneWidget);
      expect(find.text(project.name), findsWidgets);
    });
  });
}
