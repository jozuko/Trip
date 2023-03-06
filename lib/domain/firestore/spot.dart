import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:trip/domain/firestore/firestore_converter.dart';
import 'package:trip/domain/firestore/location.dart';
import 'package:trip/domain/firestore/open_time.dart';
import 'package:trip/domain/firestore/time.dart';
import 'package:trip/domain/spot_type.dart';
import 'package:trip/repository/log/trip_logger.dart';

///
/// Created by jozuko on 2023/03/01.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class Spot extends Equatable {
  final String docId;
  final SpotType spot;
  final String? name;
  final String? phone;
  final String? address;
  final String? url;
  final Location? location;
  final OpenTimes openTimes;
  final Time updatedAt;

  const Spot({
    required this.docId,
    required this.spot,
    this.name,
    this.phone,
    this.address,
    this.url,
    this.location,
    required this.openTimes,
    required this.updatedAt,
  });

  factory Spot.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    Location? locationGeo;
    try {
      locationGeo = Location.fromFirestore(data?["location"]);
    } catch (e) {
      TripLog.e("Spot.fromFirestore LocationError $e");
    }

    return Spot(
      docId: snapshot.id,
      spot: SpotTypeEx.fromFirestore(data?["spot"]),
      name: FirestoreConverter.toNullableString(data?["name"]),
      phone: FirestoreConverter.toNullableString(data?["phone"]),
      address: FirestoreConverter.toNullableString(data?["address"]),
      url: FirestoreConverter.toNullableString(data?["url"]),
      location: locationGeo,
      openTimes: OpenTimes.fromFirestore(data?["openTime"]),
      updatedAt: Time.fromFirestore(data?["updatedAt"]),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "spot": spot.toFirestore(),
      "name": name,
      "phone": phone,
      "address": address,
      "url": url,
      "location": location?.toFirestore(),
      "openTimes": openTimes.toFirestore(),
      "updatedAt": updatedAt.toFirestore(),
    };
  }

  @override
  List<Object> get props => [
        docId,
        spot,
        name ?? "",
        phone ?? "",
        address ?? "",
        url ?? "",
        location ?? 0,
        openTimes,
        updatedAt,
      ];

  @override
  String toString() {
    return "["
        'docId: $docId, '
        'spot: $spot, '
        'name: ${name ?? ""}, '
        'phone: ${phone ?? ""}, '
        'address: ${address ?? ""}, '
        'url: ${url ?? ""}, '
        'location: $location '
        'openTime: $openTimes, '
        'updatedAt: $updatedAt '
        ']';
  }
}
