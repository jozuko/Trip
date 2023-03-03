import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

///
/// Created by jozuko on 2023/03/01.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class Spot extends Equatable {
  final String docId;
  final int spot;
  final String? name;
  final String? phone;
  final String? address;
  final String? url;
  final LatLng? location;
  final List<Map<String, String>> openTime;
  final int updatedAt;

  Spot({
    required this.docId,
    required this.spot,
    this.name,
    this.phone,
    this.address,
    this.url,
    this.location,
    required this.openTime,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [];
}
