import 'package:banglatiger2/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/top_app_bar.dart';
import '../contact_us/contact_us_screen.dart';
import '../gold_trend/gold_analysis_card.dart';
import '../live_rates/gold_price_widget.dart';
import '../live_rates/live_rates_screen.dart';
import '../live_rates/web_socket_live_rates_screen.dart';
import '../more/bank_details_screen.dart';
import '../more/more_screen.dart';
import '../news/news_screen.dart';
import '../rate_alert/rate_alert_screen.dart';
import './provider/selected_index_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    final screens = [
      const ContactUsScreen(),
      // const NewsScreen(),
      BankDetailsScreen(),
      const LiveRatesScreen(),
      // WebSocketLiveRatesScreen(),
      // GoldPriceWidget(),
      // const RateAlertScreen(),
      GoldTrendScreen(),
      const MoreScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBottomNavBar(context, ref, selectedIndex),
          _buildCopyrightBar(context),
        ],
      ),

    );
  }

  Widget _buildCopyrightBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.onSurface.withOpacity(0.1),
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left side
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(
                  Icons.copyright,
                  size: 14,
                  color: colorScheme.primary,
                ),
                Text(
                  'Amber Zahrat Jewellers',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Center |
          Text(
            '|',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),

          // Right side
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Powered By: ',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                InkWell(
                  onTap: openJazzifyTech,
                  child: Text(
                    'JazzifyTech',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.amber : colorScheme.primary,
                      decoration: TextDecoration.underline, // optional
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );


  }
  Future<void> openJazzifyTech() async {
    final Uri url = Uri.parse('https://www.jazzifytech.com');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Widget _buildBottomNavBar(
      BuildContext context,
      WidgetRef ref,
      int selectedIndex,
      ) {
    final colorScheme = Theme.of(context).colorScheme;

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        ref.read(selectedIndexProvider.notifier).state = index;
      },
      type: BottomNavigationBarType.fixed,

      // ✅ Theme-aware colors
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),

      showUnselectedLabels: true,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.contact_mail),
          label: 'Contact Us',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_sharp),
          label: 'Bank Details',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Live Rates',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_off),
          label: 'Gold Trends',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          label: 'More',
        ),
      ],
    );
  }

}


final selectedIndexProvider =
NotifierProvider<SelectedIndexNotifier, int>(
  SelectedIndexNotifier.new,
);

class GoldTrendScreen extends StatelessWidget {
  const GoldTrendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.14,
              child: const CustomAppBar(),
            ),

            const SizedBox(height: 12),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: GoldAnalysisCard(),
            ),
          ],
        ),
      ),
    );
  }
}
