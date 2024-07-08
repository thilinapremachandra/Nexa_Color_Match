import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:panorama/panorama.dart';

class PanoramicImageViewer extends StatefulWidget {
  const PanoramicImageViewer({super.key});

  @override
  State<PanoramicImageViewer> createState() => _PanoramicImageViewerState();
}

class _PanoramicImageViewerState extends State<PanoramicImageViewer> {
  String name = "defaultName";
  String email = "defaultEmail@example.com";
  int imageid = 0;

  String imageUrl = "assets/images/panoramic_image.jpg";
  bool showAnimation = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    name = args?['name'] ?? "defaultName";
    email = args?['email'] ?? "defaultEmail@example.com";
    
    imageUrl = args?['image'] ?? "assets/images/panoramic_image2.jpg";
     imageid = int.tryParse(args?['imageid']?.toString() ?? '0') ?? 0;

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
            animSpeed: 2,
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