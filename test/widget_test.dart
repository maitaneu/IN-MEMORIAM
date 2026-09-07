import 'package:flutter_test/flutter_test.dart';
import 'package:in_memoriam/main.dart';

void main() {
  testWidgets('App arranca correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const InMemoriamApp());
    expect(find.byType(InMemoriamApp), findsOneWidget);
  });
}
