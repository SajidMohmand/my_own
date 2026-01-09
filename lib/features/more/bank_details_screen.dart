import 'package:banglatiger2/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class BankDetailsScreen extends StatelessWidget {
  const BankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          SizedBox(height: 20,),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.14,
            child: const CustomAppBar(),
          ),


          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [

                SizedBox(height: 40,),
                Text('Bank Name: ABC Bank', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text('Account Number: 1234567890', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text('IFSC Code: ABCD0123456', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ]

      ),
    );
  }
}
