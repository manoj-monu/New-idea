import 'package:flutter_test/flutter_test.dart';
import 'package:tryout_app/main.dart';

void main() {
  testWidgets('TryOut app opens with home screen', (tester) async {
    await tester.pumpWidget(const TryOutApp());
    expect(find.text('TryOut'), findsOneWidget);
    expect(find.text('Virtual Try-On'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });
}
