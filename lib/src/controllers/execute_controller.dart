import 'dart:collection';

import 'package:cornetas_itaipu/src/data/models/corneta.dart';
import 'package:cornetas_itaipu/src/data/models/cornetas_list_model.dart';
import 'package:cornetas_itaipu/src/data/services/cornetas_service.dart';
import 'package:cornetas_itaipu/src/data/services/data_service.dart';
import 'package:flutter/material.dart';

class ExecuteController extends ChangeNotifier {
  final _isPlaying = ValueNotifier(false);
  ValueNotifier<bool> get isPlaying => _isPlaying;

  final _isCanceling = ValueNotifier(false);
  ValueNotifier<bool> get isCanceling => _isCanceling;

  final _cornetas = <CornetasListModel>[];
  UnmodifiableListView<CornetasListModel> get cornetas => UnmodifiableListView(_cornetas);

  ExecuteController() {
    final cornetas = DataService.instance.cornetas;
    for (var corneta in cornetas) {
      corneta.selected = ValueNotifier(false);
      if (!_cornetas.any((c) => c.local == corneta.local)) {
        _cornetas.add(CornetasListModel(local: corneta.local, cornetas: cornetas.where((c) => c.local == corneta.local).toList()));
      }
    }
  }

  Future<void> execute({required Corneta corneta}) async {
    corneta.status.value = CornetaStatus.playing;
    final response = await CornetasService.instance.play(corneta: corneta);
    corneta.status.value = (response) ? CornetaStatus.success : CornetaStatus.error;
  }

  Future<void> executeSelected() async {
    _isPlaying.value = true;

    await Future.wait(_cornetas.expand((c) => c.cornetas).where((c) => c.selected.value).map((c) => execute(corneta: c)));

    _isPlaying.value = false;
  }

  Future<void> stop({required Corneta corneta}) async {
    final response = await CornetasService.instance.stop(corneta: corneta);
    corneta.status.value = (response) ? CornetaStatus.success : CornetaStatus.error;
  }

  Future<void> stopAllPlaying() async {
    _isCanceling.value = true;
    await Future.wait(_cornetas.expand((c) => c.cornetas).where((c) => c.status.value == CornetaStatus.playing).map((c) => stop(corneta: c)));
    _isCanceling.value = false;
  }
}
