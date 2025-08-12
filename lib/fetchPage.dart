import 'dart:convert';

import 'package:apiintegration/apimethods.dart';
import 'package:flutter/material.dart';

class FetchPage extends StatefulWidget {
  const FetchPage({super.key});

  @override
  State<FetchPage> createState() => _FetchPageState();
}

class _FetchPageState extends State<FetchPage> {
  getPage() async {
    final response = await Apimethods().getPage2();
    print("Response:$response");
  }

  @override
  void initState() {
    // TODO: implement initState
    getPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
