import 'dart:collection';

import 'package:cornetas_itaipu/src/data/models/corneta.dart';
import 'package:cornetas_itaipu/src/data/models/ip_address.dart';
import 'package:cornetas_itaipu/src/data/services/data_service.dart';
import 'package:cornetas_itaipu/src/data/services/local_storage_service.dart';
import 'package:flutter/material.dart';

class CornetasController extends ChangeNotifier {
  final _localStorage = LocalStorage.instance;
  final _data = DataService.instance;

  final _ipMessage = ValueNotifier<String>('');
  ValueNotifier<String> get ipMessage => _ipMessage;

  final _message = ValueNotifier<String>('');
  ValueNotifier<String> get message => _message;

  UnmodifiableListView<Corneta> get cornetas => UnmodifiableListView(_data.cornetas);
  UnmodifiableListView<Corneta> getCornetasWhere({required String value}) =>
      UnmodifiableListView(_data.cornetas.where((corneta) => corneta.local.contains(value)).toList());

  String? validateIP(String? value) {
    if (value == null || value.isEmpty || !IpAddress.validate(value: value)) return 'Forneça um IP válido.';

    final ip = IpAddress.fromString(value);

    for (var corneta in _data.cornetas) {
      if (corneta.ip == ip) return 'IP já cadastrado.';
    }
    return null;
  }

  String? validateLabel(String? value) => (value?.isEmpty ?? true) ? 'Informe um nome para a corneta.' : null;

  String? validateLocal(String? value) => (value?.isEmpty ?? true) ? 'Informe o local da corneta.' : null;

  void addCorneta({required String local, required String label, required String ip, String? user, String? password, String? song}) {
    final data = DataService.instance;
    final corneta = Corneta(
      local: local,
      name: label,
      ip: IpAddress.fromString(ip),
      user: user ?? data.userCredential,
      password: password ?? data.passwordCredential,
      song: song ?? data.songs.firstWhere((s) => s.selected).name,
      status: ValueNotifier(CornetaStatus.ready),
    );
    final id = _localStorage.addCorneta(corneta: corneta);
    corneta.id = id;
    _data.cornetas.add(corneta);
    notifyListeners();
  }

  Corneta? getCornetaByIp({required String text}) {
    if (IpAddress.validate(value: text)) {
      final ip = IpAddress.fromString(text);
      try {
        _message.value = '';
        return _data.cornetas.firstWhere((c) => c.ip == ip);
      } on StateError catch (e) {
        _message.value = 'Corneta não encontrada.';
      }
    } else {
      _message.value = 'IP inválido.';
    }

    return null;
  }

  void getCornetas() {
    final response = _localStorage.getCornetas();
    _data.cornetas.clear();
    _data.cornetas.addAll(response);
    notifyListeners();
  }

  void removeCorneta({required Corneta corneta}) async {
    _data.cornetas.removeWhere((c) => c.id == corneta.id);
    _localStorage.removeCorneta(corneta: corneta);
    notifyListeners();
  }
}
