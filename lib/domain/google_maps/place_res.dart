import 'dart:convert';

import 'package:http/http.dart';
import 'package:trip/domain/api_converter.dart';
import 'package:trip/domain/firestore/location.dart';

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
      results: results.map((result) => PlaceListResItem.fromMap(DataConverter.toNonNullMap(result))).toList(),
    );
  }
}

class PlaceListResItem {
  final String placeId;
  final String name;
  final Location location;

  const PlaceListResItem({
    required this.placeId,
    required this.name,
    required this.location,
  });

  factory PlaceListResItem.fromMap(Map<String, dynamic> map) {
    return PlaceListResItem(
      placeId: DataConverter.toNonNullString(map["place_id"]),
      name: DataConverter.toNonNullString(map["name"]),
      location: _getLocation(map),
    );
  }

  static Location _getLocation(Map<String, dynamic> map) {
    final geometry = DataConverter.toNonNullMap(map["geometry"]);
    final location = DataConverter.toNonNullMap(geometry["location"]);
    final lat = DataConverter.toNonNullDouble(location["lat"]);
    final lng = DataConverter.toNonNullDouble(location["lng"]);

    return Location(latitude: lat, longitude: lng);
  }
}
