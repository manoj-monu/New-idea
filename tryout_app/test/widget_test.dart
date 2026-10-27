import 'package:flutter_test/flutter_test.dart';
import 'package:tryout_app/main.dart';

void main() {
  testWidgets('TryOut app opens with redesigned home screen', (tester) async {
    await tester.pumpWidget(const TryOutApp());
    expect(find.text('TryOut'), findsOneWidget);
    expect(find.text('Try Any Outfit'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text('Browse Categories'), findsOneWidget);
  });
}
