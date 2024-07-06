import 'package:flutter/material.dart';

class TransparentAppBarPage {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static AppBar getAppBar(String title) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        icon: Icon(Icons.menu, size: 30,),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.favorite_border_rounded, size: 30,),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.share_outlined, size: 30,),
          onPressed: () {},
        ),
        SizedBox(width: 10),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}
