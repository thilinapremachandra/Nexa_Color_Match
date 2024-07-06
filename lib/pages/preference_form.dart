import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import 'package:colornestle/config.dart';

// Create a logger instance
final logger = Logger();

class UserPreferenceForm extends StatefulWidget {
  // const UserPreferenceForm({super.key});

  const UserPreferenceForm({super.key});

  @override
  UserPreferenceFormState createState() => UserPreferenceFormState();
}

class UserPreferenceFormState extends State<UserPreferenceForm> {
  String name = "defaultName";
  String email = "defaultEmail@example.com";
  int imageid = 0;

  String _budget = 'Low Budget';
  final List<Color> _favoriteColors = [];
  String _climate = 'Wet';
  String _numberOfMembers = '1-2';
  String _lifestyle = 'Homies';
  String _architecturalStyle = 'Modern';
  bool _photosensitivity = false;
  bool _naturalLightChecked = false;
  bool _richColorChecked = false;
  String _colorToneTheme = 'Neutral';
  String _preferredAmbiance = 'Cozy and Warm';
  String _gender = 'Male';
  String _ageGroup = '20-40';

  // Define the list of allowed colors
  final List<Color> allowedColors = [
    const Color.fromARGB(255, 255, 0, 0), // Red
    const Color.fromARGB(255, 0, 255, 0), // Green
    const Color.fromARGB(255, 0, 0, 255), // Blue
    const Color.fromARGB(255, 255, 255, 0), // Yellow
    const Color.fromARGB(255, 255, 192, 203), // Pink
    const Color.fromARGB(255, 128, 0, 128), // Purple
    const Color.fromARGB(255, 255, 0, 255), // Magenta
    const Color.fromARGB(255, 128, 128, 128), // Grey
    const Color.fromARGB(255, 255, 255, 255), // White
    const Color.fromARGB(255, 0, 0, 0), // Black
    const Color.fromARGB(255, 165, 42, 42), // Brown
    const Color.fromARGB(255, 255, 165, 0), // Orange
    const Color.fromARGB(255, 64, 224, 208), // Turquoise
    const Color.fromARGB(255, 0, 128, 128), // Teal
    const Color.fromARGB(255, 230, 230, 250), // Lavender
    const Color.fromARGB(255, 0, 0, 128), // Navy
    const Color.fromARGB(255, 245, 245, 220), // Beige
    const Color.fromARGB(255, 255, 127, 80), // Coral
  ];

  void resetSelections() {
    setState(() {
      _budget = 'Low Budget';
      _climate = 'Wet';
      _lifestyle = 'Homies';
      _architecturalStyle = 'Modern';
      _photosensitivity = false;
      _naturalLightChecked = false;
      _richColorChecked = false;
      _favoriteColors.clear();
      _colorToneTheme = 'Neutral';
      _preferredAmbiance = 'Cozy and Warm';
      _gender = 'Male';
      _ageGroup = '20-40';
    });
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.greenAccent),
                    child: const Icon(
                      Icons.account_circle_outlined,
                      size: 50,
                    ),
                  ),
                ),
                Center(
                  child: const SizedBox(
                    height: 100,
                    child: Text(
                      "Who are you ?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 77, 75, 75),
                        fontFamily: "inter",
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // Shadow color
                        blurRadius: 10, // Softness of the shadow
                        spreadRadius: 2, // Spread radius
                        offset: const Offset(0, 4), // Shadow position
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed('/colormatcher', arguments: {
                                'imageid': imageid,
                                'name': name,
                                'email': email,
                              });
                            },
                            child: Container(
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green,
                              ),
                              child: const Center(
                                child: Text(
                                  'Skip',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      buildOptionSelector(
                        title: 'Budget',
                        options: ['  Low  ', '  Moderate  ', '  High  '],
                        currentValue: _budget,
                        onChanged: (value) {
                          setState(() {
                            _budget = value!;
                          });
                        },
                      ),
                      buildFavoriteColorSelector(context),
                      buildRadioSelector(
                        title: 'Number of Members',
                        currentValue: _numberOfMembers,
                        options: [
                          '1-2 members',
                          '2-6 members',
                          'Above 6 members'
                        ],
                        onChanged: (value) {
                          setState(() {
                            _numberOfMembers = value!;
                          });
                        },
                      ),
                      buildOptionSelector(
                        title: 'Climate',
                        options: ['Wet', 'Intermediate', 'Dry'],
                        currentValue: _climate,
                        onChanged: (value) {
                          setState(() {
                            _climate = value!;
                          });
                        },
                      ),
                      buildOptionSelector(
                        title: 'Lifestyle',
                        options: ['Homies', 'Job-runners', 'Party-lovers'],
                        currentValue: _lifestyle,
                        onChanged: (value) {
                          setState(() {
                            _lifestyle = value!;
                          });
                        },
                      ),
                      buildDropDownSelector(
                        title: 'Architectural Style',
                        currentValue: _architecturalStyle,
                        options: ['Modern', 'Traditional', 'Minimalist'],
                        onChanged: (value) {
                          setState(() {
                            _architecturalStyle = value!;
                          });
                        },
                      ),
                      buildOptionSelector(
                        title: 'Color Tone/Theme',
                        options: [
                          'Neutral',
                          'Cool Tones',
                          'Warm Tones',
                          'Mixed/Balanced',
                          'No Specific Color Scheme'
                        ],
                        currentValue: _colorToneTheme,
                        onChanged: (value) {
                          setState(() {
                            _colorToneTheme = value!;
                          });
                        },
                      ),
                      buildOptionSelector(
                        title: 'Preferred Ambiance',
                        options: [
                          'Cozy and Warm',
                          'Bright and Airy',
                          'Elegant and Sophisticated',
                          'Modern and Minimalist',
                          'Vibrant and Energetic'
                        ],
                        currentValue: _preferredAmbiance,
                        onChanged: (value) {
                          setState(() {
                            _preferredAmbiance = value!;
                          });
                        },
                      ),
                      buildDropDownSelector(
                        title: 'Gender',
                        currentValue: _gender,
                        options: ['Male', 'Female', 'Prefer not to say'],
                        onChanged: (value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                      ),
                      buildDropDownSelector(
                        title: 'Age Group',
                        currentValue: _ageGroup,
                        options: ['Below 20', '20-40', '40-50', 'Above 50'],
                        onChanged: (value) {
                          setState(() {
                            _ageGroup = value!;
                          });
                        },
                      ),
                      buildCheckBox(
                        title: 'Light Condition',
                        values: {
                          'Natural Light': _naturalLightChecked,
                          'Rich Color': _richColorChecked,
                        },
                        onChanged: (value) {
                          setState(() {
                            _naturalLightChecked = value['Natural Light']!;
                            _richColorChecked = value['Rich Color']!;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Photosensitivity:',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Switch(
                            value: _photosensitivity,
                            onChanged: (value) {
                              setState(() {
                                _photosensitivity = value;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle reset
                              resetSelections();
                            },
                            child: Container(
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey,
                              ),
                              child: const Center(
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    // Handle form submission
                    sendFormData();
                  },
                  child: Center(
                    child: Container(
                      height: 60,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.greenAccent,
                      ),
                      child: const Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOptionSelector({
    required String title,
    required List<String> options,
    required String currentValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: options.map((option) {
            return ChoiceChip(
              label: Text(option),
              selected: currentValue == option,
              onSelected: (selected) {
                onChanged(selected ? option : null);
              },
              selectedColor: Colors.greenAccent,
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: currentValue == option ? Colors.white : Colors.black,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 50.0),
      ],
    );
  }

  Widget buildFavoriteColorSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Favorite Colors',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: allowedColors.map((color) {
            final bool isSelected = _favoriteColors.contains(color);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _favoriteColors.remove(color);
                  } else {
                    if (_favoriteColors.length < 10) {
                      _favoriteColors.add(color);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You can select up to 10 colors only.'),
                        ),
                      );
                    }
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: isSelected
                      ? Border.all(color: Colors.black, width: 2.0)
                      : null,
                ),
                width: 25.0,
                height: 25.0,
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Color.fromARGB(255, 0, 0, 0),
                        size: 20,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 50.0),
      ],
    );
  }

  Widget buildRadioSelector({
    required String title,
    required String currentValue,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        Column(
          children: options.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: currentValue,
              onChanged: onChanged,
            );
          }).toList(),
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }

  Widget buildDropDownSelector({
    required String title,
    required String currentValue,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        DropdownButtonFormField<String>(
          value: currentValue,
          onChanged: onChanged,
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(height: 50.0),
      ],
    );
  }

  Widget buildCheckBox({
    required String title,
    required Map<String, bool> values,
    required ValueChanged<Map<String, bool>> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Column(
          children: values.keys.map((key) {
            return CheckboxListTile(
              title: Text(key),
              value: values[key],
              onChanged: (bool? value) {
                onChanged({...values, key: value!});
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }

  // Function to convert Color to Hexadecimal string
  // String colorToHex(Color color) {
  //   return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  // }

  String colorToHex(Color color) {
    String hex = color.value
        .toRadixString(16)
        .toUpperCase()
        .padLeft(8, '0'); // Ensure the hex string has 8 characters
    return '#${hex.substring(2)}'; // Take the last 6 characters, which represent the RGB values
  }

  Future<void> sendFormData() async {
    final apiUrl =
        '${Config.baseUrl}/api/client-preferences'; // Replace with your API endpoint

    // Create a map of the form data
    final Map<String, dynamic> formData = {
      'email': email,
      'budget': _budget,
      'favoriteColors': _favoriteColors.map(colorToHex).join(' '),
      'climate': _climate,
      'numberOfMembers': _numberOfMembers,
      'lifestyle': _lifestyle,
      'architecturalStyle': _architecturalStyle,
      'photosensitivity': _photosensitivity,
      'naturalLightChecked': _naturalLightChecked,
      'richColorChecked': _richColorChecked,
      'colorToneTheme': _colorToneTheme,
      'preferredAmbiance': _preferredAmbiance,
      'ageGroup': _ageGroup,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(formData),
      );

      if (!mounted) return; // Check if the widget is still mounted

      if (response.statusCode == 200) {
        showSuccessDialog(context);
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to submit the form: ${response.statusCode}')),
        );
      }
    } catch (error) {
      // Handle error
      logger.e('Error submitting form: $error');

      if (!mounted) return; // Check if the widget is still mounted

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting the form: $error')),
      );
    }
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Form data sent successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pushNamed('/colormatcher', arguments: {
                  'imageid': imageid,
                  'name': name,
                  'email': email,
                }); // Navigate to colormatcher page
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
