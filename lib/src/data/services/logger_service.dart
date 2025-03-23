import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

class Logger extends ChangeNotifier {
  static Logger? _instance;

  Logger._() {
    final now = DateTime.now().toIso8601String();
    _logFile.writeAsBytesSync('\n=============== START LOG: $now ===============\n'.codeUnits, mode: FileMode.append);
  }
  static Logger get instance => _instance ??= Logger._();

  String _text = '';
  final _logFile = File('cornetas_itaipu.log');

  String get text => _text;

  void write(String value) {
    log(value);
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
