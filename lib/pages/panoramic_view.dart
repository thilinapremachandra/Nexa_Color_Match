import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:panorama/panorama.dart';

class PanoramicImageViewer extends StatefulWidget {
  const PanoramicImageViewer({super.key});

  @override
  State<PanoramicImageViewer> createState() => _PanoramicImageViewerState();
}

class _PanoramicImageViewerState extends State<PanoramicImageViewer> {
  String? name;
  String? email;
  String imageUrl = "assets/images/panoramic_image.jpg";
  bool showAnimation = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    name = args?['name'] ?? "null";
    email = args?['email'] ?? "example@example.com";
    imageUrl = args?['image'] ?? "assets/images/panoramic_image2.jpg";

    // Optional: Add a delay before hiding the animation
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        showAnimation = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Panorama(
            child: Image.asset(imageUrl),
          ),
          if (showAnimation)
            Positioned.fill(
              child: Lottie.asset('assets/Lottie/Animation - 1720265954880.json'),
            ),
        ],
      ),
    );
  }
}
