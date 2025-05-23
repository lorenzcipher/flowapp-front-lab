import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _imagesPreloaded = false;

  @override
  void initState() {
    super.initState();
    // Set status bar to match the screen background
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Preload images only once after context is available
    if (!_imagesPreloaded) {
      _imagesPreloaded = true;

      for (var page in _pages) {
        precacheImage(AssetImage(page.imagePath), context);
      }
    }
  }
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<SplashData> _pages = [
    SplashData(
      title: 'FLOW app',
      description: 'Your mobile financial saver',
      backgroundColor: Colors.black,
      logoColor: Color(0xFF00BCD4),
      textColor: Colors.white,
      imagePath: 'assets/finance_app.png',
    ),
    SplashData(
      title: 'Simple budgeting and planning',
      description: 'Track your expenses and save money with our intuitive tools',
      backgroundColor: Color(0xFFD6EAF8),
      logoColor: Color(0xFF00BCD4),
      textColor: Colors.black,
      imagePath: 'assets/budget_planning.png',
    ),
    SplashData(
      title: 'Become a financial expert',
      description: 'Learn how to manage your money efficiently',
      backgroundColor: Color(0xFFE8DAEF),
      logoColor: Colors.purple,
      textColor: Colors.black,
      imagePath: 'assets/financial_expert.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return SplashPage(data: _pages[index]);
            },
          ),
          // Page indicator
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                    (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: index == _currentPage ? 25 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: index == _currentPage
                        ? _pages[_currentPage].textColor
                        : _pages[_currentPage].textColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          // Next button
          Positioned(
            bottom: 30,
            right: 0,
            left: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage < _pages.length - 1) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    // Navigate to LoginScreen when done
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _pages[_currentPage].textColor,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(15),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: _pages[_currentPage].backgroundColor,
                ),
              ),
            ),
          ),
          // Skip button (only shown on pages other than the last)
          if (_currentPage < _pages.length - 1)
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: Text(
                  'Skip',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: _pages[_currentPage].textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SplashPage extends StatelessWidget {
  final SplashData data;

  const SplashPage({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: data.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildImage(),
          const SizedBox(height: 50),
          _buildTitle(data.title, data.textColor),
          SizedBox(height: 20),
          _buildDescription(data.description, data.textColor),
        ],
      ),
    );
  }

  Widget buildImage() {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: ClipOval(
          child: Image.asset(
            data.imagePath,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback in case image is not found
              return Icon(
                Icons.image_not_supported,
                size: 80,
                color: data.logoColor,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title, Color textColor) {
    if (title == 'FLOW app') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'FLOW',
            style: GoogleFonts.montserrat(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00BCD4),
            ),
          ),
          Text(
            'app',
            style: GoogleFonts.montserrat(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ],
      );
    } else {
      return Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _buildDescription(String description, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        description,
        style: GoogleFonts.montserrat(
          fontSize: 16,
          color: textColor.withOpacity(0.8),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class SplashData {
  final String title;
  final String description;
  final Color backgroundColor;
  final Color logoColor;
  final Color textColor;
  final String imagePath; // Added image path

  SplashData({
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.logoColor,
    required this.textColor,
    required this.imagePath,
  });
}