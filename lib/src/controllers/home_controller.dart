import 'package:cornetas_itaipu/src/data/services/data_service.dart';
import 'package:cornetas_itaipu/src/data/services/local_storage_service.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  bool _loader = true;

  bool get isLoading => _loader;

  Future<void> loadData() async {
    final credentials = await LocalStorage.instance.getCredentials();
    final ips = await LocalStorage.instance.getAllIpAddress();
    final audios = await LocalStorage.instance.getAudios();

    final data = DataService.instance;

    data.userCredential = credentials.user;
    data.passwordCredential = credentials.password;
    data.ips.addAll(ips);
    data.audios.addAll(audios);
    _loader = false;
    notifyListeners();
  }
}
