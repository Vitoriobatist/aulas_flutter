// lib/database/location_service.dart

import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Verifica permissões e retorna a posição atual do dispositivo.
  /// Lança exceção com mensagem amigável em caso de erro.
  static Future<Position> obterPosicaoAtual() async {
    try {
      // 1. Verifica se a localização está habilitada no dispositivo
      final servicoAtivo = await Geolocator.isLocationServiceEnabled();
      if (!servicoAtivo) {
        throw Exception(
          'Localização desativada. Ative a localização nas configurações do sistema.',
        );
      }

      // 2. Verifica permissão de localização
      LocationPermission permissao = await Geolocator.checkPermission();

      if (permissao == LocationPermission.denied) {
        // Solicita permissão ao usuário
        permissao = await Geolocator.requestPermission();
        if (permissao == LocationPermission.denied) {
          throw Exception(
            'Permissão de localização negada. O app precisa de acesso à localização.',
          );
        }
      }

      if (permissao == LocationPermission.deniedForever) {
        throw Exception(
          'Permissão de localização bloqueada permanentemente. '
          'Acesse as configurações do app para liberar.',
        );
      }

      // 3. Obtém a posição atual com boa precisão
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      final mensagem = e.toString();
      if (mensagem.contains('org.freedesktop.DBus.Error.ServiceUnknown') ||
          mensagem.contains('org.freedesktop.GeoClue2')) {
        throw Exception(
          'Serviço de localização do Linux não encontrado. '
          'Instale/ative o GeoClue para usar localização no desktop.',
        );
      }

      rethrow;
    }
  }
}
