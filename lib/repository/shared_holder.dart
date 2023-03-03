import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip/service/auth_service.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
enum Key {
  authProvider,
  userId,
  bookmarks,
}

class SharedHolder {
  late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  AuthProvider get authProvider => AuthProvider.values[_prefs.getInt(Key.authProvider.name) ?? 0];

  set authProvider(AuthProvider provider) => _prefs.setInt(Key.authProvider.name, provider.index);

  String? get userId => _prefs.getString(Key.userId.name);

  set userId(String? value) {
    if (value == null) {
      _prefs.remove(Key.userId.name);
    } else {
      _prefs.setString(Key.userId.name, value);
    }
  }

  String get bookmarks => _prefs.getString(Key.bookmarks.name) ?? '';

  set bookmarks(String json) => _prefs.setString(Key.bookmarks.name, json);
}
