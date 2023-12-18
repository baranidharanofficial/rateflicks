import 'package:shared_preferences/shared_preferences.dart';

Future<void> localStoreSetEmail(String email) async {
  final pref = await SharedPreferences.getInstance();
  pref.setString('email', email);
}

Future<String?> localStoreGetEmail() async {
  final pref = await SharedPreferences.getInstance();
  dynamic test = pref.getString('email');
  return test;
}

Future<void> localStoreSetUserId(String userId) async {
  final pref = await SharedPreferences.getInstance();
  pref.setString('userId', userId);
}

Future<String?> localStoreGetUserId() async {
  final pref = await SharedPreferences.getInstance();
  dynamic test = pref.getString('userId');
  return test;
}

Future<void> localStoreSetToken(String email) async {
  final pref = await SharedPreferences.getInstance();
  pref.setString('token', email);
}

Future<String?> localStoreGetToken() async {
  final pref = await SharedPreferences.getInstance();
  dynamic test = pref.getString('token');
  return test;
}
