import 'dart:convert';

import 'package:http/http.dart';
import 'package:trip/domain/api_converter.dart';
import 'package:trip/domain/firestore/location.dart';

///
/// Created by jozuko on 2023/03/10.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class PlaceDetailRes {
  final bool isSuccess;
  final int statusCode;
  final PlaceDetailResResult? result;

  const PlaceDetailRes({
    required this.isSuccess,
    required this.statusCode,
    required this.result,
  });

  factory PlaceDetailRes.fromApi(Response response) {
    final statusCode = response.statusCode;
    final body = response.body;
    if (response.statusCode != 200) {
      return PlaceDetailRes(isSuccess: false, statusCode: statusCode, result: null);
    }

    if (body.isEmpty) {
      return PlaceDetailRes(isSuccess: true, statusCode: statusCode, result: null);
    }

    Map<String, dynamic> jsonMap = const JsonDecoder().convert(body);
    return PlaceDetailRes(
      isSuccess: true,
      statusCode: statusCode,
      result: PlaceDetailResResult.fromApiMap(DataConverter.toNonNullMap(jsonMap["result"])),
    );
  }
}

class PlaceDetailResResult {
  final String placeId;
  final String name;
  final List<String> openingHours;
  final String overview;
  final String address;
  final String phoneNumber;
  final Location location;
  final List<String> types;
  final String website;

  const PlaceDetailResResult({
    required this.placeId,
    required this.name,
    required this.openingHours,
    required this.overview,
    required this.address,
    required this.phoneNumber,
    required this.location,
    required this.types,
    required this.website,
  });

  factory PlaceDetailResResult.fromApiMap(Map<String, dynamic> map) {
    return PlaceDetailResResult(
      placeId: DataConverter.toNonNullString(map["place_id"]),
      name: DataConverter.toNonNullString(map["name"]),
      openingHours: _getOpeningHours(map),
      overview: _getOverview(map),
      address: _getAddress(map),
      phoneNumber: DataConverter.toNonNullString(map["formatted_phone_number"]),
      location: _getLocation(map),
      types: DataConverter.toStringList(map["types"]),
      website: DataConverter.toNonNullString(map["website"]),
    );
  }

  static String _getAddress(Map<String, dynamic> map) {
    final formattedAddress = DataConverter.toNonNullString(map["formatted_address"]);
    final addressSplit = formattedAddress.split(" ");

    if (addressSplit.isNotEmpty) {
      if (addressSplit.length >= 2) {
        addressSplit.removeAt(0);
      }
      return addressSplit.join();
    } else {
      return formattedAddress;
    }
  }

  static Location _getLocation(Map<String, dynamic> map) {
    final geometry = DataConverter.toNonNullMap(map["geometry"]);
    final location = DataConverter.toNonNullMap(geometry["location"]);
    final lat = DataConverter.toNonNullDouble(location["lat"]);
    final lng = DataConverter.toNonNullDouble(location["lng"]);

    return Location(latitude: lat, longitude: lng);
  }

  static List<String> _getOpeningHours(Map<String, dynamic> map) {
    final currentOpeningHours = DataConverter.toNonNullMap(map["current_opening_hours"]);
    final weekdayText = DataConverter.toStringList(currentOpeningHours["weekday_text"]);
    return weekdayText;
  }

  static String _getOverview(Map<String, dynamic> map) {
    final editorialSummary = DataConverter.toNonNullMap(map["editorial_summary"]);
    final overview = DataConverter.toNonNullString(editorialSummary["overview"]);
    return overview;
  }
}
