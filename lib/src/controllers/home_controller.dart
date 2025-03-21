import 'package:cornetas_itaipu/src/data/services/data_service.dart';
import 'package:cornetas_itaipu/src/data/services/local_storage_service.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  bool _loader = true;
  bool get isLoading => _loader;

  void loadData() {
    final storage = LocalStorage.instance;

    final credentials = storage.getCredentials();
    final cornetas = storage.getCornetas();
    final songs = storage.getSongs();

    final data = DataService.instance;

    data.userCredential = credentials.user;
    data.passwordCredential = credentials.password;
    data.cornetas.addAll(cornetas);
    data.songs.addAll(songs);
    _loader = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    LocalStorage.instance.dispose();
  }
}
