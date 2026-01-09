import 'package:banglatiger2/features/more/bank_details_screen2.dart';
import 'package:banglatiger2/features/more/booking_desk_screen.dart';
import 'package:banglatiger2/features/more/chart_screen.dart';
import 'package:banglatiger2/features/more/economic_calendar_screen.dart';
import 'package:banglatiger2/features/more/historical_data_screen.dart';
import 'package:banglatiger2/features/more/live_rate_screen2.dart';
import 'package:banglatiger2/features/more/login_screen.dart';
import 'package:banglatiger2/features/more/rate_alert_screen2.dart';
import 'package:banglatiger2/features/news/news_screen.dart';
import 'package:banglatiger2/features/rate_alert/rate_alert_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../live_rates/live_rates_screen.dart';
import 'gold_trends_screen.dart';
import 'product_screen.dart';
import 'notification_screen.dart';
import 'about_us_screen.dart';
import 'bank_details_screen.dart';
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.14,
              child: const CustomAppBar(),
            ),


            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    /// Profile Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: const [
                            CircleAvatar(
                              radius: 24,
                              child: Icon(Icons.person, size: 26),
                            ),
                            SizedBox(width: 14),
                            Text(
                              'Hi, Guest',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Menu Container
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          _menuTile(context, Icons.show_chart, 'LIVE RATES'),
                          _divider(),
                          _menuTile(context, FontAwesomeIcons.productHunt, 'PRODUCTS'),
                          _divider(),
                          _menuTile(context, Icons.account_balance, 'BANK DETAILS'),
                          _divider(),
                          _menuTile(context, Icons.trending_up, 'GOLD TRENDS'),
                          _divider(),
                          _menuTile(context, Icons.notifications, 'MESSAGES'),
                          _divider(),
                          _menuTile(context, Icons.event_available, 'BOOKING DESK'),
                          _divider(),
                          _menuTile(context, Icons.newspaper, 'NEWS'),
                          _divider(),
                          _menuTile(context, Icons.calendar_today, 'ECONOMIC CALENDAR'),
                          _divider(),
                          _menuTile(context, Icons.info_outline, 'ABOUT US'),
                          _divider(),
                          _menuTile(context, Icons.notifications_active, 'RATE ALERT'),
                          _divider(),
                          _menuTile(context, Icons.history, 'HISTORICAL DATA'),
                          _divider(),
                          _menuTile(context, Icons.area_chart, 'CHART'),
                          _divider(),
                          _menuTile(context, Icons.login, 'LOGIN'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(BuildContext context, IconData icon, String title) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
      leading: Icon(icon, size: 20, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: () {
        switch (title) {
          case 'LIVE RATES':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveRatesScreen2()));
            break;
          case 'PRODUCTS':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductScreen()));
            break;
          case 'BANK DETAILS':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const BankDetailsScreen2()));
            break;
          case 'GOLD TRENDS':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const GoldTrendsScreen()));
            break;
          case 'MESSAGES':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
            break;
          case 'ABOUT US':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsScreen()));
            break;
          case 'NEWS':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const NewsScreen()));
            break;
          case 'BOOKING DESK':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const BookingDeskScreen()));
            break;
          case 'ECONOMIC CALENDAR':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const EconomicCalendarScreen()));
            break;
          case 'RATE ALERT':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const RateAlertScreen2()));
            break;
          case 'HISTORICAL DATA':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoricalDataScreen()));
            break;
          case 'CHART':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ChartScreen()));
            break;
          case 'LOGIN':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            break;
        }
      },

    );
  }

  Widget _divider() => Divider(height: 1, color: Colors.grey.shade300);
}
