import 'package:cornetas_itaipu/src/data/ip_address.dart';
import 'package:dio/dio.dart';

class CornetasService {
  final _dio = Dio();

  static CornetasService? _instance;
  // Avoid self instance
  CornetasService._();
  static CornetasService get instance => _instance ??= CornetasService._();

  Future<bool> sendSignal({required IpAddress ip, required String credentials}) async {
    // final credentials = base64.encode(utf8.encode('$usuario:$senha'));
    try {
      final response = await _dio.get(
        'http://${ip.toString()}/axis-cgi/playclip.cgi?clip=1', // Substitua '1' pelo clip desejado
        options: Options(
          method: 'GET',
          contentType: Headers.formUrlEncodedContentType,
          persistentConnection: true,
          headers: {'Authorization': 'Basic $credentials'},
        ),
      );

      if (response.statusCode == 200) {
        print('Corneta acionada com sucesso!');
        return true;
      } else {
        print('Erro ao acionar corneta: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
    }
    return false;
  }
}
