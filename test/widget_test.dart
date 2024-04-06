import 'package:flutter_test/flutter_test.dart';
import 'package:vojo/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:mockito/mockito.dart';
import 'package:vojo/index.dart';

// Create a mock for DocumentReference
class MockFirestore extends Mock implements FirebaseFirestore {}


void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LandingPageWidget());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}