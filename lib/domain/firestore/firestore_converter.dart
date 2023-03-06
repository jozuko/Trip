///
/// Created by jozuko on 2023/03/06.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class FirestoreConverter {
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

  static List<String> toStringList(dynamic data) {
    if (data == null) {
      return [];
    }
    if (data is! List) {
      return [];
    }

    final values = <String>[];
    for (var value in data) {
      if (value != null && value is String) {
        values.add(value);
      }
    }
    return values;
  }
}
