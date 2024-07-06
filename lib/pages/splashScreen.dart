import 'package:colornestle/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async'; // Import for Timer
import 'database_check.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  String? _errorMessage;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startPeriodicChecks();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPeriodicChecks() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      bool checksPassed = await _performChecks();
      if (checksPassed) {
        timer.cancel();
        Navigator.of(context).pushReplacement(_createRoute());
      } else {
        setState(() {
          _errorMessage = 'Initialization failed. Please check your connection and try again.';
        });
      }
    });
  }

  Future<bool> _performChecks() async {
    if (!(await checkNetworkConnection(context))) {
      setState(() {
        _errorMessage = 'No network connection';
      });
      return false;
    }
    if (!(await checkDatabaseDriver(context))) {
      setState(() {
        _errorMessage = 'Database driver check failed';
      });
      return false;
    }
    if (!(await checkDatabaseConnection(context))) {
      setState(() {
        _errorMessage = 'Database connection check failed';
      });
      return false;
    }
    return true;
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var fadeAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(seconds: 2), // Slow down the fade transition
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: LottieBuilder.asset(
              "assets/Lottie/u14rjfxjVU.json",
              frameRate: FrameRate.max,
              fit: BoxFit.cover, // Ensure the animation covers the full screen
            ),
          ),
          if (_errorMessage != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
            ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 59, 42, 42),
    );
  }
}
