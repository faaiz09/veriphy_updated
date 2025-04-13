import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/providers/auth_provider.dart';
import 'package:rm_veriphy/providers/notifications_provider.dart';
import 'package:rm_veriphy/screens/main_chat_screen.dart';
import 'package:rm_veriphy/screens/profile_screen.dart';
// import 'package:rm_veriphy/screens/chat_screen.dart';
import 'package:rm_veriphy/screens/reports_screen.dart';
// import 'package:rm_veriphy/screens/daily_tasks_screen.dart';
import 'calender_screen.dart';
import 'package:rm_veriphy/widgets/home_content.dart';
import 'package:rm_veriphy/widgets/notification_badge.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const CalendarScreen(),
    const MainChatScreen(),
    const ReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<AuthProvider>().user;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getScreenTitle()),
        actions: [
          Consumer<NotificationsProvider>(
            builder: (context, provider, child) {
              return const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: NotificationBadge());
            },
          ),
          // Only one profile avatar here
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: theme.primaryColor.withOpacity(0.2),
                child: Text(
                  userProfile?.firstName.isNotEmpty == true
                      ? userProfile!.firstName[0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 65, // Specify a fixed height
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Daily Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
        ],
      ),
    );
  }

  String _getScreenTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Daily Tasks';
      case 2:
        return 'Chat';
      case 3:
        return 'Reports';
      default:
        return 'Veriphy';
    }
  }
}
