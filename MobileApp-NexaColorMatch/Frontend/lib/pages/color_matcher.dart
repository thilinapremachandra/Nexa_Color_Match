import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/config.dart';
import 'navpages/main_page.dart';
import 'preference_form.dart';

class ColorMatcher extends StatefulWidget {
  const ColorMatcher({super.key});

  @override
  State<ColorMatcher> createState() => ColorMatcherState();
}

class ColorMatcherState extends State<ColorMatcher>
    with SingleTickerProviderStateMixin {
  String name = "defaultName";
  String email = "defaultEmail@example.com";
  int imageid = 0;

  int _animationStage = 0;
  bool isLoading = true;
  bool dataExists = false;

  late AnimationController _colorAnimationController;
  late Animation<Color?> _colorAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      if (mounted) {
        setState(() {
          name = args['name'] ?? "defaultName";
          email = args['email'] ?? "defaultEmail@example.com";
          imageid = int.tryParse(args['imageid']?.toString() ?? '0') ?? 0;
        });
      }
    }

    _checkClientData();
  }

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
  }

  Future<void> _checkClientData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    final response = await http
        .get(Uri.parse('${Config.baseUrl}/api/client/checkData/$email'));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (mounted) {
        setState(() {
          dataExists = responseData['dataExists'];
          imageid = responseData['lastInteriorImageId'] ?? 0;
          isLoading = false;
        });
      }

      if (!dataExists) {
        if (mounted) {
          setState(() => _animationStage = 2);
        }
        await Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserPreferenceForm(),
                settings: RouteSettings(
                  arguments: {
                    'name': name,
                    'email': email,
                    'imageid': imageid,
                  },
                ),
              ),
            );
          }
        });
      } else {
        _startAnimationSequence();
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _startAnimationSequence() async {
    if (!dataExists) {
      return;
    }

    await Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _animationStage = 1);
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
    await Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _animationStage = 7);
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
                'imageid': imageid,
                'initialIndex': 2,
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
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
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
                            : _animationStage == 2
                                ? 'No data found...'
                                : _animationStage == 3
                                    ? 'Using Algorithms...'
                                    : _animationStage == 4
                                        ? 'Detecting texture...'
                                        : _animationStage == 5
                                            ? 'Calculating Room Complexity...'
                                            : _animationStage == 6
                                                ? 'Color Matching...'
                                                : _animationStage == 7
                                                    ? 'Color Match Successful...'
                                                    : _animationStage == 8
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
