import 'dart:collection';

import 'package:cornetas_itaipu/src/data/models/song.dart';
import 'package:cornetas_itaipu/src/data/services/data_service.dart';
import 'package:cornetas_itaipu/src/data/services/local_storage_service.dart';
import 'package:flutter/material.dart';

class SongsController extends ChangeNotifier {
  final _storage = LocalStorage.instance;
  final _data = DataService.instance;

  final bool _loader = false;
  bool get isLoading => _loader;

  UnmodifiableListView<Song> get songs => UnmodifiableListView(_data.songs);

  String? validateLabel(String? value) {
    if (value?.isEmpty ?? true) return 'Informe o nome do áudio';
    for (var song in songs) {
      if (song.label == value) return 'Este nome já está em uso';
    }
    return null;
  }

  String? validateName(String? value) {
    return (value?.isEmpty ?? true) ? 'Informe o nome do áudio' : null;
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

  void updateSong({required int id, required String label, required String name}) {
    final song = _data.songs.firstWhere((s) => s.id == id);
    song.label = label;
    song.name = name;
    _storage.updateSong(song: song);
    final index = _data.songs.indexWhere((s) => s.id == id);
    _data.songs[index] = song;
    notifyListeners();
  }
}
