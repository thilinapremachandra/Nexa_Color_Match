import 'dart:async';

import 'package:colornestle/misc/colors.dart';
import 'package:colornestle/widgets/app_large_text.dart';
import 'package:colornestle/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  final ScrollController _scrollController = ScrollController();
  late Timer _timer;
  double _scrollPosition = 0.0;
  
  var images = {
    "image1.jpg": "More Complex",
    "image2.jpg": "Low Texture",
    "image3.jpg": "Low Complex",
    "image4.jpg": "More Texture",
    "image5.jpg": "Dark Color",
    "image6.jpg": "Light Color",
    "image7.jpg": "White Color",
    "image8.jpg": "image8",
    "image9.jpg": "image9",
    "image10.jpg": "imag10",
    "image11.jpg": "image11",
    "image12.jpg": "image12",
    "image13.jpg": "image13",
    "image14.jpg": "image14",
    "image15.jpg": "image15",
    "image16.jpg": "image16",
  };

  final List<Color> containerColors = [
    const Color.fromARGB(255, 145, 129, 128),
    Color.fromARGB(255, 62, 127, 64),
    Color.fromARGB(255, 159, 199, 233),
    const Color.fromARGB(255, 143, 118, 82),
    const Color.fromARGB(255, 126, 89, 133),
    const Color.fromARGB(255, 227, 220, 153)
  ];

  late String name;
  late String email;
  late int clientid;

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

   @override
  void initState() {
    super.initState();

    // // Preload images
    // images.keys.forEach((image) {
    //   precacheImage(AssetImage("assets/images/$image"), context);
    // });

    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_scrollController.hasClients) {
        _scrollPosition += 2; // Adjust this value for scroll speed
        if (_scrollPosition >= _scrollController.position.maxScrollExtent) {
          _scrollPosition = 0.0;
        }
        _scrollController.animateTo(
          _scrollPosition,
          duration: Duration(milliseconds: 100),
          curve: Curves.linear,
        );
      }
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Preload images
    for (var image in images.keys) {
      precacheImage(AssetImage("assets/images/$image"), context);
    }
  }

@override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if arguments are not null
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // If args is null, provide default values
    final String name = args?['name'] ?? "null";

    TabController tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Text(
                        getGreeting(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontFamily: "Lato",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Welcome",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 19,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      " $name",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 19,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 50,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Discover your paint',
                        textStyle: TextStyle(
                          fontSize: 25.0,
                          fontFamily: "Lato",
                          fontWeight: FontWeight.w700,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                      TypewriterAnimatedText(
                        "Let's generate color",
                        textStyle: TextStyle(
                          fontSize: 25.0,
                          fontFamily: "Lato",
                          fontWeight: FontWeight.w700,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                      TypewriterAnimatedText(
                        'Color Nestle',
                        textStyle: TextStyle(
                          fontSize: 25.0,
                          fontFamily: "Lato",
                          fontWeight: FontWeight.w700,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    repeatForever: true,
                    pause: const Duration(seconds: 2),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                TabBar(
                  labelStyle: TextStyle(fontSize: 18.0),
                  unselectedLabelStyle: TextStyle(fontSize: 15.0),
                  
                  tabAlignment: TabAlignment.center,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 70),
                  controller: tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator:
                      const CircleTabIndicator(color: Colors.red, radius: 4),
                  tabs: const [
                    Tab(text: "Home"),
                    Tab(text: "Tips"),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  //padding: const EdgeInsets.only(left: 20),
                  height: 300,
                  width: double.maxFinite,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      //i want this view butlder auto move items from right to left
                      ListView.builder(
                         controller: _scrollController,
                       itemCount: images.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(right: 15, top: 10),
                                width: 200,
                                height: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/${images.keys.elementAtOrNull(index)}"),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 1, color: Colors.black),
                                color: Colors.red,
                              ),
                              width: double.infinity,
                              height: 200,
                              child: Row(
                                children: [
                                  Container(
                                    width: 220,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15)),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Center(
                                            child: Text(
                                              "Capture Living Room",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons
                                                    .control_point_rounded),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    "Get you Living room image",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons
                                                    .control_point_rounded),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    "Move Your Camera",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons
                                                    .control_point_rounded),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    "Capture a Panorama",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15),
                                            bottomRight: Radius.circular(15)),
                                        color: Colors.white,
                                      ),
                                      child: Image.asset(
                                        "assets/images/room.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 1, color: Colors.black),
                                color: Colors.red,
                              ),
                              width: double.infinity,
                              height: 200,
                              child: Row(
                                children: [
                                  Container(
                                    width: 220,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15)),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Center(
                                            child: Text(
                                              "Preference Form",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons
                                                    .control_point_rounded),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    "Fill the Preference Form",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons
                                                    .control_point_rounded),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    "Submit Preference Form",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons
                                                    .control_point_rounded),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    "Success",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15),
                                            bottomRight: Radius.circular(15)),
                                        color: Colors.white,
                                      ),
                                      child: Image.asset(
                                        "assets/images/boy.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 1, color: Colors.black),
                                color: Colors.red,
                              ),
                              width: double.infinity,
                              height: 200,
                              child: Row(
                                children: [
                                  Container(
                                    width: 220,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15)),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Center(
                                            child: Text(
                                              "Color Match",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons
                                                    .control_point_rounded),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    "Automatically color matching",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons
                                                    .control_point_rounded),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    "Generated colors in color tab",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons
                                                    .control_point_rounded),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    "You can regenerate",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15),
                                            bottomRight: Radius.circular(15)),
                                        color: Colors.white,
                                      ),
                                      child: Image.asset(
                                        "assets/images/colormatch.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppLargeText(
                      text: "Explore more",
                      size: 22,
                    ),
                    AppText(
                      text: "See all",
                      color: AppColors.textColor1,
                    )
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 120,
                  width: double.maxFinite,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (_, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 30),
                          child: Column(
                            children: [
                              Container(
                                // margin: const EdgeInsets.only(right: 20,),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/${images.keys.elementAtOrNull(index)}"),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              AppText(
                                text: "${images.values.elementAtOrNull(index)}",
                                color: AppColors.textColor2,
                              ),
                            ],
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppLargeText(
                      text: "Recent Colors",
                      size: 22,
                    ),
                    AppText(
                      text: "See all",
                      color: AppColors.textColor1,
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 400,
                  width: double.maxFinite,
                  child: GridView.builder(
                    
                    padding: EdgeInsets.all(5),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      mainAxisExtent: 150,
                      childAspectRatio: 0.75, // Adjust this ratio as needed
                    ),
                    itemCount: containerColors.length,
                    itemBuilder: (context, index) {
                      return buildContainer(index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContainer(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          width: double.infinity,
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: containerColors[index],
          ),
        ),
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final Color color;
  final double radius;
  const CircleTabIndicator({required this.color, required this.radius});
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final Color color;
  final double radius;
  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint paint = Paint();
    paint.color = color;
    paint.isAntiAlias = true;
    final Offset circleOffset = Offset(
        configuration.size!.width / 2 - radius / 2,
        configuration.size!.height - radius - 3);

    canvas.drawCircle(offset + circleOffset, radius, paint);
  }
}
