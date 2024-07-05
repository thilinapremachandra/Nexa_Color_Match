import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

import 'package:colornestle/config.dart';

class GenerateImage extends StatefulWidget {
  const GenerateImage({super.key});

  @override
  GenerateImageState createState() => GenerateImageState();
}

class GenerateImageState extends State<GenerateImage> {
  String? name;
  String? email;
  int? imageid;
  int? clientid;
  List<Color> _colors = [];
  bool _isSaved = false;
  List<bool> _isFavorite = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    name = args?['name'] ?? "null";
    email = args?['email'] ?? "charithabimsara@gmail.com";
    clientid = args?['clientid'] ?? 0;
    imageid = args?['imageid'] ?? 0;
  }

  @override
  void initState() {
    super.initState();
    _colors = getRandomColors();
    _isFavorite = List.generate(_colors.length, (index) => false);
  }

  List<Color> getRandomColors() {
    return List.generate(
      5,
      (index) => Color.fromARGB(
        255,
        Random().nextInt(256),
        Random().nextInt(256),
        Random().nextInt(256),
      ),
    );
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(6, '0').substring(2).toUpperCase()}';
  }

  void _save(double rating) async {
    if (_isSaved) {
      _showAlreadySavedMessage();
      return;
    }

    final url =
        Uri.parse('${Config.baseUrl}/api/v1/colorpallet/saveColorpallet');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      'imageid': imageid,
      'colorcode': _colors
          .map((color) =>
              '#${color.value.toRadixString(16).padLeft(6, '0').substring(2)}')
          .join(' '),
      'rating': rating
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        setState(() {
          _isSaved = true;
        });
        // Handle success
      } else {
        // Handle failure
      }
    } catch (e) {
      // Handle error
    }
  }

  void _showAlreadySavedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('This palette has already been saved.'),
      ),
    );
  }

  Future<void> _showRatingDialog() async {
    final result = await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return RatingDialog();
      },
    );
    if (result != null) {
      _save(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context)
                .popUntil((route) => route.settings.name == '/dashboard');
          },
        ),
        title: Text("Generate colors"),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _colors.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              setState(() {
              });
              await Navigator.pushNamed(
                context,
                '/details',
                arguments: {
                  'name': name,
                  'email': email,
                  'imageid': imageid,
                  'color': _colors[index],
                  'colorHex': _colorToHex(_colors[index]),
                },
              );
              _showRatingDialog();
            },
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      
                      height: 350,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)
                        
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        
                        children: [
                          Container(
                            height: 230,
                            decoration: BoxDecoration(
                              color: _colors[index],
                              borderRadius: BorderRadius.circular(15),
                             
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              _colorToHex(_colors[index]),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: double.maxFinite,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 1),
                              color: Colors.white
                            ),
                            child: Text(
                              'View AR',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                bottom: 90,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFavorite[index] = !_isFavorite[index];
                      });
                    },
                    child: Icon(
                      _isFavorite[index]
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: _isFavorite[index] ? Colors.red : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

  @override
  RatingDialogState createState() => RatingDialogState();
}

class RatingDialogState extends State<RatingDialog> {
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rate this'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Submit'),
          onPressed: () {
            Navigator.of(context).pop(_rating);
          },
        ),
        TextButton(
          child: Text('Skip'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
