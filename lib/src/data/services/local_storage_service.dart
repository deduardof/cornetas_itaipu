import 'package:cornetas_itaipu/src/data/models/ip_address.dart';
import 'package:cornetas_itaipu/src/data/services/logger_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static LocalStorage? _instance;

  final _prefs = SharedPreferencesAsync();
  // Avoid self instance
  LocalStorage._();
  static LocalStorage get instance => _instance ??= LocalStorage._();

  Future<void> setIPs({required List<IpAddress> ips}) async {
    final list = ips.map((ip) => ip.toString()).toList();
    await _prefs.setStringList('ips', list);
    Logger.instance.write(' -> Atualizado IPs de acesso.');
  }

  Future<List<IpAddress>> getAllIpAddress() async {
    try {
      final response = await _prefs.getStringList('ips');
      Logger.instance.write(' -> Recuperado lista de IPs de acesso.');
      return (response != null && response.isNotEmpty) ? response.map(IpAddress.fromString).toList() : <IpAddress>[];
    } on TypeError catch (e) {
      Logger.instance.write(e.toString());
      return <IpAddress>[];
    }
  }

  Future<void> saveCredentials({required String user, required String password}) async {
    try {
      await _prefs.setString('userCredential', user);
      await _prefs.setString('passCredential', password);
      Logger.instance.write(' -> Salvo credenciais de acesso.');
    } catch (e) {
      Logger.instance.write(e.toString());
    }
  }

  Future<({String user, String password})> getCredentials() async {
    try {
      final user = await _prefs.getString('userCredential');
      final password = await _prefs.getString('passCredential');
      Logger.instance.write(' -> Recuperado credenciais de acesso.');
      return (user: user ?? '', password: password ?? '');
    } catch (e) {
      Logger.instance.write(e.toString());
      return (user: '', password: '');
    }
  }

  Future<void> saveAudios({required List<String> audios}) async {
    try {
      await _prefs.setStringList('audios', audios);
    } catch (e) {
      Logger.instance.write(e.toString());
    }
  }

  Future<List<String>> getAudios() async {
    try {
      final response = await _prefs.getStringList('audios');
      return (response != null) ? response : <String>[];
    } catch (e) {
      Logger.instance.write(e.toString());
      return <String>[];
    }
  }
}
