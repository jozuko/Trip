import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

///
/// Created by jozuko on 2023/03/06.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class Location extends Equatable {
  final double latitude;
  final double longitude;

  const Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromFirestore(dynamic data) {
    if (data == null) {
      throw "data is null";
    }
    if (data is! GeoPoint) {
      throw "data is not GeoPoint";
    }

    return Location(
      latitude: data.latitude,
      longitude: data.longitude,
    );
  }

  GeoPoint toFirestore() {
    return GeoPoint(latitude, longitude);
  }

  @override
  List<Object?> get props => [
        latitude,
        longitude,
      ];

  @override
  String toString() {
    return '[$latitude, $longitude]';
  }
}
