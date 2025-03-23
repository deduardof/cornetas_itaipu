import 'package:cornetas_itaipu/src/data/models/corneta.dart';
import 'package:cornetas_itaipu/src/data/services/logger_service.dart';
import 'package:http_auth/http_auth.dart' as http_auth;

class CornetasService {
  static CornetasService? _instance;
  // Avoid self instance
  CornetasService._();
  static CornetasService get instance => _instance ??= CornetasService._();

  Future<bool> play({required Corneta corneta}) async {
    final url = 'http://${corneta.ip.toString()}/axis-cgi/playclip.cgi?location=${corneta.song}&repeat=0&volume=100&audiooutput=1';

    Logger.instance.write(' -> Enviando sinal para corneta');
    Logger.instance.write('URL: $url');

    try {
      var client = http_auth.DigestAuthClient(corneta.user, corneta.password);
      var response = await client.get(Uri.parse(url)).timeout(Duration(seconds: 3));

      Logger.instance.write(response.toString());

      if (response.statusCode == 200) {
        Logger.instance.write('Corneta acionada com sucesso!');
        return true;
      } else {
        Logger.instance.write('Erro ao acionar corneta: ${response.statusCode}');
        Logger.instance.write(response.body);
      }
    } catch (e) {
      Logger.instance.write('[CornetasService:play] Erro ao acionar corneta: $e');
    }
    return false;
  }

  Future<bool> stop({required Corneta corneta}) async {
    try {
      // http://<servername>/axis-cgi/stopclip.cgi
      Logger.instance.write(' -> Enviando sinal para cancelar corneta');
      final url = 'http://${corneta.ip.toString()}/axis-cgi/stopclip.cgi';

      final client = http_auth.DigestAuthClient(corneta.user, corneta.password);
      final response = await client.get(Uri.parse(url)).timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        Logger.instance.write('Corneta ${corneta.name} parada com sucesso!');
        return true;
      } else {
        Logger.instance.write('Erro ao cancelar corneta: ${response.statusCode}');
        Logger.instance.write(response.body);
      }
    } catch (e) {
      Logger.instance.write('[CornetasService:stop] Erro ao cancelar corneta: $e');
    }
    return false;
  }
}
