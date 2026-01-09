import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/custom_app_bar.dart';

class ContactUsScreen extends ConsumerStatefulWidget {
  const ContactUsScreen({super.key});

  @override
  ConsumerState<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends ConsumerState<ContactUsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fadeController;

  late List<Animation<double>> _detailsCardAnimations;
  late List<Animation<double>> _emailsCardAnimations;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _detailsCardAnimations = List.generate(
      3,
      (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _fadeController,
          curve: Interval(
            index * 0.15,
            index * 0.15 + 0.5,
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );

    _emailsCardAnimations = List.generate(
      3,
      (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _fadeController,
          curve: Interval(
            index * 0.15,
            index * 0.15 + 0.5,
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );

    _fadeController.forward();

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _fadeController.reset();
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // 👈 THIS IS IMPORTANT
    )) {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [Colors.grey[900]!, Colors.grey[800]!, Colors.grey[900]!]
                : [Colors.brown[50]!, Colors.grey[100]!, Colors.brown[50]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.14,
                child: const CustomAppBar(),
              ),


              /// TAB BAR
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.3)
                            : Colors.brown.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: theme.colorScheme.onPrimary,
                    unselectedLabelColor: theme.textTheme.bodyMedium!.color!
                        .withOpacity(0.7),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                    indicator: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [Colors.brown[700]!, Colors.brown[500]!]
                            : [Colors.brown[700]!, Colors.brown[500]!],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withOpacity(0.4)
                              : Colors.brown.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: const EdgeInsets.all(4),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'Details'),
                      Tab(text: 'Company Emails'),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _detailsTab(theme, isDark),
                    _emailsTab(theme, isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailsTab(ThemeData theme, bool isDark) {
    final textColor = theme.textTheme.bodyLarge!.color;
    final subTextColor = theme.textTheme.bodyMedium!.color!.withOpacity(0.7);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue[600],
            child: const Icon(Icons.phone_rounded, color: Colors.white),
          ),
          title: Text(
            'Customer Service',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '+97 1566923208',
            style: TextStyle(color: subTextColor),
          ),
          onTap: () async {
            final uri = Uri(scheme: 'tel', path: '+971566923208');
            if (await canLaunchUrl(uri)) await launchUrl(uri);
          },
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 0,
          ),
        ),
        const Divider(height: 24),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orange[600],
            child: const Icon(Icons.email_rounded, color: Colors.white),
          ),
          title: Text(
            'Email Support',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'amberjewellers2@gmail.com',
            style: TextStyle(color: subTextColor),
          ),
          onTap: () async {
            _openUrl('mailto:amberjewellers2@gmail.com');
          },
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 0,
          ),
        ),
        const Divider(height: 24),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.red[600],
            child: const Icon(Icons.location_on_rounded, color: Colors.white),
          ),
          title: Text(
            'Our Location',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Amber Zahrat Jewellers L.L.C\n'
                'MAJD ALKHATIB BUILDING\n'
                'Shop No: R-3\n'
                'Gold Souq - Al Khor St - Al Daghaya\n'
                'Deira, Dubai',
            style: TextStyle(
              color: subTextColor,
              height: 1.4,
            ),
          ),
          onTap: () {
            _openUrl('https://maps.app.goo.gl/AFQNHHhk5KUfa2Jb7?g_st=ipc');
          },
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 0,
          ),
        ),

      ],
    );
  }

  Widget _emailsTab(ThemeData theme, bool isDark) {
    final textColor = theme.textTheme.bodyLarge!.color;
    final subTextColor = theme.textTheme.bodyMedium!.color!.withOpacity(0.7);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'Company Emails',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: textColor,
            ),
          ),
        ),

        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orange[600],
            child: const Icon(Icons.support_agent_rounded, color: Colors.white),
          ),
          title: Text(
            'Support Team',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'amberjewellers2@gmail.com',
            style: TextStyle(color: subTextColor),
          ),
          onTap: () async {

            _openUrl('amberjewellers2@gmail.com');
          },
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 0,
          ),
        ),

      ],
    );
  }
}

/// _ScaleOnTapCard remains unchanged
class _ScaleOnTapCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _ScaleOnTapCard({required this.child, required this.onTap});

  @override
  State<_ScaleOnTapCard> createState() => _ScaleOnTapCardState();
}

class _ScaleOnTapCardState extends State<_ScaleOnTapCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}
