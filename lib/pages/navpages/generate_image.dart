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
  int? _selectedColorIndex;
  double _rating = 0.0;

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
  }

  List<Color> getRandomColors() {
    return List.generate(
      6,
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

  void _save() async {
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
      'rating': _rating,
      'selectedColor': _colorToHex(_colors[_selectedColorIndex!])
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
      setState(() {
        _rating = result;
      });
      _save();
    }
  }

  void _regenerateColors() {
    setState(() {
      _colors = getRandomColors();
      _selectedColorIndex = null;
      _isSaved = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 30.0,
        automaticallyImplyLeading: false,
        actions: [
          SizedBox(width: 25,),
          InkWell(
            splashColor: Colors.redAccent,
            borderRadius: BorderRadius.circular(50),
            onTap: _selectedColorIndex == null ? null : _showRatingDialog,
            child: Ink(
              decoration: BoxDecoration(
                color: _selectedColorIndex == null ? Colors.grey : Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(width: 2, color: Colors.black),
              ),
              child: Container(
                padding: EdgeInsets.all(1),
                height: 25,
                width: 100,
                child: const Center(
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          InkWell(
            splashColor: Colors.black45,
            borderRadius: BorderRadius.circular(50),
            onTap: _regenerateColors,
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(width: 2, color: Colors.black),
              ),
              child: Container(
                padding: EdgeInsets.all(1),
                height: 25,
                width: 100,
                child: const Center(
                  child: Text(
                    "Regenerate",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 25,),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75, // Adjust the aspect ratio as needed
        ),
        itemCount: _colors.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColorIndex = index;
              });
            },
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 150, // Adjust the height of the colored container
                            decoration: BoxDecoration(
                              color: _colors[index],
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              _colorToHex(_colors[index]),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: double.maxFinite,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 1, color: Colors.black45),
                              color: _selectedColorIndex == index ? Colors.green : Colors.white,
                            ),
                            child: Text(
                              'Select',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
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
