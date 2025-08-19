import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiMethods{
  String url1= 'https://reqres.in/api/users?page=1';
  String url2= 'https://reqres.in/api/users?page=2';

  Future<dynamic> getChats() async{
    final response= await http.get(Uri.parse(url1), headers: {'x-api-key': 'reqres-free-v1'});
    if(response.statusCode==200 || response.statusCode==201){
      return jsonDecode(response.body);
    }
    else{
      throw Exception('Failed to load');
    }
  }

}