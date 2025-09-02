import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiMethods {
  String baseurl = 'https://zq726gdt-3000.inc1.devtunnels.ms/';
  String sendotp = 'api/user/otp/send';
  String verifyotp = 'api/user/otp/verify';
  String getbyuser = 'api/user/getByUser';
  String updateNewUser = 'api/user/update/';
  String getTiming = 'api/slots/get/slots/';

  Future<dynamic> getTimeSlots(String token, String date) async {
    final url = Uri.parse('$baseurl$getTiming?date=$date');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Date Response: ${response.body}');
    return jsonDecode(response.body);
  }

  Future<dynamic> sendMobileNumber(int mobileNumber) async {
    final url = Uri.parse(baseurl + sendotp);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"mobileNumber": mobileNumber}),
    );
    print('Response:${response.body}');
    final Map<String, dynamic> data = jsonDecode(response.body);
    return response;
  }

  Future<dynamic> verifyOtp(int mobileNumber, int otp) async {
    var payload = {
      "mobileNumber": mobileNumber,
      "otp": otp,
    };
    final response = await http.post(
      Uri.parse(baseurl + verifyotp),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );
    print('Resp:${response.body}');
    return response.body;
  }

  Future<dynamic> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse(baseurl + getbyuser);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('GetData${response.body}');
    return jsonDecode(response.body);
  }

  Future<dynamic> updateNewUsers({required String firstName, required String lastName, required String dateOfBirth, required String email, required String country, required String city,}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userId = prefs.getString('id');

    if (token == null || userId == null) {
      throw Exception("Token or UserId missing");
    }

    final url = Uri.parse('$baseurl$updateNewUser$userId');

    final payload = {
      "firstName": firstName,
      "lastName": lastName,
      "dateOfBirth": dateOfBirth,
      "email": email,
      "country": country,
      "city": city,
    };

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(payload),
    );

    print("Update User Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update user: ${response.body}');
    }
  }
}
