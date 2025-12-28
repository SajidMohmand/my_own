import '../../widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'product_screen.dart';
import 'notification_screen.dart';
import 'about_us_screen.dart';
import 'bank_details_screen.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(

      body: SafeArea(
        child: Column(
         children: [
           CustomAppBar(),
        
           Padding(
             padding: const EdgeInsets.all(16),
             child: Column(
               children: [
        
                 Card(
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(12),
                   ),
                   elevation: 2,
                   child: Padding(
                     padding: const EdgeInsets.all(16),
                     child: Row(
                       children: const [
                         CircleAvatar(
                           radius: 28,
                           child: Icon(Icons.person, size: 30),
                         ),
                         SizedBox(width: 16),
                         Text(
                           'Hi Guest',
                           style: TextStyle(
                             fontSize: 18,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
        
                 const SizedBox(height: 20),
        
                 /// Menu Container
                 Container(
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(12),
                     border: Border.all(color: Colors.grey.shade300),
                   ),
                   child: Column(
                     children: [
                       _menuTile(
                         context,
                         icon: Icons.shopping_bag,
                         title: 'Product',
                         screen: const ProductScreen(),
                       ),
                       _divider(),
                       _menuTile(
                         context,
                         icon: Icons.notifications,
                         title: 'Notification',
                         screen: const NotificationScreen(),
                       ),
                       _divider(),
                       _menuTile(
                         context,
                         icon: Icons.info_outline,
                         title: 'About Us',
                         screen: const AboutUsScreen(),
                       ),
                       _divider(),
                       _menuTile(
                         context,
                         icon: Icons.account_balance,
                         title: 'Bank Details',
                         screen: const BankDetailsScreen(),
                       ),
                     ],
                   ),
                 ),
               ],
             ),
           ),
         ]
        
        
        ),
      ),
    );
  }

  Widget _menuTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Widget screen,
      }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
    );
  }

  Widget _divider() => Divider(height: 1, color: Colors.grey.shade300);
}