import 'dart:collection';

import 'package:cornetas_itaipu/src/data/services/data_service.dart';
import 'package:cornetas_itaipu/src/data/services/local_storage_service.dart';
import 'package:flutter/material.dart';

class ConfigController extends ChangeNotifier {
  final _storage = LocalStorage.instance;
  final _data = DataService.instance;

  bool _loader = false;

  bool get isLoading => _loader;
  UnmodifiableListView<String> get audios => UnmodifiableListView(_data.audios);

  void _setLoader(bool value) {
    _loader = value;
    notifyListeners();
  }

  String? validateAudio(String? value) {
    if (value?.isEmpty ?? true) return 'Informe o nome do áudio';
    return (_data.audios.contains(value)) ? 'Áudio já cadastrado.' : null;
  }

  Future<void> saveCredentials({required String user, required String password}) async {
    _setLoader(true);
    await _storage.saveCredentials(user: user, password: password);
    _data.userCredential = user;
    _data.passwordCredential = password;
    _setLoader(false);
  }

  Future<void> addAudio({required String audio}) async {
    if (!_data.audios.contains(audio)) {}

    _data.audios.add(audio);
    await _storage.saveAudios(audios: _data.audios);
    notifyListeners();
  }

  Future<void> removeAudio({required int index}) async {
    _data.audios.removeAt(index);
    await _storage.saveAudios(audios: _data.audios);
    notifyListeners();
  }
}
