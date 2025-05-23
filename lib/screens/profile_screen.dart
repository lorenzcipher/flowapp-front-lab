import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // User Profile Image
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/user_profile.png"),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Amina Yasmine MAHI",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "a.mahi@flowapp-eu.com",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Profile Options
            ProfileOption(icon: Icons.person, title: "Account Settings"),
            ProfileOption(icon: Icons.lock, title: "Privacy & Security"),
            ProfileOption(icon: Icons.notifications, title: "Notifications"),
            ProfileOption(icon: Icons.language, title: "Language"),
            ProfileOption(icon: Icons.help, title: "Help & Support"),

            Spacer(),

            // Logout Button
            ElevatedButton(
              onPressed: () {
                // Handle logout logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Log Out", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// Profile Option Widget
class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;

  ProfileOption({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          onTap: () {
            // Handle navigation
          },
        ),
        Divider(color: Colors.grey[800]),
      ],
    );
  }
}
