import 'dart:convert';

import 'package:http/http.dart' as http;
enum ApiResponseStatus{Success, Failed}
class ApiResponse{
  ApiResponseStatus status;
  Exception? error;
  String message;
  dynamic data;

  ApiResponse(this.status, this.data, {this.error, this.message=''});

  ApiResponse handleRequest(http.Response response){
    if(response.statusCode !=200){
      try{
        var body= jsonDecode(response.body);
      }
      catch(_){

      }
    }
    switch (response.statusCode){
      case 200:
      case 201:
      case 202:
      case 204:
        var status = ApiResponseStatus.Success;
        var data = jsonDecode(response.body);
        var apiResponse = ApiResponse(status, data);
        return apiResponse;

      case 502:
      case 504:
        var status = ApiResponseStatus.Failed;
        var data = jsonDecode(response.body);
        var exception =
        Exception(
            data['status']['message'] );
        var apiResponse = ApiResponse(status, data, error: exception);
        return apiResponse;

      default:
        var status = ApiResponseStatus.Failed;
        var data = jsonDecode(response.body);
        var exception = Exception( data['status']['message']);

        var apiResponse = ApiResponse(status, data, error: exception);
        return apiResponse;

    }
  }
}