import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'viewmodels/user_viewmodel.dart';
import 'viewmodels/bank_viewmodel.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserViewModel()),
        ChangeNotifierProvider(create: (context) => BankViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLOWapp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF00BCD4),
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          bodyLarge: GoogleFonts.montserrat(fontSize: 14, color: Colors.white),
          bodyMedium: GoogleFonts.montserrat(fontSize: 14, color: Colors.white),
          titleLarge: GoogleFonts.montserrat(fontSize: 16, color: Colors.white),
        ),
      ),
      home: const SplashScreen(), // Start with the splash screen
    );
  }
}