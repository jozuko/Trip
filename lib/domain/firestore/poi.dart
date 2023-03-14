import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:trip/domain/api_converter.dart';
import 'package:trip/domain/firestore/location.dart';
import 'package:trip/domain/firestore/time.dart';
import 'package:trip/domain/shared_poi.dart';

///
/// Created by jozuko on 2023/03/10.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class Poi extends Equatable {
  final String docId;
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String address;
  final String phoneNumber;
  final Location location;
  final List<String> openingHours;
  final List<String> types;
  final Time updatedAt;

  const Poi({
    required this.docId,
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.address,
    required this.phoneNumber,
    required this.location,
    required this.openingHours,
    required this.types,
    required this.updatedAt,
  });

  factory Poi.fromSharedPoi(SharedPoi sharedPoi) {
    return Poi(
      docId: sharedPoi.placeId,
      title: sharedPoi.title,
      description: sharedPoi.description,
      url: sharedPoi.url,
      imageUrl: sharedPoi.imageUrl,
      address: sharedPoi.address,
      phoneNumber: sharedPoi.phoneNumber,
      location: sharedPoi.location,
      openingHours: sharedPoi.openingHours,
      types: sharedPoi.types,
      updatedAt: Time.current(),
    );
  }

  factory Poi.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Poi(
      docId: snapshot.id,
      title: DataConverter.toNonNullString(data?["title"]),
      description: DataConverter.toNonNullString(data?["description"]),
      url: DataConverter.toNonNullString(data?["url"]),
      imageUrl: DataConverter.toNonNullString(data?["imageUrl"]),
      address: DataConverter.toNonNullString(data?["address"]),
      phoneNumber: DataConverter.toNonNullString(data?["phoneNumber"]),
      location: Location.fromFirestore(data?["location"]),
      openingHours: DataConverter.toStringList(data?["openingHours"]),
      types: DataConverter.toStringList(data?["types"]),
      updatedAt: Time.fromFirestore(data?["updatedAt"]),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "title": title,
      "description": description,
      "url": url,
      "imageUrl": imageUrl,
      "address": address,
      "phoneNumber": phoneNumber,
      "location": location.isInvalid ? null : location.toFirestore(),
      "openingHours": openingHours,
      "types": types,
      "updatedAt": updatedAt.toFirestore(),
    };
  }

  static List<Poi> fromJson(String json) {
    if (json.isEmpty) {
      return [];
    }
    List<dynamic> dataList = const JsonDecoder().convert(json);

    return dataList.map((data) {
      double latitude = DataConverter.toNonNullDouble(data?["latitude"]);
      double longitude = DataConverter.toNonNullDouble(data?["longitude"]);

      return Poi(
        docId: DataConverter.toNonNullString(data?["docId"]),
        title: DataConverter.toNonNullString(data?["title"]),
        description: DataConverter.toNonNullString(data?["description"]),
        url: DataConverter.toNonNullString(data?["url"]),
        imageUrl: DataConverter.toNonNullString(data?["imageUrl"]),
        address: DataConverter.toNonNullString(data?["address"]),
        phoneNumber: DataConverter.toNonNullString(data?["phoneNumber"]),
        location: Location(latitude: latitude, longitude: longitude),
        openingHours: DataConverter.toStringList(data?["openingHours"]),
        types: DataConverter.toStringList(data?["types"]),
        updatedAt: Time(seconds: DataConverter.toNonNullInt(data?["updatedAt"])),
      );
    }).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "docId": docId,
      "title": title,
      "description": description,
      "url": url,
      "imageUrl": imageUrl,
      "address": address,
      "phoneNumber": phoneNumber,
      "latitude": location.latitude,
      "longitude": location.longitude,
      "openingHours": openingHours,
      "types": types,
      "updatedAt": updatedAt.seconds,
    };
  }

  Poi copyWith({
    String? docId,
    String? title,
    String? description,
    String? url,
    String? imageUrl,
    String? address,
    String? phoneNumber,
    Location? location,
    List<String>? openingHours,
    List<String>? types,
    Time? updatedAt,
  }) {
    return Poi(
      docId: docId ?? this.docId,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location?.copyWith() ?? this.location,
      openingHours: openingHours?.map((e) => e).toList() ?? this.openingHours,
      types: types?.map((e) => e).toList() ?? this.types,
      updatedAt: updatedAt?.copyWith() ?? this.updatedAt,
    );
  }

  String get memo {
    final memo = <String>[];
    if (description.isNotEmpty) {
      memo.add(description);
    }
    memo.addAll(openingHours);
    return memo.join("\n");
  }

  @override
  List<Object?> get props => [
        docId,
        title,
        description,
        url,
        imageUrl,
        address,
        phoneNumber,
        location,
        openingHours,
        types,
      ];
}
