import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config.dart';

class CheckPage extends StatefulWidget {
  final String email;
  final String name;

  const CheckPage({required this.email, required this.name});

  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> with SingleTickerProviderStateMixin {
  bool isLoading = false;
  bool dataExists = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    _checkClientData();
  }

  Future<void> _checkClientData() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('${Config.baseUrl}/api/client/checkData/${widget.email}'));

    if (response.statusCode == 200) {
      setState(() {
        dataExists = json.decode(response.body);
        isLoading = false;
      });

      if (dataExists) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewPage()));
      }
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check Page"),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator(
                value: _animation.value,
              )
            : dataExists
                ? Text("Data found! Redirecting...")
                : Text("Data not found."),
      ),
    );
  }
}

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Page"),
      ),
      body: Center(
        child: Text("Welcome to the new page!"),
      ),
    );
  }
}
