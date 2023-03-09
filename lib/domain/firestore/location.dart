import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  /// 東京駅
  static const def = Location(
      // latitude: 35.68146453647432,
      // longitude: 139.76712440766707,
      latitude: 35.68218126399646,
      longitude: 139.76356778894683);

  static Location? fromString(String locationText) {
    if (locationText.isEmpty) {
      return null;
    }
    final split = locationText.split(",");
    if (split.length != 2) {
      return null;
    }

    final latitude = double.tryParse(split[0].trim());
    if (latitude == null) {
      return null;
    }

    final longitude = double.tryParse(split[1].trim());
    if (longitude == null) {
      return null;
    }

    return Location(latitude: latitude, longitude: longitude);
  }

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

  String get label => "$latitude,$longitude";

  LatLng get latLng => LatLng(latitude, longitude);

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
