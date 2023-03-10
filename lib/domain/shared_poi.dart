import 'package:trip/domain/firestore/location.dart';
import 'package:trip/domain/shared_text.dart';

///
/// Created by jozuko on 2023/03/10.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class SharedPoi extends SharedData {
  final String placeId;
  final List<String> openingHours;
  final String address;
  final String phoneNumber;
  final Location location;
  final List<String> types;

  const SharedPoi({
    super.url = '',
    super.title = '',
    super.description = '',
    super.imageUrl = '',
    this.placeId = '',
    this.openingHours = const [],
    this.address = '',
    this.phoneNumber = '',
    this.location = const Location(latitude: 0.0, longitude: 0.0),
    this.types = const [],
  });

  @override
  SharedPoi copyWith({
    String? url,
    String? title,
    String? description,
    String? imageUrl,
  }) {
    return SharedPoi(
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      placeId: placeId,
      openingHours: openingHours,
      address: address,
      phoneNumber: phoneNumber,
      location: location,
      types: types,
    );
  }

  @override
  List<Object?> get props => [
        url,
        title,
        description,
        imageUrl,
        placeId,
        openingHours,
        address,
        phoneNumber,
        location,
        types,
      ];
}
