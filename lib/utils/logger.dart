import 'dart:developer' as dev;

class Logger {
  static void log(dynamic message) {
    dev.log(message.toString());
  }
}
