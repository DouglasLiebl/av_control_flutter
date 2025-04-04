import 'package:demo_project/utils/logger.dart';
import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {
  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    disposeAdditional();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!disposed) {
      super.notifyListeners();
    }
  }

  Future<void> handleError(dynamic e, StackTrace? stackTrace, {bool? showPopUp = true, bool? isPortrait}) async {
    Logger.log(e);
    Logger.log(stackTrace);
    throw e;
  }

  void disposeAdditional() {}
}