import 'dart:convert';

import 'package:http/http.dart' as http;

class Apimethods {
  String url = 'https://jsonplaceholder.typicode.com/albums/1/photos';

  String url1 = 'https://reqres.in/api/users?page=2';

  Future<dynamic> getData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> getPage2() async {
    final response = await http.get(Uri.parse(url1));

    if (response.statusCode == 200) {
      print("Response:${response.body}");
      return response.body;
    } else {
      throw Exception('Page 2 not loaded ${response.statusCode}');
    }
  }
}
