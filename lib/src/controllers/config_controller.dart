import 'dart:collection';

import 'package:cornetas_itaipu/src/data/models/song.dart';
import 'package:cornetas_itaipu/src/data/services/data_service.dart';
import 'package:cornetas_itaipu/src/data/services/local_storage_service.dart';
import 'package:flutter/material.dart';

class ConfigController extends ChangeNotifier {
  final _storage = LocalStorage.instance;
  final _data = DataService.instance;

  bool _loader = false;
  bool get isLoading => _loader;

  UnmodifiableListView<Song> get songs => UnmodifiableListView(_data.songs);

  void _setLoader(bool value) {
    _loader = value;
    notifyListeners();
  }

  String? validateSong(String? value) {
    if (value?.isEmpty ?? true) return 'Informe o nome do áudio';
    for (var song in songs) {
      if (song.name == value) return 'Áudio já cadastrado.';
    }
    return null;
  }

  void saveCredentials({required String user, required String password}) {
    _setLoader(true);
    _storage.saveCredentials(user: user, password: password);
    _data.userCredential = user;
    _data.passwordCredential = password;
    _setLoader(false);
  }

  void addSong({required String label, required String name}) async {
    final song = Song(label: label, name: name, selected: _data.songs.isEmpty);

    final id = _storage.addSong(song: song);
    song.id = id;

    _data.songs.add(song);
    notifyListeners();
  }

  void removeSong({required Song song}) {
    _data.songs.removeWhere((s) => s.id == song.id);
    _storage.removeSong(song: song);
    notifyListeners();
  }

  void setDefaultSong({required Song song}) {
    for (var s in songs) {
      if (s.id == song.id) {
        s.selected = true;
      } else {
        s.selected = false;
      }
    }
    _storage.setDefaultSong(song: song);
    notifyListeners();
  }
}
