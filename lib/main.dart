import 'package:cornetas_itaipu/src/app.dart';
import 'package:cornetas_itaipu/src/data/services/local_storage_service.dart';
import 'package:flutter/material.dart';

void main() {
  LocalStorage.instance.init();

  runApp(const App());
}
