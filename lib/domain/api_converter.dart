///
/// Created by jozuko on 2023/03/06.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class DataConverter {
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

  static int toNonNullInt(dynamic data, [int defaultValue = 0]) {
    if (data == null) {
      return defaultValue;
    }

    if (data is int) {
      return data;
    }

    if (data is double) {
      return data.toInt();
    }

    if (data is String) {
      return int.tryParse(data) ?? defaultValue;
    }

    return defaultValue;
  }

  static double toNonNullDouble(dynamic data, [double defaultValue = 0.0]) {
    if (data == null) {
      return defaultValue;
    }

    if (data is int) {
      return data.toDouble();
    }

    if (data is double) {
      return data;
    }

    if (data is String) {
      return double.tryParse(data) ?? defaultValue;
    }

    return defaultValue;
  }

  static Map<String, dynamic> toNonNullMap(dynamic data) {
    return (data as Map<String, dynamic>?) ?? <String, dynamic>{};
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
