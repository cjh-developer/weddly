import 'package:flutter_test/flutter_test.dart';
import 'package:weddly_frontend/main.dart';

void main() {
  testWidgets('Weddly app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WeddlyApp());
  });
}
