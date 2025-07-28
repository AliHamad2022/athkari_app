// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:athkari_app/main.dart';

void main() {
  testWidgets('Should display a zikr on startup', (WidgetTester tester) async {
    await tester.pumpWidget(const AthkariApp());

    // تحقق أن هناك نص من الأذكار معروض
    expect(find.textContaining('الله'), findsWidgets); // مثال

    // تحقق أن زر "ذكر آخر" موجود
    expect(find.text('ذكر آخر'), findsOneWidget);
  });
}
