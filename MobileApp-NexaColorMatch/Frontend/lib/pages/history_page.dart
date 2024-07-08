import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/config.dart';
import '../widgets/sidebar_drawer.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String name = "defaultname";
  String email = "user@gmail.com";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    name = args?['name'] ?? name;
    email = args?['email'] ?? email;

    // Call fetchHistory after arguments are set
    _fetchHistory();
  }

  List<Map<String, dynamic>> _historyData = [];

  Future<void> _fetchHistory() async {
    final response = await http.get(
      Uri.parse('${Config.baseUrl}/api/v1/history/$email'),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        _historyData = jsonResponse.map((item) {
          return {
            'id': item['id'],
            'image': item['image'],
            'palette': (item['palette'][0] as String)
                .split(' ')
                .map((color) => color.trim())
                .toList(),
          };
        }).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No History')),
      );
    }
  }

  void _showBottomSheet(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        String selectedColor = item['palette'][0];
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 400,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Color(int.parse(
                              selectedColor.substring(1, 7),
                              radix: 16) +
                          0xFF000000),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                    
                      child: Image.network(
                        item['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    children: item['palette'].map<Widget>((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(
                                int.parse(color.substring(1, 7), radix: 16) +
                                    0xFF000000),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: color == selectedColor
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          width: 50,
                          height: 50,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _clearHistory() async {
    final response = await http.delete(
      Uri.parse('${Config.baseUrl}/api/v1/history/$email'),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      setState(() {
        _historyData.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('History cleared')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error clearing history')),
      );
    }
  }

  Future<void> _deleteHistoryItem(String id) async {
    final response = await http.delete(
      Uri.parse('${Config.baseUrl}/api/v1/history/$email/$id'),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      setState(() {
        _historyData.removeWhere((item) => item['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('History item deleted')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting history item')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SidebarDrawer(name: name, email: email),
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('History'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: _clearHistory,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: _historyData.isNotEmpty
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: _historyData.length,
                      itemBuilder: (context, index) {
                        final item = _historyData[index];
                        return GestureDetector(
                          onTap: () => _showBottomSheet(item),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Card(
                              elevation: 0,
                              color: Colors.white,
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Flexible(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.network(
                                            item['image'],
                                            fit: BoxFit.cover,
                                            width: 200,
                                            height: 150,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 40),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: item['palette']
                                            .map<Widget>((color) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Color(int.parse(
                                                      color.substring(1, 7),
                                                      radix: 16) +
                                                  0xFF000000),
                                            ),
                                            width: 30,
                                            height: 30,
                                          );
                                        }).toList(),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteHistoryItem(item['id']);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(child: Text('No history available')),
            ),
          ],
        ),
      ),
    );
  }
}
