import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Apimethods {
  String url = 'https://jsonplaceholder.typicode.com/albums/1/photos';

  String url1 = 'https://reqres.in/api/users?page=2';

  Future<dynamic> getData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> getPage2() async {
    final response = await http.get(
      Uri.parse(url1),
      headers: {'x-api-key': 'reqres-free-v1'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Page 2 not loaded ${response.statusCode}');
    }
  }
}
