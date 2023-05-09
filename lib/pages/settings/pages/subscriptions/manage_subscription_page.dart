import 'package:flutter/material.dart';
import '../../../../shared/widgets/title_row.dart';

class ManageSubscriptionPage extends StatelessWidget {
  const ManageSubscriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context, title: "Manage Subscription"),
      body: Column(
        children: [
          const Text('Purchased Plan'),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Yearly Plan 5000 PKR'),
                Text('Purchased on 21-01-23 | 07:58 pm'),
              ],
            ),
          ),
          const Text('As a premium member you have access to'),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Column(
              children: const [
                Text('Ad-free App Experience'),
                Text('Unlock Quran Stories'),
                Text('Unlock Quran Stories'),
              ],
            ),
          ),
          const Text('Having an issue? Please write to us'),
          Expanded(
            child: TextFormField(
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your feedback here...',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Submit Feedback'),
          ),
          const Text('Restore Purchase'),
        ],
      ),
    );
  }
}
