import 'package:equatable/equatable.dart';
import 'package:trip/domain/firestore/location.dart';

///
/// Created by jozuko on 2023/03/09.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class LocationData extends Equatable {
  final Location location;
  final String name;
  final String address;

  const LocationData({
    required this.location,
    this.name = "",
    this.address = "",
  });

  @override
  List<Object?> get props => [location, name, address];
}
