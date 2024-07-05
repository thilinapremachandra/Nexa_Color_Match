import 'package:colornestle/misc/colors.dart';
import 'package:colornestle/widgets/app_large_text.dart';
import 'package:colornestle/widgets/app_text.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  var images = {
    "image1.png":"image1",
    "image2.png":"image2",
    "image3.png":"image3",

  };
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 5, vsync: this);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.menu,
                    size: 30,
                    color: Colors.black54,
                  ),
                  Expanded(child: Container()),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.5)),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              const AppLargeText(text: "Discover"),
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
                    color: AppColors.mainColor, radius: 4),
                tabs: const [
                  Tab(text: "places"),
                  Tab(text: "inspiration"),
                  Tab(text: "Emotions"),
                  Tab(text: "inspiration"),
                  Tab(text: "Emotions"),
                ],
              ),
              const SizedBox(height: 20,),
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
                                image:  DecorationImage(
                                    image:
                                        AssetImage("assets/images/${images.keys.elementAtOrNull(index)}"),
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
                                    image:
                                        AssetImage("assets/images/${images.keys.elementAtOrNull(index)}"),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            
                          ],
                        );
                      },
                    ),
                    const Tab(text: "hi"),
                    const Tab(text: "hi"),
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
                                decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  image:DecorationImage(
                                      image: AssetImage("assets/images/${images.keys.elementAtOrNull(index)}"),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              AppText(text: "${images.values.elementAtOrNull(index)}",
                              color: AppColors.textColor2,),
                          ],
                        ),
                      );
                    }),
              ),
            ],
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
