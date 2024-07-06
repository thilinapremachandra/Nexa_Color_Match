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
  var images = {
    "image1.png": "image1",
    "image2.png": "image2",
    "image3.png": "image3",
  };
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
  Widget build(BuildContext context) {
    // Check if arguments are not null
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // If args is null, provide default values
    final String name = args?['name'] ?? "null";
    final String email = args?['email'] ?? "charithabimsara@gmail.com";

    TabController tabController = TabController(length: 3, vsync: this);
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
                  height: 20,
                ),
                TabBar(
                  tabAlignment: TabAlignment.center,
                  labelPadding: const EdgeInsets.only(left: 0, right: 20),
                  controller: tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: const CircleTabIndicator(
                      color: Colors.red, radius: 4),
                  tabs: const [
                    Tab(text: "Home"),
                    Tab(text: "inspiration"),
                    Tab(text: "Tips"),
                   
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  //padding: const EdgeInsets.only(left: 20),
                  height: 300,
                  width: double.maxFinite,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      ListView.builder(
                        itemCount: 3,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 15, top: 10),
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
                      ListView.builder(
                        itemCount: 3,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 15, top: 10),
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
                      const Tab(text: "hi"),
                     
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
                      itemCount: 3,
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
              ],
            ),
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
