import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:colornestle/utils/config.dart';
import 'package:lottie/lottie.dart';

import '../../widgets/button.dart';
import '../../widgets/custom_popup.dart';
import '../../utils/interior_image_api.dart';

class GenerateImage extends StatefulWidget {
  const GenerateImage({super.key});

  @override
  GenerateImageState createState() => GenerateImageState();
}

class GenerateImageState extends State<GenerateImage> {
  String name = "defaultName";
  String email = "defaultEmail@example.com";
  int? imageid;

  List<Color> _colors = [];
  bool _isSaved = false;
  bool _hasRated = false;
  int? _selectedColorIndex;
  double _rating = 0.0;
  

  // Predefined color categories with their RGB values
  final Map<String, List<int>> colorCategories = {
    'red': [255, 0, 0],
    'green': [0, 255, 0],
    'blue': [0, 0, 255],
    'yellow': [255, 255, 0],
    'pink': [255, 192, 203],
    'purple': [128, 0, 128],
    'magenta': [255, 0, 255],
    'grey': [128, 128, 128],
    'white': [255, 255, 255],
    'black': [0, 0, 0],
    'brown': [165, 42, 42],
    'orange': [255, 165, 0],
    'turquoise': [64, 224, 208],
    'teal': [0, 128, 128],
    'lavender': [230, 230, 250],
    'navy': [0, 0, 128],
    'beige': [245, 245, 220],
    'coral': [255, 127, 80],
    'mint': [62, 180, 137],
    'peach': [255, 229, 180],
    'gold': [255, 215, 0],
    'silver': [192, 192, 192],
  };

  @override
  void initState() {
    super.initState();
    _colors = getRandomColors();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Map<String, dynamic>? args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        name = args['name'] ?? "defaultName";
        email = args['email'] ?? "defaultEmail@example.com";
        //print('Arguments received: name=$name, email=$email');
        _fetchImageId();
      }
    });
  }

  Future<void> _fetchImageId() async {
    try {
      imageid = (await getImageIdByEmail(email));
      //print('Fetched image ID: $imageid');
      setState(() {});
    } catch (e) {
      //print('Failed to fetch image ID: $e');
    }
  }

  List<Color> getRandomColors() {
    return List.generate(
    4,
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

  // Function to convert hex code to RGB values
  Map<String, int> hexToRgb(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length != 6) throw ArgumentError('Invalid hex color');
    return {
      'r': int.parse(hex.substring(0, 2), radix: 16),
      'g': int.parse(hex.substring(2, 4), radix: 16),
      'b': int.parse(hex.substring(4, 6), radix: 16),
    };
  }

  // Function to calculate the Euclidean distance between two colors
  double calculateDistance(List<int> color1, Map<String, int> color2) {
    return sqrt(pow(color1[0] - color2['r']!, 2) +
        pow(color1[1] - color2['g']!, 2) +
        pow(color1[2] - color2['b']!, 2));
  }

  // Function to categorize the color
  String categorizeColor(Map<String, int> rgb) {
    double minDistance = double.infinity;
    String closestCategory = 'Unknown';

    colorCategories.forEach((category, color) {
      double distance = calculateDistance(color, rgb);
      if (distance < minDistance) {
        minDistance = distance;
        closestCategory = category;
      }
    });

    return closestCategory;
  }

  String _categorizeHexColor(String hexColor) {
  try {
    final rgb = hexToRgb(hexColor);
    return categorizeColor(rgb);
  } catch (e) {
    return 'Invalid color code';
  }
}

Future<void> _save() async {
  if (_isSaved) {
    _showAlreadySavedMessage();
    return;
  }

  if (!_hasRated) {
    _showRatingDialog();
    return;
  }

  if (imageid == null) {
    _showSaveFailMessage();
    return;
  }

  String selectedColorHex = _colorToHex(_colors[_selectedColorIndex!]);
  String colorGroup = _categorizeHexColor(selectedColorHex); // Correctly assign the color group

  await createColorPallet(
    email,
    imageid!,
    selectedColorHex,
    colorGroup,
    _rating.toString(),
    _colors.map((color) => _colorToHex(color)).toList(),
  );

  setState(() {
    _isSaved = true;
  });

  _showSuccessMessage();
}

  Future<void> createColorPallet(
    String email,
    int interiorImageId,
    String selectedColor,
    String colorGroup,
    String rating,
    List<String> colorCodes,
  ) async {
    final url = Uri.parse('${Config.baseUrl}/api/color_pallet_generate');

    // Construct query parameters
    final queryParameters = {
      'email': email,
      'interiorImageId': interiorImageId.toString(),
      'selectedColor': selectedColor,
      'colorGroup': colorGroup,
      'rating': rating,
    };

    // Append query parameters to URL
    final uri = url.replace(queryParameters: queryParameters);

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(colorCodes);

    try {
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        //print('Generation complete');
      } else {
        //print('Failed to generate color pallet: ${response.body}');
      }
    } catch (e) {
      //print('Error occurred while processing: $e');
    }
  }

  void _showAlreadySavedMessage() {
    Fluttertoast.showToast(
      msg: "This item is already saved.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showSuccessMessage() {
    Fluttertoast.showToast(
      msg: "Item saved successfully.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showSaveFailMessage() {
    Fluttertoast.showToast(
      msg: "Failed to save the item. Please try again.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red,),
                ),
                SizedBox(height: 40),
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
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/panoramicview');
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 0.85,
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
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
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
                              borderRadius: BorderRadius.circular(10),
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
                              borderRadius: BorderRadius.circular(10),
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
