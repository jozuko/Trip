import 'package:equatable/equatable.dart';
import 'package:trip/repository/log/trip_logger.dart';

///
/// Created by jozuko on 2023/03/06.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class OpenTimes extends Equatable {
  final List<OpenTime> times;

  const OpenTimes({
    this.times = const <OpenTime>[],
  });

  factory OpenTimes.fromFirestore(List<dynamic>? dataList) {
    if (dataList == null) {
      return const OpenTimes();
    }

    var openTimes = <OpenTime>[];
    for (var data in dataList) {
      try {
        openTimes.add(OpenTime.fromFirestore(data));
      } catch (e) {
        TripLog.e('OpenTime $e');
      }
    }

    return OpenTimes(times: openTimes);
  }

  List<Map<String, Object?>> toFirestore() {
    return times.map((e) => e.toFirestore()).toList();
  }

  String get label => times.join(", ");

  OpenTimes replaceTime(
    int index, {
    String? from,
    String? to,
  }) {
    List<OpenTime> times = [];
    times.addAll(this.times);

    if (index < 0 || index >= times.length) {
      times.add(OpenTime(from: from ?? "", to: to ?? ""));
    } else {
      final source = times[index];
      TripLog.d("time source $source");
      times[index] = source.copyWith(from: from, to: to);
    }

    return OpenTimes(times: times);
  }

  OpenTimes remove(int index) {
    List<OpenTime> times = [];
    times.addAll(this.times);

    if (index >= 0 && index < times.length) {
      times.removeAt(index);
    }

    return OpenTimes(times: times);
  }

  @override
  List<Object?> get props => [
        times,
      ];

  @override
  String toString() {
    return '[${times.join(",")}]';
  }
}

class OpenTime extends Equatable {
  final String from;
  final String to;

  const OpenTime({
    required this.from,
    required this.to,
  });

  factory OpenTime.fromFirestore(dynamic data) {
    if (data == null) {
      throw "argument is null";
    }
    if (data is! Map) {
      throw "argument is not map";
    }

    var from = data["from"];
    if (from == null || from is! String) {
      throw "from is null or not String";
    }

    var to = data["to"];
    if (to == null || to is! String) {
      throw "to is null or not String";
    }
    return OpenTime(
      from: from,
      to: to,
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "from": from,
      "to": to,
    };
  }

  OpenTime copyWith({
    String? from,
    String? to,
  }) {
    return OpenTime(
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }

  @override
  List<Object?> get props => [from, to];

  @override
  String toString() {
    return '$from-$to';
  }
}
