import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

Future<int?> getImageIdByEmail(String email) async {
  final response = await http.get(Uri.parse('${Config.baseUrl}/api/client/getImageId/$email'));

  if (response.statusCode == 200) {
    try {
      final responseData = json.decode(response.body);
      if (responseData is int) {
        return responseData;
      } else if (responseData is Map<String, dynamic> && responseData.containsKey('lastInteriorImageId')) {
        return responseData['lastInteriorImageId'];
      } else {
        throw Exception('Unexpected response format: $responseData');
      }
    } catch (e) {
      throw Exception('Failed to parse response: $e');
    }
  } else {
    throw Exception('Failed to load image ID');
  }
}
