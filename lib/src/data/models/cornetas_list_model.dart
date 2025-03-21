import 'package:cornetas_itaipu/src/data/models/corneta.dart';
import 'package:flutter/material.dart';

class CornetasListModel {
  final String local;
  final List<Corneta> cornetas;
  final ValueNotifier<bool> selected = ValueNotifier(false);

  CornetasListModel({required this.local, required this.cornetas});
}
