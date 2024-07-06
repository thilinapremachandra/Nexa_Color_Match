
import 'dart:io';
import 'package:colornestle/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../config.dart';
import '../widgets/sidebar_drawer.dart';



class FeedbackPage extends StatefulWidget {
  const FeedbackPage({
    super.key,
  });

  @override
  State<FeedbackPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FeedbackPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String name = "Defultuser";
  String email = "user@gmail.com";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    name = args?['name'] ?? "null";
    email = args?['email'] ?? "charithabimsara@gmail.com";
  }

  XFile? _imageFile;
  final picker = ImagePicker();
  final _textEditingController = TextEditingController();
  String answer1 = "Satisfied 😀";
  String answer2 = "Yes, I have already applied them.";
  String answer3 = "Very helpful.";
  String answer4 = "Good";
  String question1 =
      "How satisfied are you with the color suggestions provided by the app?";
  String question2 =
      "Do you really apply these to your walls or planning to do so?";
  String question3 =
      "How helpful did you find the app in choosing colors based on room texture?";
  String question4 = "How is the overall color suggestion of the app?";

  // String? get userEmail => null;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

//file check
  Future<void> _uploadImageAndData() async {
    var url = Uri.parse('${Config.baseUrl}/file/uploadFileComment');

    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', url);

      if (_imageFile != null) {
        // Add image file to multipart request
        var fileStream = http.ByteStream(File(_imageFile!.path).openRead());
        var length = await File(_imageFile!.path).length();
        var multipartFile = http.MultipartFile(
          'file',
          fileStream,
          length,
          filename: _imageFile!.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      // Add other fields as needed (e.g., user input)

      request.fields['question1'] = answer1;
      request.fields['question2'] = answer2;
      request.fields['question3'] = answer3;
      request.fields['question4'] = answer4;
      request.fields['userInput'] = _textEditingController.text;
      request.fields['email'] = email!;
      // Send multipart request
      var response = await request.send();

      // Handle response
      if (response.statusCode == 200) {
        print('Data uploaded successfully');
        Fluttertoast.showToast(
          msg: 'Thank you for your feedback.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Color.fromARGB(255, 4, 4, 4),
        );
        // Clear fields or show success message as needed
      } else {
        print('Failed to upload data');
        // Handle other status codes or errors
      }
    } catch (e) {
      print('Error uploading data: $e');
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
     appBar: TransparentAppBarPage.getAppBar('Feedback', _scaffoldKey),
     drawer: SidebarDrawer(name: name, email: email),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 216, 39, 39)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 60.00,
                child: Text(
                  question1,
                  style: TextStyle(
                      fontSize: 18.0, color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),

              SizedBox(
                width: 250.00,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    value: answer1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    items: ['Satisfied 😀', 'Neutral😐', 'Dissatisfied☹️']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        answer1 = newValue!;
                      });
                    },
                  ),
                ),
              ),
              Text(
                question2,
                style: TextStyle(
                    fontSize: 18.0, color: const Color.fromARGB(255, 0, 0, 0)),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                width: 300.00,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonFormField<String>(
                    value: answer2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    items: [
                      'Yes, I have already applied them.',
                      'Yes, I plan to apply them soon',
                      'Maybe, I\'m still deciding.',
                      'No, I do not intend to apply them.'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        answer2 = newValue!;
                      });
                    },
                  ),
                ),
              ),
              // SizedBox(height: 20),
              Text(
                question3,
                style: TextStyle(
                    fontSize: 18.0, color: const Color.fromARGB(255, 0, 0, 0)),
              ),

              SizedBox(
                width: 200.00,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonFormField<String>(
                    value: answer3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    items: [
                      'Very helpful.',
                      'Moderately helpful.',
                      'Slightly helpful.',
                      'Not helpful at all.'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        answer3 = newValue!;
                      });
                    },
                  ),
                ),
              ),
              // SizedBox(height: 20),
              Text(
                question4,
                style: TextStyle(
                    fontSize: 18.0, color: const Color.fromARGB(255, 0, 0, 0)),
              ),

              SizedBox(
                width: 200.00,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonFormField<String>(
                    value: answer4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    items: ['Good', 'Average', 'Poor'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        answer4 = newValue!;
                      });
                    },
                  ),
                ),
              ),

              //image
              Divider(
                height: 20, // The height of the divider
                color: Colors.grey, // The color of the divider
                thickness: 1, // The thickness of the divider line
                indent: 1, // The left padding (indent) of the divider
                endIndent: 10, // The right padding (endIndent) of the divider
              ),
              _imageFile == null
                  ? Text(
                      'No image selected.',
                      style:
                          TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                    )
                  : Image.file(
                      File(_imageFile!.path),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
              SizedBox(height: 20),
              TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText:
                      'We highly appreciate your suggestions. Feel free to write anything.',
                  hintStyle:
                      TextStyle(color: const Color.fromARGB(179, 0, 0, 0)),
                  filled: true,
                  fillColor: const Color.fromARGB(60, 24, 23, 23),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                maxLines: 3,
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: Icon(Icons.photo_library),
                    label: Text('Select Image'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _uploadImageAndData,
                    icon: Icon(Icons.upload_file),
                    label: Text('Submit Feedback'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
