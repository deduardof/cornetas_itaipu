import 'dart:io';

import 'package:flutter/material.dart';

class Logger extends ChangeNotifier {
  static Logger? _instance;

  Logger._();
  static Logger get instance => _instance ??= Logger._();

  String _text = '';
  final _logFile = File('cornetas_itaipu.log');

  String get text => _text;

  void write(String value) {
    _text = '$_text$value\n';
    _logFile.writeAsBytesSync(value.codeUnits, mode: FileMode.append);
    notifyListeners();
  }

  void clear() {
    _text = '';
    _logFile.writeAsBytesSync('=================== RESET LOG CONTENT ===================\n'.codeUnits, mode: FileMode.append);
    notifyListeners();
  }
}
