import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/user_viewmodel.dart';
import 'webview_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Demo authentication method
  bool _isDemoLogin() {
    return _emailController.text.toLowerCase() == 'demo' &&
        _passwordController.text.toLowerCase() == 'demo';
  }

  void _handleLogin() {
    // Check for demo credentials first
    if (_isDemoLogin()) {
      // Navigate to WebViewScreen for demo login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WebViewScreen()),
      );
      return;
    }

    // Check if both fields are filled for regular login
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      // Access the UserViewModel to handle authentication
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      // Here you would add authentication logic with the viewmodel
      // For example: userViewModel.login(_emailController.text, _passwordController.text);

      // For now, navigate to WebViewScreen (you can add proper validation later)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WebViewScreen()),
      );
    } else {
      // Show error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter both email/username and password, or use "demo"/"demo" for demo access',
            style: GoogleFonts.montserrat(),
          ),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLogo(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.menu, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                _buildWelcomeText(),
                const SizedBox(height: 20),
                _buildDemoHint(), // Added demo hint
                const SizedBox(height: 20),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildRememberMeAndForgotPassword(),
                const SizedBox(height: 24),
                _buildSignInButton(),
                const SizedBox(height: 24),
                _buildDividerWithText(),
                const SizedBox(height: 24),
                _buildSocialLoginButtons(),
                const SizedBox(height: 40),
                _buildSignUpText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoHint() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF00BCD4).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF00BCD4).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: const Color(0xFF00BCD4),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Demo Access: Use "demo" for both username and password',
              style: GoogleFonts.montserrat(
                color: const Color(0xFF00BCD4),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/logo.png', // Replace with your actual asset path
      width: 80,         // Adjust size as needed
      height: 80,
      fit: BoxFit.contain,
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'Welcome to ',
          style: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'FLOW',
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00BCD4),
              ),
            ),
            Text(
              'app',
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Your mobile financial saver',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      style: GoogleFonts.montserrat(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'E-mail / Username',
        hintStyle: GoogleFonts.montserrat(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscureText,
      style: GoogleFonts.montserrat(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: GoogleFonts.montserrat(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }

  Widget _buildRememberMeAndForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                  // You could store this in your UserViewModel
                  if (_rememberMe) {
                    // Provider.of<UserViewModel>(context, listen: false).setRememberMe(true);
                  }
                },
                side: const BorderSide(color: Colors.grey),
                checkColor: Colors.white,
                activeColor: const Color(0xFF00BCD4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Remember me',
              style: GoogleFonts.montserrat(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            // Handle forgot password
            // You could navigate to a password reset screen here
          },
          child: Text(
            'Forgot Password?',
            style: GoogleFonts.montserrat(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleLogin, // Updated to use the new login handler
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00BCD4),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'SIGN IN',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDividerWithText() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey[800],
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR SIGN IN WITH',
            style: GoogleFonts.montserrat(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey[800],
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(Icons.qr_code_scanner),
        const SizedBox(width: 16),
        _buildSocialButton(Icons.email),
        const SizedBox(width: 16),
        _buildSocialButton(Icons.alternate_email),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: () {},
      ),
    );
  }

  Widget _buildSignUpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'DIDN\'T HAVE AN ACCOUNT? ',
          style: GoogleFonts.montserrat(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        GestureDetector(
          child: Text(
            'SIGN UP NOW',
            style: GoogleFonts.montserrat(
              color: const Color(0xFF00BCD4),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}