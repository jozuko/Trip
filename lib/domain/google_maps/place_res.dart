import 'dart:convert';

import 'package:http/http.dart';
import 'package:trip/domain/api_converter.dart';

///
/// Created by jozuko on 2023/03/09.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class PlaceListRes {
  final bool isSuccess;
  final int statusCode;
  final List<PlaceListResItem> results;

  const PlaceListRes({
    required this.isSuccess,
    required this.statusCode,
    required this.results,
  });

  factory PlaceListRes.fromApi(Response response) {
    final statusCode = response.statusCode;
    final body = response.body;
    if (response.statusCode != 200) {
      return PlaceListRes(isSuccess: false, statusCode: statusCode, results: []);
    }

    if (body.isEmpty) {
      return PlaceListRes(isSuccess: true, statusCode: statusCode, results: []);
    }

    Map<String, dynamic> jsonMap = const JsonDecoder().convert(body);
    final results = jsonMap["results"] as List<dynamic>?;
    if (results == null) {
      return PlaceListRes(isSuccess: true, statusCode: statusCode, results: []);
    }
    return PlaceListRes(
      isSuccess: true,
      statusCode: statusCode,
      results: results.map((result) => PlaceListResItem.fromMap(ApiConverter.toNonNullMap(result))).toList(),
    );
  }
}

class PlaceListResItem {
  final PlaceResGeometry geometry;
  final String name;
  final String placeId;

  const PlaceListResItem({
    required this.geometry,
    required this.name,
    required this.placeId,
  });

  factory PlaceListResItem.fromMap(Map<String, dynamic>? map) {
    return PlaceListResItem(
      geometry: PlaceResGeometry.fromMap(map?["geometry"]),
      name: ApiConverter.toNonNullString(map?["name"]),
      placeId: ApiConverter.toNonNullString(map?["place_id"]),
    );
  }
}

class PlaceResGeometry {
  final PlaceResLocation location;

  const PlaceResGeometry({
    required this.location,
  });

  factory PlaceResGeometry.fromMap(Map<String, dynamic>? map) {
    return PlaceResGeometry(
      location: PlaceResLocation.fromMap(ApiConverter.toNonNullMap(map?["location"])),
    );
  }
}

class PlaceResLocation {
  final double lat;
  final double lng;

  const PlaceResLocation({
    required this.lat,
    required this.lng,
  });

  factory PlaceResLocation.fromMap(Map<String, dynamic>? map) {
    return PlaceResLocation(
      lat: ApiConverter.toNonNullDouble(map?["lat"], 0.0),
      lng: ApiConverter.toNonNullDouble(map?["lng"], 0.0),
    );
  }
}
