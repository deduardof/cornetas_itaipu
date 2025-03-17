import 'package:cornetas_itaipu/src/data/services/data_service.dart';
import 'package:cornetas_itaipu/src/data/services/local_storage_service.dart';
import 'package:flutter/material.dart';

class CredentialsController extends ChangeNotifier {
  bool _loader = false;

  bool get isLoading => _loader;

  void _setLoader(bool value) {
    _loader = value;
    notifyListeners();
  }

  Future<void> saveCredentials({required String user, required String password}) async {
    _setLoader(true);
    await LocalStorage.instance.saveCredentials(user: user, password: password);
    DataService.instance.userCredential = user;
    DataService.instance.passwordCredential = password;
    _setLoader(false);
  }
}
