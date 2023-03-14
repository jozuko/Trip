import 'package:pretty_http_logger/pretty_http_logger.dart' as http_logger;
import 'package:trip/repository/log/trip_logger.dart';

///
/// Created by r.mori on 2022/04/01.
/// Copyright (c) 2022 rei-frontier. All rights reserved.
///
class CurlLogger extends http_logger.Logger {
  CurlLogger() : super(logLevel: http_logger.LogLevel.BODY);

  @override
  void logRequest(http_logger.RequestData data) {
    final uri = data.url.toString();
    final method = data.method.toString().split('.')[1];

    final List<String> headers = <String>[];
    final requestHeaders = data.headers;
    if (requestHeaders != null) {
      for (final header in requestHeaders.entries.toList()) {
        headers.add(" --header '${header.key}: ${header.value}'");
      }
    }

    String body = data.body != null ? " --data-raw '${data.body}'" : "";

    final log = "curl --location --request $method '$uri'${headers.join("")}$body";
    TripLog.d(log);
  }

// @override
// void logResponse(http_logger.ResponseData data) {
//   super.logResponse(data);
//   TripLog.d('<-- ${data.statusCode} (${data.contentLength}-byte Body)');
// }
}
