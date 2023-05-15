import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test Column Widget', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MyWidget(), // Replace MyWidget with your actual widget name
      ),
    ));

    // Verify that the first Text widget has the correct text
    expect(find.text('Some Address'), findsOneWidget);

    // Verify that the second Text widget has the correct text
    expect(find.text('Your Current Location'), findsOneWidget);
  });
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Some Address',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Your Current Location',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
