import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:trip/domain/api_converter.dart';
import 'package:trip/domain/firestore/location.dart';
import 'package:trip/domain/firestore/time.dart';
import 'package:trip/domain/spot_type.dart';

///
/// Created by jozuko on 2023/03/01.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class Spot extends Equatable {
  static const stayTimeDef = 30;

  final String docId;
  final String placeId;
  final SpotType spotType;
  final String name;
  final String phone;
  final String address;
  final String imageUrl;
  final String url;
  final Location location;
  final String memo;
  final int stayTime;
  final Time updatedAt;

  const Spot({
    required this.docId,
    required this.placeId,
    required this.spotType,
    required this.name,
    required this.phone,
    required this.address,
    required this.imageUrl,
    required this.url,
    required this.location,
    required this.memo,
    required this.stayTime,
    required this.updatedAt,
  });

  factory Spot.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Spot(
      docId: snapshot.id,
      placeId: DataConverter.toNonNullString(data?["placeId"]),
      spotType: SpotTypeEx.fromFirestore(data?["spot"]),
      name: DataConverter.toNonNullString(data?["name"]),
      phone: DataConverter.toNonNullString(data?["phone"]),
      address: DataConverter.toNonNullString(data?["address"]),
      imageUrl: DataConverter.toNonNullString(data?["imageUrl"]),
      url: DataConverter.toNonNullString(data?["url"]),
      location: Location.fromFirestore(data?["location"]),
      memo: DataConverter.toNonNullString(data?["memo"]),
      stayTime: DataConverter.toNonNullInt(data?["stayTime"], Spot.stayTimeDef),
      updatedAt: Time.fromFirestore(data?["updatedAt"]),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "placeId": placeId,
      "spot": spotType.toFirestore(),
      "name": name,
      "phone": phone,
      "address": address,
      "imageUrl": imageUrl,
      "url": url,
      "location": location.isInvalid ? null : location.toFirestore(),
      "memo": memo,
      "stayTime": stayTime,
      "updatedAt": updatedAt.toFirestore(),
    };
  }

  Spot copyWith({
    String? docId,
    String? placeId,
    SpotType? spotType,
    String? name,
    String? phone,
    String? address,
    String? imageUrl,
    String? url,
    Location? location,
    String? memo,
    int? stayTime,
    Time? updatedAt,
  }) {
    return Spot(
      docId: docId ?? this.docId,
      placeId: placeId ?? this.placeId,
      spotType: spotType ?? this.spotType,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      url: url ?? this.url,
      location: location?.copyWith() ?? this.location,
      memo: memo ?? this.memo,
      stayTime: stayTime ?? this.stayTime,
      updatedAt: updatedAt?.copyWith() ?? this.updatedAt,
    );
  }

  @override
  List<Object> get props => [
        docId,
        placeId,
        spotType,
        name,
        phone,
        address,
        imageUrl,
        url,
        location,
        memo,
        stayTime,
        updatedAt,
      ];

  @override
  String toString() {
    return "Spot["
        'docId:$docId, '
        'placeId:$placeId, '
        'spotType:$spotType, '
        'name:$name, '
        'phone:$phone, '
        'address:$address, '
        'imageUrl:$imageUrl, '
        'url:$url, '
        'location:$location, '
        'memo:${memo.split("\n").firstOrNull}, '
        'stayTime:$stayTime, '
        'updatedAt:$updatedAt'
        ']';
  }
}
