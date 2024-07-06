import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/appbar.dart';
import '../../widgets/sidebar_drawer.dart';
import '../check_page.dart';
import '../home_page.dart';
import 'generate_image.dart';
import 'room_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String name = "defaultName";
  String email = "defaultEmail@example.com";
  int imageid = 0;
  int currentIndex = 0;

  List<String> pageTitles = [
    '',
    '',
    '',
    ''
  ];

  List<Widget> pages = [
    const HomePage(),
    const RoomPage(),
    const GenerateImage(),
    Placeholder(), // Placeholder, will be replaced dynamically
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // If args is not null, update name, email, and currentIndex
    if (args != null) {
      setState(() {
        name = args['name'] ?? "defaultName";
        email = args['email'] ?? "defaultEmail@example.com";
        imageid = int.tryParse(args['imageid']?.toString() ?? '0') ?? 0;
        // currentIndex = args['initialIndex'] ?? 0;
      });
    }
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
      HapticFeedback.lightImpact();
    });

    // Check if navigating to CheckPage
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckPage(
            email: email,
            name: name,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: TransparentAppBarPage.getAppBar(pageTitles[currentIndex], _scaffoldKey),
      body: currentIndex != 3 ? pages[currentIndex] : Container(), // Display page or empty container for CheckPage
      drawer: SidebarDrawer(name: name, email: email),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(displayWidth * .05),
        height: displayWidth * .155,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: ListView.builder(
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
          itemBuilder: (context, index) => InkWell(
            onTap: () => onTap(index),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  width: index == currentIndex
                      ? displayWidth * .32
                      : displayWidth * .18,
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    height: index == currentIndex ? displayWidth * .12 : 0,
                    width: index == currentIndex ? displayWidth * .32 : 0,
                    decoration: BoxDecoration(
                      color: index == currentIndex
                          ? Colors.redAccent.withOpacity(.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  width: index == currentIndex
                      ? displayWidth * .31
                      : displayWidth * .18,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            width:
                                index == currentIndex ? displayWidth * .13 : 0,
                          ),
                          AnimatedOpacity(
                            opacity: index == currentIndex ? 1 : 0,
                            duration: Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            child: Text(
                              index == currentIndex
                                  ? '${listOfStrings[index]}'
                                  : '',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            width:
                                index == currentIndex ? displayWidth * .03 : 20,
                          ),
                          Icon(
                            listOfIcons[index],
                            size: displayWidth * .076,
                            color: index == currentIndex
                                ? Colors.redAccent
                                : Colors.black26,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.add_a_photo_rounded,
    Icons.color_lens_outlined,
    Icons.person_rounded,
  ];

  List<String> listOfStrings = [
    'Home',
    'Capture',
    'Color',
    'Account',
  ];
}
