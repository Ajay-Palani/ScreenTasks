class ApiUrlManager{
  static const baseUrl= 'https://zq726gdt-3000.inc1.devtunnels.ms';
  String sendotp = '$baseUrl/api/user/otp/send';
  String verifyotp = '$baseUrl/api/user/otp/verify';
  String getbyuser = '$baseUrl/api/user/getByUser';
  String updateNewUser = '$baseUrl/api/user/update/';
  String getTiming = '$baseUrl/api/slots/get/slots/';
}