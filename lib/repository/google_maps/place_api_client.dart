import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart' as http_middle;
import 'package:trip/repository/log/http_curl_logger.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/util/global.dart';

import '../../domain/firestore/location.dart';

///
/// Created by jozuko on 2023/03/09.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class GoogleMapsPlaceApi {
  static const _domain = "maps.googleapis.com";
  static const _timeout = Duration(seconds: 10);

  final http_middle.HttpWithMiddleware _httpClient = http_middle.HttpWithMiddleware.build(middlewares: [HttpCurlLogger()]);

  Uri _getUri({required String endPoint, Map<String, dynamic>? query}) {
    return Uri.https(_domain, '/maps/api/place/$endPoint/json', query);
  }

  http.Response _getResponseTimeout() {
    return http.Response('{"error": "Timeout"}', 408);
  }

  Future<void> searchFromLatLng(Location location) async {
    final uri = _getUri(
      endPoint: 'nearbysearch',
      query: <String, dynamic>{
        "location": "${location.latitude},${location.longitude}",
        "radius": "100",
        "language": "ja",
        "key": googleMapsApiKey,
      },
    );

    final response = await _httpClient.get(uri).timeout(_timeout, onTimeout: _getResponseTimeout);
    TripLog.d("searchFromLatLng ${response.statusCode}, ${response.body}");
    // TODO レスポンスを作ろう！！
  }

  Future<void> searchFromWord(String word) async {
    final uri = _getUri(
      endPoint: 'textsearch',
      query: <String, dynamic>{
        "query": word,
        "language": "ja",
        "key": googleMapsApiKey,
      },
    );

    final response = await http.get(uri).timeout(_timeout, onTimeout: _getResponseTimeout);
    TripLog.d("searchFromWord ${response.statusCode}, ${response.body}");
  }
}
