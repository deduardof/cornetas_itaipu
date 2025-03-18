import 'package:cornetas_itaipu/src/data/models/ip_address.dart';

class DataService {
  static DataService? _instance;
  // Avoid self instance
  DataService._();
  static DataService get instance => _instance ??= DataService._();

  final ips = <IpAddress>[];
  final audios = <String>[];
  String userCredential = '';
  String passwordCredential = '';
}
