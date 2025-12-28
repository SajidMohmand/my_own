import 'package:flutter/material.dart';

class BankDetailsScreen extends StatelessWidget {
  const BankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 120,
        leading: SizedBox(
          width: 120, // give Row enough space
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.ice_skating_outlined),
              ],
            ),
          ),
        ),

        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Bank Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Bank Name: ABC Bank', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Account Number: 1234567890', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('IFSC Code: ABCD0123456', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
