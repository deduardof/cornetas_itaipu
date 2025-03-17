import 'package:cornetas_itaipu/src/data/services/data_service.dart';
import 'package:cornetas_itaipu/src/data/services/local_storage_service.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  bool _loader = true;

  bool get isLoading => _loader;

  Future<void> loadData() async {
    final credentials = await LocalStorage.instance.getCredentials();

    final ips = await LocalStorage.instance.getAllIpAddress();

    DataService.instance.userCredential = credentials.user;
    DataService.instance.passwordCredential = credentials.password;
    DataService.instance.ips.addAll(ips);
    _loader = false;
    notifyListeners();
  }
}
