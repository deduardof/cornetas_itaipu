import 'package:cornetas_itaipu/src/data/models/corneta.dart';
import 'package:cornetas_itaipu/src/data/models/song.dart';

class DataService {
  static DataService? _instance;
  // Avoid self instance
  DataService._();
  static DataService get instance => _instance ??= DataService._();

  final cornetas = <Corneta>[];
  final songs = <Song>[];
  String userCredential = '';
  String passwordCredential = '';
}
