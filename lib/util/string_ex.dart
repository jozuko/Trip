import 'package:trip/util/datetime_ex.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
extension StringEx on String? {
  String? get emptyToNull {
    if (this == null) {
      return null;
    }
    if (this?.isEmpty == true) {
      return null;
    }
    return this;
  }

  String get nullToEmpty {
    return this ?? '';
  }

  /// "HH:mm" or "H:mm" -> DateTime(now.year, now.month, now.day, HH, mm)
  DateTime? get convertTime {
    final source = this;
    if (source == null) {
      return null;
    }

    final split = source.split(":");
    if (split.length != 2) {
      return null;
    }

    final hour = int.tryParse(split[0]);
    if (hour == null) {
      return null;
    }

    final minute = int.tryParse(split[1]);
    if (minute == null) {
      return null;
    }

    return DateTime.now().copyWith(hour: hour, minute: minute);
  }
}
