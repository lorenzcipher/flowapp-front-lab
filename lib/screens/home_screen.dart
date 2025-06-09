import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'dashboard_screen.dart';
import 'transactions_screen.dart';
import 'profile_screen.dart';
import 'simulation_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    TransactionsScreen(),
    SimulationScreen(),
    DashboardScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F23), // Matching TransactionsScreen background
      body: _screens[_selectedIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.03),
            ],
          ),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Color(0xFF4AC7D8), // Teal accent color
          unselectedItemColor: Colors.white.withOpacity(0.6),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedIconTheme: IconThemeData(
            size: 28,
            color: Color(0xFF4AC7D8), // Teal accent color
          ),
          unselectedIconTheme: IconThemeData(
            size: 24,
            color: Colors.white.withOpacity(0.6),
          ),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _selectedIndex == 0
                      ? Color(0xFF4AC7D8).withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: Icon(Icons.account_balance_wallet_rounded),
              ),
              label: 'Transactions',
              tooltip: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _selectedIndex == 1
                      ? Color(0xFF4AC7D8).withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: Icon(Icons.analytics_rounded),
              ),
              label: 'Simulation',
              tooltip: 'Simulation',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _selectedIndex == 2
                      ? Color(0xFF4AC7D8).withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: Icon(Icons.dashboard_rounded),
              ),
              label: 'Dashboard',
              tooltip: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _selectedIndex == 3
                      ? Color(0xFF4AC7D8).withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: Icon(Icons.chat_bubble_rounded),
              ),
              label: 'Chat',
              tooltip: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _selectedIndex == 4
                      ? Color(0xFF4AC7D8).withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage("assets/user_profile.png"),
                  child: _selectedIndex == 4
                      ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFF4AC7D8),
                        width: 2,
                      ),
                    ),
                  )
                      : null,
                ),
              ),
              label: 'Profile',
              tooltip: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}