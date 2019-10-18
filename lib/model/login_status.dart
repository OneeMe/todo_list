import 'package:shared_preferences/shared_preferences.dart';

const String PREFRENCE_KEY = 'todo_app_login_flag';

class LoginStatus {
  LoginStatus._();

  static LoginStatus _instance;
  SharedPreferences _sharedPreferences;

  factory LoginStatus.instance() {
    if (_instance == null) {
      _instance = LoginStatus._();
    }
    return _instance;
  }

  Future<void> clearStatus() async {
    await _initSharedPreferences();
    await _sharedPreferences.remove(PREFRENCE_KEY);
  }

  Future<bool> isLoginBefore() async {
    await _initSharedPreferences();
    return _sharedPreferences.containsKey(PREFRENCE_KEY);
  }

  Future<void> saveLoginStatus() async {
    await _initSharedPreferences();
    await _sharedPreferences.setBool(PREFRENCE_KEY, true);
  }

  Future<void> _initSharedPreferences() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }
}