import 'package:pretty_http_logger/pretty_http_logger.dart' as http_logger;
import 'package:trip/repository/log/curl_logger.dart';

///
/// Created by r.mori on 2022/04/01.
/// Copyright (c) 2022 rei-frontier. All rights reserved.
///
class HttpCurlLogger implements http_logger.MiddlewareContract {
  http_logger.LogLevel logLevel = http_logger.LogLevel.HEADERS;
  CurlLogger? logger = CurlLogger();

  @override
  void interceptRequest(http_logger.RequestData data) {
    logger!.logRequest(data);
  }

  @override
  void interceptResponse(http_logger.ResponseData data) {
    logger!.logResponse(data);
  }

  @override
  void interceptError(dynamic error) {
    logger!.logError(error);
  }
}
