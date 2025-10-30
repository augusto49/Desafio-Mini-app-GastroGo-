import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastrogo/main.dart';

void main() {
  testWidgets('GastroGo smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: GastroGoApp()));

    expect(find.text('GastroGo'), findsOneWidget);
  });
}
