import 'package:flutter/material.dart';
import 'chat_screen.dart';  // Add the chat screen
import 'dashboard_screen.dart';
import 'transactions_screen.dart';
import 'profile_screen.dart';
import 'simulation_screen.dart'; // Import simulation screen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Define a list of screens
  final List<Widget> _screens = [
    TransactionsScreen(),
    SimulationScreen(), // Simulation screen
    DashboardScreen(), // Main dashboard
    ChatScreen(), // AI Bot chat screen
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
      backgroundColor: Color(0xFF1A1A1A),
      body: _screens[_selectedIndex], // Change screen dynamically

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false, // Hide text
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Simulation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage("assets/user_profile.png"),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
