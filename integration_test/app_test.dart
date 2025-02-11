import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uni_app/features/customer/presentation/pages/home/home_page.dart';
import 'package:uni_app/features/customer/presentation/widgets/customer_appointment_tile.dart';
import 'package:uni_app/features/owner/presentation/pages/owner_nav_bar.dart';
import 'package:uni_app/features/owner/presentation/widgets/owner_appointment_tile.dart';
import 'package:uni_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Mock Firebase Initialization
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(); // This can remain in tests
  });

  setUp(() async {
    //reset getit
    GetIt.I.reset();

    // Ensure the user is signed out before starting the test
    try {
      await FirebaseAuth.instance.signOut();
      debugPrint('User signed out successfully.');
    } catch (e) {
      debugPrint('No user was signed in. Continuing...');
    }
  });

  group(
    'Login Test',
    () {
      testWidgets('Verify successful login flow', (WidgetTester tester) async {
        debugPrint('running test...');
        // Start the app
        app.main();
        await tester.pumpAndSettle();

        // Verify that the login screen is displayed
        expect(find.text('Login'), findsOneWidget);

        // Enter email and password
        await tester.enterText(
            find.byKey(const Key('email_field')), 'a@a.gmail.com');
        await tester.enterText(
            find.byKey(const Key('password_field')), '123456');

        // Tap the login button
        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pumpAndSettle();

        // Verify that the user is taken to the home screen
        expect(find.byType(HomePage), findsOneWidget);
      });

      testWidgets('Verify unsuccessful login flow',
          (WidgetTester tester) async {
        debugPrint('running test...');

        // Start the app
        app.main();
        await tester.pumpAndSettle();

        // Verify that the login screen is displayed
        expect(find.text('Login'), findsOneWidget);

        // Enter email and password
        await tester.enterText(
            find.byKey(const Key('email_field')), 'invalidemail@gmail.com');
        await tester.enterText(
            find.byKey(const Key('password_field')), '123456');

        // Tap the login button
        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pumpAndSettle();

        // Verify that a SnackBar is displayed
        final snackBarFinder = find.byType(SnackBar);
        expect(snackBarFinder, findsOneWidget);

        // Verify the content of the SnackBar
        final textFinder = find.descendant(
          of: snackBarFinder,
          matching: find.text(
            '[firebase_auth/invalid-credential] The supplied auth credential is malformed or has expired.',
          ),
        );
        expect(textFinder, findsOneWidget);
      });

      testWidgets('Login as shop owner', (WidgetTester tester) async {
        // Start the app
        app.main();
        await tester.pumpAndSettle();

        // Verify that the login screen is displayed
        expect(find.text('Login'), findsOneWidget);

        // Enter email and password
        await tester.enterText(find.byKey(const Key('email_field')), 'a@a.com');
        await tester.enterText(
            find.byKey(const Key('password_field')), '123456');

        // Tap the login button
        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pumpAndSettle();

        // Verify that the user is taken to the home screen
        expect(find.byType(OwnerNavigationBar), findsOneWidget);

        // Verify that a OwnerAppointmentTile is displayed
        expect(find.byType(OwnerAppointmentTile), findsWidgets);
      });
    },
  );

  group('book appointment', () {
    testWidgets('User can book an appointment', (WidgetTester tester) async {
      debugPrint('running test...');

      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify that the login screen is displayed
      expect(find.text('Login'), findsOneWidget);

      // Enter email and password
      await tester.enterText(
          find.byKey(const Key('email_field')), 'a@a.gmail.com');
      await tester.enterText(find.byKey(const Key('password_field')), '123456');

      // Tap the login button
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Verify that the user is taken to the home screen
      expect(find.byType(HomePage), findsOneWidget);

      // Tap a shop to book an appointment
      await tester.tap(find.byKey(const Key('shop_card')).at(1));
      await tester.pumpAndSettle();

      // Verify that the user is taken to the shop details screen
      expect(find.text('Book Appointment'), findsOneWidget);

      // select the first date
      await tester.tap(find.byKey(const Key('date_picker')).first);
      await tester.pumpAndSettle();

      // select the first time slot
      await tester.tap(find.byKey(const Key('time_slot')).first);
      await tester.pumpAndSettle();

      // Tap the book appointment button
      await tester.tap(find.byKey(const Key('book_appointment_button')));
      await tester.pumpAndSettle();

      // verify that success sheet is displayed
      expect(find.text('Appointment Booked'), findsOneWidget);

      // Tap the done button
      await tester.tap(find.byKey(const Key('done_button')));
      await tester.pumpAndSettle();

      // tab appointments tab in navigation bar
      await tester.tap(find.byKey(const Key('appointments_tab')));
      await tester.pumpAndSettle();

      // 2 seconds delay to allow the appointments to load
      await Future.delayed(const Duration(seconds: 2));

      // verify that the appointment is not empty
      expect(find.byType(CustomerAppointmentTile), findsWidgets);
    });

    testWidgets('User try to book without selecting time slot',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify that the login screen is displayed
      expect(find.text('Login'), findsOneWidget);

      // Enter email and password
      await tester.enterText(
          find.byKey(const Key('email_field')), 'a@a.gmail.com');
      await tester.enterText(find.byKey(const Key('password_field')), '123456');

      // Tap the login button
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Verify that the user is taken to the home screen
      expect(find.byType(HomePage), findsOneWidget);

      // Tap a shop to book an appointment
      await tester.tap(find.byKey(const Key('shop_card')).at(1));
      await tester.pumpAndSettle();

      // Verify that the user is taken to the shop details screen
      expect(find.text('Book Appointment'), findsOneWidget);

      // select the first date
      await tester.tap(find.byKey(const Key('date_picker')).first);
      await tester.pumpAndSettle();

      // Tap the book appointment button
      await tester.tap(find.byKey(const Key('book_appointment_button')));
      await tester.pumpAndSettle();

      // verify the error message
      expect(find.text('Select Date and Time'), findsOneWidget);
    });
  });
}
