import 'dart:collection';

import 'package:cornetas_itaipu/src/data/models/ip_address.dart';
import 'package:cornetas_itaipu/src/data/services/data_service.dart';
import 'package:cornetas_itaipu/src/data/services/local_storage_service.dart';
import 'package:flutter/material.dart';

class NetworkController extends ChangeNotifier {
  final _cornetas = <IpAddress>[];
  final _localStorage = LocalStorage.instance;

  UnmodifiableListView<IpAddress> get cornetas => UnmodifiableListView(_cornetas);

  String? validateIP(String? value) {
    if (value == null || value.isEmpty || !IpAddress.validate(value: value)) return 'Forneça um IP válido.';
    final ip = IpAddress.fromString(value);
    return (_cornetas.contains(ip)) ? 'IP já cadastrado.' : null;
  }

  void init() {
    _cornetas.clear();
    _cornetas.addAll(DataService.instance.ips);
  }

  Future<void> load() async {
    final cornetas = await _localStorage.getAllIpAddress();
    _cornetas.clear();
    _cornetas.addAll(cornetas);
    notifyListeners();
  }

  Future<void> addCorneta({required String value}) async {
    final corneta = IpAddress.fromString(value);
    if (!_cornetas.contains(corneta)) {
      _cornetas.add(corneta);
      await _localStorage.setIPs(ips: _cornetas);
      DataService.instance.ips.add(corneta);
      notifyListeners();
    }
  }

  Future<void> remove(int index) async {
    _cornetas.removeAt(index);
    await _localStorage.setIPs(ips: _cornetas);
    DataService.instance.ips.clear();
    DataService.instance.ips.addAll(_cornetas);
    notifyListeners();
  }
}
