import 'package:cornetas_itaipu/src/data/models/corneta.dart';
import 'package:cornetas_itaipu/src/data/models/ip_address.dart';
import 'package:cornetas_itaipu/src/data/models/song.dart';
import 'package:cornetas_itaipu/src/data/services/logger_service.dart';
import 'package:flutter/foundation.dart';
import 'package:sqlite3/sqlite3.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static LocalStorage? _instance;
  final _database = sqlite3.open('cornetas_itaipu.db');
  // final _prefs = SharedPreferencesAsync();
  // Avoid self instance
  LocalStorage._();
  static LocalStorage get instance => _instance ??= LocalStorage._();

  void init() {
    _database.execute('''
      CREATE TABLE IF NOT EXISTS credentials (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user TEXT,
        password TEXT
      );
    ''');

    _database.execute('''
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        label TEXT,
        name TEXT,
        selected INTEGER
      );
    ''');

    _database.execute('''
      CREATE TABLE IF NOT EXISTS cornetas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        local TEXT,
        name TEXT,
        ip TEXT,
        user TEXT,
        password TEXT,
        song TEXT,
        status TEXT
      );
    ''');

    final response = _database.select('SELECT id FROM credentials;');
    if (response.isEmpty) {
      _database.prepare('INSERT INTO credentials (user, password) VALUES (?, ?);').execute(['', '']);
    }
  }

  void saveCredentials({required String user, required String password}) {
    try {
      _database.prepare('UPDATE credentials SET user = ?, password = ? WHERE id = 1;').execute([user, password]);
      Logger.instance.write(' -> Salvo credenciais de acesso.');
    } catch (e) {
      Logger.instance.write(e.toString());
    }
  }

  ({String user, String password}) getCredentials() {
    try {
      final response = _database.select('SELECT user, password FROM credentials WHERE id = 1;');
      if (response.isNotEmpty) {
        final user = response.first['user'] as String;
        final password = response.first['password'] as String;
        Logger.instance.write(' -> Recuperado credenciais de acesso.');
        return (user: user, password: password);
      }
    } catch (e) {
      Logger.instance.write(e.toString());
    }
    return (user: '', password: '');
  }

  int addSong({required Song song}) {
    try {
      _database.prepare('INSERT INTO songs (label, name, selected) VALUES (?, ?, ?);').execute([song.label, song.name, song.selected ? 1 : 0]);
      Logger.instance.write(' -> Adicionado som: ${song.name}');
      return _database.lastInsertRowId;
    } catch (e) {
      Logger.instance.write(e.toString());
    }
    return 0;
  }

  void updateSong({required Song song}) {
    try {
      _database.prepare('UPDATE songs SET label = ?, name = ?, selected = ? WHERE id = ?;').execute([
        song.label,
        song.name,
        song.selected ? 1 : 0,
        song.id,
      ]);
      Logger.instance.write(' -> Atualizado som: ${song.name}');
    } catch (e) {
      Logger.instance.write(e.toString());
    }
  }

  void removeSong({required Song song}) {
    try {
      _database.prepare('DELETE FROM songs WHERE id = ?;').execute([song.id]);
      Logger.instance.write(' -> Removido som: ${song.name}');
    } catch (e) {
      Logger.instance.write(e.toString());
    }
  }

  List<Song> getSongs() {
    final songs = <Song>[];
    try {
      final response = _database.select('SELECT id, label, name, selected FROM songs;');
      for (var song in response) {
        songs.add(Song(id: song['id'] as int, label: song['label'] as String, name: song['name'] as String, selected: song['selected'] as int == 1));
      }
      Logger.instance.write(' -> Recuperado ${songs.length} sons.');
    } catch (e) {
      Logger.instance.write(e.toString());
    }
    return songs;
  }

  int addCorneta({required Corneta corneta}) {
    try {
      _database.prepare('INSERT INTO cornetas (local, name, ip, user, password, song, status) VALUES (?, ?, ?, ?, ?, ?, ?);').execute([
        corneta.local,
        corneta.name,
        corneta.ip.toString(),
        corneta.user,
        corneta.password,
        corneta.song,
        corneta.status.toString(),
      ]);
      Logger.instance.write(' -> Adicionado corneta: ${corneta.name}');
      return _database.lastInsertRowId;
    } catch (e) {
      Logger.instance.write(e.toString());
    }
    return 0;
  }

  void updateCorneta({required Corneta corneta}) {
    try {
      _database.prepare('UPDATE cornetas SET local = ?, name = ?, ip = ?, user = ?, password = ?, song = ?, status = ? WHERE id = ?;').execute([
        corneta.local,
        corneta.name,
        corneta.ip.toString(),
        corneta.user,
        corneta.password,
        corneta.song,
        corneta.status.toString(),
        corneta.id,
      ]);
      Logger.instance.write(' -> Atualizado corneta: ${corneta.name}');
    } catch (e) {
      Logger.instance.write(e.toString());
    }
  }

  void removeCorneta({required Corneta corneta}) {
    try {
      _database.prepare('DELETE FROM cornetas WHERE id = ?;').execute([corneta.id]);
      Logger.instance.write(' -> Removido corneta: ${corneta.name}');
    } catch (e) {
      Logger.instance.write(e.toString());
    }
  }

  List<Corneta> getCornetas() {
    final cornetas = <Corneta>[];
    try {
      final response = _database.select('SELECT id, local, name, ip, user, password, song, status FROM cornetas;');
      for (var corneta in response) {
        cornetas.add(
          Corneta(
            id: corneta['id'] as int,
            local: corneta['local'] as String,
            name: corneta['name'] as String,
            ip: IpAddress.fromString(corneta['ip'] as String),
            user: corneta['user'] as String,
            password: corneta['password'] as String,
            song: corneta['song'] as String,
            status: ValueNotifier(CornetaStatus.getStatus(corneta['status'] as String)),
          ),
        );
      }
      Logger.instance.write(' -> Recuperado ${cornetas.length} cornetas.');
    } catch (e) {
      Logger.instance.write(e.toString());
    }
    return cornetas;
  }

  void setDefaultSong({required Song song}) {
    try {
      _database.prepare('UPDATE songs SET selected = 0;').execute([]);
      _database.prepare('UPDATE songs SET selected = 1 WHERE id = ?;').execute([song.id]);
      Logger.instance.write(' -> Áudio padrão definido: ${song.name}');
    } catch (e) {
      Logger.instance.write(e.toString());
    }
  }

  void dispose() {
    Logger.instance.write(' -> Closing database...');
    _database.dispose();
  }
}
