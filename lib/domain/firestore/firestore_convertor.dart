///
/// Created by jozuko on 2023/03/06.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class FirestoreConvertor {
  static String? toNullableString(dynamic data, [String? defaultValue]) {
    if (data == null) {
      return defaultValue;
    }
    if (data is! String) {
      return defaultValue;
    }
    return data;
  }

  static String toNonNullString(dynamic data, [String defaultValue = '']) {
    if (data == null) {
      return defaultValue;
    }
    if (data is! String) {
      return defaultValue;
    }
    return data;
  }
}
