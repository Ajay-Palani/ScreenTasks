import 'dart:convert';

import 'package:http/http.dart';

enum APIRequestType {GET, POST, PUT, PATCH, DELETE}
enum APIResponseStatus {SUCCESS, FAILED}

class ApiResponse {
  APIResponseStatus status;
  Exception? exception;
  String message;
  dynamic data;

  ApiResponse(this.status, this.data, {this.exception, this.message = ''});
}

class ApiEngine{
  final jsonEncode=JsonEncoder();
  bool showindicator= false;


}