import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../contact_us/contact_us_screen.dart';
import '../live_rates/live_rates_screen.dart';
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
      const NewsScreen(),
      const LiveRatesScreen(),
      const RateAlertScreen(),
      const MoreScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar:
      _buildBottomNavBar(context, ref, selectedIndex),
    );
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
          icon: Icon(Icons.newspaper),
          label: 'News',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up),
          label: 'Live Rates',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Rate Alert',
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
