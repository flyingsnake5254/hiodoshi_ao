import 'package:logger/logger.dart';
import 'package:global_configuration/global_configuration.dart';
/*
* Usage
LogService.d("Debug log");
LogService.i("Info log");
LogService.w("Warning log");
LogService.e("Error log", error: exception, stackTrace: trace);
LogService.t("Trace log");
* */

class LogService {
  static late final Logger _logger;
  static late final bool _isDev;

  static void init() {
    final env = GlobalConfiguration().getValue<String>('environment');
    _isDev = env == 'development';

    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: _isDev ? Level.debug : Level.off,
    );
  }

  static void d(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.log(Level.debug, message, error: error, stackTrace: stackTrace);
  }

  static void i(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.log(Level.info, message, error: error, stackTrace: stackTrace);
  }

  static void w(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.log(Level.warning, message, error: error, stackTrace: stackTrace);
  }

  static void e(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.log(Level.error, message, error: error, stackTrace: stackTrace);
  }

  static void v(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.log(Level.trace, message, error: error, stackTrace: stackTrace);
  }
}
