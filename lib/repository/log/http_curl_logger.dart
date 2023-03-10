import 'package:pretty_http_logger/pretty_http_logger.dart' as http_logger;
import 'package:pretty_http_logger/src/middleware/middleware_contract.dart';
import 'package:pretty_http_logger/src/middleware/models/request_data.dart';
import 'package:pretty_http_logger/src/middleware/models/response_data.dart';
import 'package:trip/repository/log/curl_logger.dart';

///
/// Created by r.mori on 2022/04/01.
/// Copyright (c) 2022 rei-frontier. All rights reserved.
///
class HttpCurlLogger implements MiddlewareContract {
  http_logger.LogLevel logLevel = http_logger.LogLevel.HEADERS;
  CurlLogger? logger = CurlLogger();

  @override
  void interceptRequest(RequestData data) {
    logger!.logRequest(data);
  }

  @override
  void interceptResponse(ResponseData data) {
    logger!.logResponse(data);
  }

  @override
  void interceptError(dynamic error) {
    logger!.logError(error);
  }
}
