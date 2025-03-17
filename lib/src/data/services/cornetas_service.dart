import 'package:cornetas_itaipu/src/data/models/ip_address.dart';
import 'package:cornetas_itaipu/src/data/services/logger_service.dart';
import 'package:http_auth/http_auth.dart' as http_auth;

class CornetasService {
  static CornetasService? _instance;
  // Avoid self instance
  CornetasService._();
  static CornetasService get instance => _instance ??= CornetasService._();

  Future<bool> sendSignal({required IpAddress ip, required String user, required String password}) async {
    // final credentials = base64.encode(utf8.encode('$usuario:$senha'));
    //http://evac:hornevac2025@172.27.12.200/axis-cgi/playclip.cgi?location=ding_dong.mp3&repeat=0&volume=100&audiooutput=1

    Logger.instance.write(' -> Enviando sinal para corneta');

    final url = 'http://${ip.toString()}/axis-cgi/playclip.cgi?location=ding_dong.mp3&repeat=0&volume=100&audiooutput=1';

    Logger.instance.write('URL: $url');

    try {
      var client = http_auth.DigestAuthClient(user, password);
      var response = await client.get(Uri.parse(url));

      Logger.instance.write(response.toString());

      if (response.statusCode == 200) {
        Logger.instance.write('Corneta acionada com sucesso!');
        return true;
      } else {
        Logger.instance.write('Erro ao acionar corneta: ${response.statusCode}');
        Logger.instance.write(response.body);
      }
    } catch (e) {
      Logger.instance.write(e.toString());
    }
    return false;
  }
}
