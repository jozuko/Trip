import 'package:logger/logger.dart';
import 'package:trip/util/global.dart';

class TripLog {
  static Logger logger = Logger(
    filter: TripLogFilter(),
    printer: PrettyPrinter(
      methodCount: 2,
      // number of method calls to be displayed
      errorMethodCount: 8,
      // number of method calls if stacktrace is provided
      lineLength: 120,
      // width of the output
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      printTime: true, // Should each log print contain a timestamp
    ),
  );
}

class TripLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (Global.isRelease) {
      return (event.level.index >= Level.info.index);
    } else {
      return true;
    }
  }
}
