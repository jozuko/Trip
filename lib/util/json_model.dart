///
/// Created by r.mori on 2022/12/01.
/// Copyright (c) 2022 rei-frontier. All rights reserved.
///
class JsonModel {
  static double doubleValue(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) {
      return defaultValue;
    }
    if (value is double) {
      return value;
    }
    if (value is int) {
      return (value).toDouble();
    }

    if (value is String) {
      try {
        return double.parse(value);
      } on Exception catch (_) {
        return defaultValue;
      }
    }

    return defaultValue;
  }

  static int intValue(dynamic value, {int defaultValue = 0}) {
    if (value == null) {
      return defaultValue;
    }

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    if (value is String) {
      try {
        return int.parse(value);
      } on Exception catch (_) {
        return defaultValue;
      }
    }

    return defaultValue;
  }

  static int? intOrNullValue(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    if (value is String) {
      try {
        return int.parse(value);
      } on Exception catch (_) {
        return null;
      }
    }

    return null;
  }

  static String stringValue(dynamic value, {String defaultValue = ''}) {
    if (value == null) {
      return defaultValue;
    }
    if (value is String) {
      return value;
    }
    if (value is bool) {
      return value.toString();
    }
    if (value is int) {
      return value.toString();
    }
    if (value is double) {
      return value.toString();
    }
    return defaultValue;
  }

  static DateTime? dateTimeValue(dynamic value) {
    if (value == null) {
      return null;
    }

    final unixTime = intValue(value);
    return DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
  }
}
