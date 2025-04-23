import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/providers/auth_provider.dart';
import 'package:rm_veriphy/screens/loading_screen.dart';
import 'package:rm_veriphy/screens/login_screen.dart';
import 'package:rm_veriphy/utils/token_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Logo animations
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOutBack),
      ),
    );

    // Text animation
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.8, curve: Curves.easeIn),
      ),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _checkAuthAndNavigate();
        }
      });
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Check if remember me is enabled and token exists
    final rememberMe = await TokenManager.isRememberMeEnabled();
    final hasToken = await TokenManager.hasToken();
    
    if (rememberMe && hasToken) {
      // Attempt to authenticate with stored token
      await authProvider.checkAuthStatus();
      
      if (authProvider.isAuthenticated && mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                FadeTransition(
              opacity: animation,
              child: const LoadingScreen(),
            ),
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
        return;
      }
    }
    
    // If not authenticated or no token, go to login screen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              FadeTransition(
            opacity: animation,
            child: const LoginScreen(),
          ),
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background container with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  const Color(0xFFa7d222).withOpacity(0.1),
                  Colors.white,
                  Colors.white,
                  const Color(0xFFa7d222).withOpacity(0.1),
                ],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _logoOpacityAnimation.value,
                        child: Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: Image.asset(
                            'assets/images/veriphy.png',
                            width: 250,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                  // Loading animation
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Lottie.asset(
                      'assets/animations/loading.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Welcome text
                  FadeTransition(
                    opacity: _textOpacityAnimation,
                    child: const Column(
                      children: [
                        Text(
                          'Welcome to Veriphy',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(167, 210, 34, 1),
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Your Document Verification Partner',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
