import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

// Import the custom popup
import 'package:colornestle/config.dart';
import 'package:lottie/lottie.dart';

import '../../widgets/button.dart';
import '../../widgets/custom_popup.dart';

class GenerateImage extends StatefulWidget {
  const GenerateImage({super.key});

  @override
  GenerateImageState createState() => GenerateImageState();
}

class GenerateImageState extends State<GenerateImage> {
  String name = "defaultName";
  String email = "defaultEmail@example.com";
  int imageid = 0;

  List<Color> _colors = [];
  bool _isSaved = false;
  bool _hasRated = false;
  int? _selectedColorIndex;
  double _rating = 0.0;

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

  Future<void> _save() async {
    print("Email before API call: $email"); // Debugging line

    if (_isSaved) {
      _showAlreadySavedMessage();
      return;
    }

    if (!_hasRated) {
      _showRatingDialog();
      return;
    }

    await _updateColorPallet();
    await _updateColorPalletColorCode();

    setState(() {
      _isSaved = true;
    });
  }

  Future<void> _updateColorPallet() async {
    final url =
        Uri.parse('${Config.baseUrl}/api/colorpallet/updateColorPallet');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      'imageColorPalletId': imageid.toString(),
      'email': email,
      'rating': _rating.toString(),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      print(
          "Response from updateColorPallet: ${response.body}"); // Debugging line
      if (response.statusCode != 200) {
        // Handle failure
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _updateColorPalletColorCode() async {
    final url =
        Uri.parse('${Config.baseUrl}/api/colorCode/updateColorPalletColorCode');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      'email': email,
      // 'colorPalletColorId': '1',
      'colorCode': _colors.map((color) => _colorToHex(color)).join(','),
      'selectedColor': _colorToHex(_colors[_selectedColorIndex!]),
      'colorGroup': 'yellow',
      'imageColorPalletId': imageid.toString(),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      print(
          "Response from updateColorPalletColorCode: ${response.body}"); // Debugging line
      if (response.statusCode != 200) {
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
        _hasRated = true;
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

  void _showColorDetailsBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoPopupSurface(
          child: Container(
            width: double.infinity,
            height: 400,
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: _colors[_selectedColorIndex!],
                      borderRadius: BorderRadius.circular(15)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Lottie.asset(
                      'assets/Lottie/Animation - 1720264601003 (1).json',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _colorToHex(_colors[_selectedColorIndex!]),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      child: CustomButton(
                        text: 'Save',
                        height: 40,
                        width: 150,
                        onTap: _save,
                      ),
                    ),
                    Material(
                      child: CustomButton(
                        text: 'Visualize',
                        height: 40,
                        width: 150,
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            '/panoramicview',
                            arguments: {
                              'name': name,
                              'email': email,
                              'imageid': imageid
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRegenerateConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopup(
          title: 'Confirm',
          content: 'Are you sure you want to regenerate colors?',
          buttonOneText: 'Yes',
          buttonTwoText: 'No',
          onButtonOnePressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/colormatcher', arguments: {
              'imageid': imageid,
              'name': name,
              'email': email,
            });
          },
          onButtonTwoPressed: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      name = args['name'] ?? "defaultName";
      email = args['email'] ?? "defaultEmail@example.com";
      imageid = int.tryParse(args['imageid']?.toString() ?? '0') ?? 0;
    }

    return Scaffold(
      body: GridView.builder(
        padding: EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: _colors.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColorIndex = index;
              });
              _showColorDetailsBottomSheet();
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
                            height: 150,
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
                              border:
                                  Border.all(width: 1, color: Colors.black45),
                              color: _selectedColorIndex == index
                                  ? Colors.green
                                  : Colors.white,
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
      bottomNavigationBar: BottomAppBar(
        height: 30,
        shape: CircularNotchedRectangle(),
        notchMargin: 5.0,
        color: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: FloatingActionButton(
          onPressed: _showRegenerateConfirmationDialog,
          tooltip: 'Regenerate Colors',
          child: Icon(Icons.restart_alt_sharp),
        ),
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
