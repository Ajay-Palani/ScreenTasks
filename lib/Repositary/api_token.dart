import 'package:shared_preferences/shared_preferences.dart';

setToken(String token)async{
  final prefs= await SharedPreferences.getInstance();
  prefs.setString('token', token);
}
setId(String id)async{
  final prefs= await SharedPreferences.getInstance();
  prefs.setString('id', id);
}
setName(String name)async{
  final prefs= await SharedPreferences.getInstance();
  prefs.setString('name', name);
}