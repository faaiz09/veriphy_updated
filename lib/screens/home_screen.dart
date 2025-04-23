// ignore_for_file: unused_local_variable, prefer_const_declarations

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/providers/auth_provider.dart';
import 'package:rm_veriphy/providers/notifications_provider.dart';
// import 'package:rm_veriphy/screens/dashboard_home_screen.dart';
import 'package:rm_veriphy/screens/main_chat_screen.dart';
import 'package:rm_veriphy/screens/profile_screen.dart';
import 'package:rm_veriphy/screens/reports_screen.dart';
import 'calender_screen.dart';
import 'package:rm_veriphy/widgets/home_content.dart';
import 'package:rm_veriphy/widgets/notification_badge.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Widget> _screens = [
    const HomeContent(),
    // const DashboardHomeScreen(),
    const CalendarScreen(),
    const MainChatScreen(),
    const ReportsScreen(),
  ];

  final List<IconData> _icons = [
    Icons.dashboard_rounded,
    Icons.calendar_month_rounded,
    Icons.chat_rounded,
    Icons.bar_chart_rounded,
  ];

  final List<IconData> _outlinedIcons = [
    Icons.dashboard_outlined,
    Icons.calendar_month_outlined,
    Icons.chat_outlined,
    Icons.bar_chart_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<AuthProvider>().user;
    final theme = Theme.of(context);
    final primaryColor = const Color(0xFFa7d222); // Green theme color
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/veriphy.png',
              height: 28,
            ),
            const SizedBox(width: 12),
            Text(
              _getScreenTitle(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        actions: [
          // Search button
          IconButton(
            icon: Icon(Icons.search, color: Colors.grey[700]),
            onPressed: () {
              // Search functionality
            },
          ),
          // Notification badge
          Consumer<NotificationsProvider>(
            builder: (context, provider, child) {
              return const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: NotificationBadge(),
              );
            },
          ),
          // Profile avatar
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ),
            child: Container(
              margin: const EdgeInsets.only(right: 16.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: primaryColor.withOpacity(0.1),
                child: Text(
                  userProfile?.firstName.isNotEmpty == true
                      ? userProfile!.firstName[0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: IndexedStack(
            index: _currentIndex,
            sizing: StackFit.expand,
            children: _screens,
          ),
        ),
      ),
      bottomNavigationBar: isTablet
          ? _buildTabletNavigation(primaryColor)
          : _buildMobileNavigation(primaryColor),
    );
  }

  Widget _buildMobileNavigation(Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: NavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        indicatorColor: primaryColor.withOpacity(0.1),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          _animationController.reset();
          _animationController.forward();
        },
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: List.generate(
          _screens.length,
          (index) => NavigationDestination(
            icon: Icon(
              _outlinedIcons[index],
              color: _currentIndex == index ? primaryColor : Colors.grey[600],
            ),
            selectedIcon: Icon(
              _icons[index],
              color: primaryColor,
            ),
            label: _getNavLabel(index),
          ),
        ),
      ),
    );
  }

  Widget _buildTabletNavigation(Color primaryColor) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          _screens.length,
          (index) => InkWell(
            onTap: () {
              setState(() => _currentIndex = index);
              _animationController.reset();
              _animationController.forward();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _currentIndex == index
                        ? _icons[index]
                        : _outlinedIcons[index],
                    color: _currentIndex == index
                        ? primaryColor
                        : Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getNavLabel(index),
                    style: TextStyle(
                      color: _currentIndex == index
                          ? primaryColor
                          : Colors.grey[600],
                      fontWeight: _currentIndex == index
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getNavLabel(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Tasks';
      case 2:
        return 'Chat';
      case 3:
        return 'Reports';
      default:
        return '';
    }
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
