import 'package:intl/intl.dart';

///
/// Created by jozuko on 2023/03/09.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
extension DateTimeEx on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
  }) {
    final source = this;

    return DateTime(
      year ?? source.year,
      month ?? source.month,
      day ?? source.day,
      hour ?? source.hour,
      minute ?? source.minute,
      0,
      0,
      0,
    );
  }

  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }
}
