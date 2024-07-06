import 'package:flutter/material.dart';

import 'navpages/main_page.dart';


class ColorMatcher extends StatefulWidget {
  const ColorMatcher({super.key});

  @override
  State<ColorMatcher> createState() => ColorMatcherState();
}

class ColorMatcherState extends State<ColorMatcher> with SingleTickerProviderStateMixin {
  String name = "defaultName";
  String email = "defaultEmail@example.com";
  int imageid = 0;

  int _animationStage = 0;
  late AnimationController _colorAnimationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _colorAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(_colorAnimationController);
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    await Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _animationStage = 1);
      }
    });
    await Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _animationStage = 2);
      }
    });
    await Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _animationStage = 3);
      }
    });
    await Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _animationStage = 4);
      }
    });
    await Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _animationStage = 5);
      }
    });
    await Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _animationStage = 6);
      }
    });

    await Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
            settings: RouteSettings(
              arguments: {
                'name': name,
                'email': email,
                'imageid':imageid,
                'initialIndex': 2, // Index for the Color tab
              },
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      name = args['name'] ?? "defaultName";
      email = args['email'] ?? "defaultEmail@example.com";
      imageid = int.tryParse(args['imageid']?.toString() ?? '0') ?? 0;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _colorAnimation,
              builder: (context, child) {
                return Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: _colorAnimation.value ?? Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 255, 255, 255)),
                  ),
                );
              },
            ),
            SizedBox(height: 80),
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  textAlign: TextAlign.center,
                  _animationStage == 0
                      ? 'Collecting Data...'
                      : _animationStage == 1
                          ? 'Using Algorithms...'
                          : _animationStage == 2
                              ? 'Detecting texture...'
                              : _animationStage == 3
                                  ? 'Calculating Room Complexity...'
                                  : _animationStage == 4
                                      ? 'Color Matching...'
                                      : _animationStage == 5
                                          ? 'Color Match Successful...'
                                          : _animationStage == 6
                                              ? 'Redirecting to Visualize page...'
                                              : '',
                  key: ValueKey<int>(_animationStage),
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
