import 'package:logger/logger.dart';
class Log {
  static final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void t(String message) => _logger.t(message);

  static void d(String message) => _logger.d(message);

  static void i(String message) => _logger.i(message);

  static void w(String message, {dynamic error}) => _logger.w(message, error: error);

  static void e(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void f(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}