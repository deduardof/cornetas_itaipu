import 'package:cornetas_itaipu/src/data/ip_address.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static LocalStorage? _instance;

  final _prefs = SharedPreferencesAsync();
  // Avoid self instance
  LocalStorage._();
  static LocalStorage get instance => _instance ??= LocalStorage._();

  Future<void> addAllIPs({required List<IpAddress> ips}) async {
    final list = ips.map((ip) => ip.toString()).toList();
    await _prefs.setStringList('ips', list);
  }

  Future<List<IpAddress>> getAllIpAddress() async {
    try {
      final response = await _prefs.getStringList('ips');
      return (response != null && response.isNotEmpty) ? response.map(IpAddress.fromString).toList() : <IpAddress>[];
    } on TypeError catch (e) {
      print(e.toString());
      return <IpAddress>[];
    }
  }

  Future<void> saveCredentials({required String user, required String password}) async {
    try {
      await _prefs.setString('userCredential', user);
      await _prefs.setString('passCredential', password);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<({String user, String password})> getCredentials() async {
    try {
      final user = await _prefs.getString('userCredential');
      final password = await _prefs.getString('passCredential');
      return (user: user ?? '', password: password ?? '');
    } catch (e) {
      print(e.toString());
      return (user: '', password: '');
    }
  }
}
