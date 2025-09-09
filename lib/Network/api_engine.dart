import 'package:http/http.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ivf/Utils/app_alert_controller.dart';
import 'package:ivf/Utils/app_data_helper.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

enum APIRequestType { GET, POST, PUT, DELETE }
enum APIResponseStatus { SUCCESS, FAILED }

class APIResponse {
  APIResponseStatus status;
  Exception? exception;
  String message;
  dynamic data;

  APIResponse(this.status, this.data, {this.exception, this.message = ''});
}

class APIEngine {
  final _jsonEncoder = const JsonEncoder();
  bool _showIndicator = false;

  Future<Map<String, String>> _prepareHeaders(bool isWithToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print('Token:${token}');

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

    if (isWithToken) {
      {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<APIResponse> performRequest(APIRequestType requestType, String url,
      {dynamic payload, bool isPayloadNeed = false, bool isWithToken = false, bool showIndicator = true, String token = ''})async{
    assert(url.isNotEmpty, 'URL must not be empty or null');
    if(requestType == APIRequestType.POST || requestType == APIRequestType.PUT){
      if(isPayloadNeed){
        assert(payload != null, 'For post request you must send a payload');
      }
    }
    var headers= await _prepareHeaders(isWithToken);
    _showIndicator=showIndicator;
    if(_showIndicator){
      AppAlertController().showProgressIndicator();
    }
    if(requestType == APIRequestType.POST || requestType == APIRequestType.PUT){
      print('Payload:${payload}');
      print('Url${url}');
      if(payload !=null){}
    }
    try{
      var actualUrl= Uri.parse(url);
      print('Actual Url: ${actualUrl}');

      switch(requestType){
        case APIRequestType.GET:
          var response= await HTTP.get(actualUrl, headers: headers);
          print('Get:${response.body}');
          return handleResponse(response);
        case APIRequestType.PUT:
          var body;
          var response;
          if(payload != null){
            body=jsonEncode(payload);
            response= await HTTP.put(actualUrl, headers: headers, body: body);
            print('Resp:${response.body} Body: ${payload}');
          }
          else{
            response= await HTTP.put(actualUrl, headers: headers);
          }
          return handleResponse(response);
        case APIRequestType.POST:
          print('Post Mehod');
          var body;
          var response;
          if(payload != null){
            body= _jsonEncoder.convert(payload);
            response= await HTTP.post(actualUrl, headers: headers, body: body);
            print('Reponse: ${response.body}');
          }
          else{
            response= await HTTP.post(actualUrl, headers: headers);
          }
          return handleResponse(response);
        case APIRequestType.DELETE:
          var body;
          var response;
          if(payload != null){
            body=_jsonEncoder.convert(payload);
            response= await HTTP.delete(actualUrl, headers: headers, body: body);
          }
          else{
            response=await HTTP.delete(actualUrl, headers: headers);
          }
          return handleResponse(response);
      }
    }
    catch(exception){
      print('Exception:${exception}');
      BuildContext? ccc= AppDataHelper.rootContext;
      return commonExceptionResponse(exception as Exception);
    }
    // return payload;
  }

  APIResponse commonExceptionResponse(Exception exception) {
    var status = APIResponseStatus.FAILED;
    var apiResponse = APIResponse(status, null, exception: exception);
    return apiResponse;
  }

  APIResponse handleResponse(HTTP.Response response) {
    AppAlertController().hideProgressIndicator();

    if (response.statusCode != 200) {
      try {
        var body = jsonDecode(response.body);
      } catch (_) {}
    }

    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 204:
        var status = APIResponseStatus.SUCCESS;
        var data = jsonDecode(response.body);
        var apiResponse = APIResponse(status, data);
        return apiResponse;
      case 502:
      case 504:
        var status = APIResponseStatus.FAILED;
        var data = jsonDecode(response.body);
        var exception = Exception(data['status']['message']);
        var apiResponse = APIResponse(status, data, exception: exception);
        return apiResponse;

      case 500:
        var status = APIResponseStatus.FAILED;
        var data = jsonDecode(response.body);
        var exception = Exception("Please try again after few seconds");
        var apiResponse = APIResponse(status, data, exception: exception);
        return apiResponse;
      case 404:
        var status = APIResponseStatus.FAILED;
        var data = jsonDecode(response.body);
        var exception =
        Exception("The requested resource was not found on this server");
        var apiResponse = APIResponse(status, data, exception: exception);
        return apiResponse;

      default:
        var status = APIResponseStatus.FAILED;
        var data = jsonDecode(response.body);

        var exception = Exception(data['status']['message']);

        var apiResponse = APIResponse(status, data, exception: exception);
        return apiResponse;
    }
  }
}