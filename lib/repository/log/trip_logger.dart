import 'package:logger/logger.dart';
import 'package:trip/util/global.dart';

class TripLog {
  static Logger logger = Logger(
    filter: TripLogFilter(),
    printer: PrettyPrinter(
      methodCount: 0,
      // number of method calls to be displayed
      errorMethodCount: 8,
      // number of method calls if stacktrace is provided
      lineLength: 120,
      // width of the output
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      printTime: false,
      // Should each log print contain a timestamp

      noBoxingByDefault: true,
    ),
  );

  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.d('[Trip]$message', error, stackTrace);
  }

  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.i('[Trip]$message', error, stackTrace);
  }

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.e('[Trip]$message', error, stackTrace);
  }
}

class TripLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (isRelease) {
      return (event.level.index >= Level.info.index);
    } else {
      return true;
    }
  }
}
