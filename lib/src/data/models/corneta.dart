import 'package:cornetas_itaipu/src/data/models/ip_address.dart';
import 'package:flutter/material.dart';

enum CornetaStatus {
  ready(color: Colors.black, icon: Icons.play_arrow_outlined, text: 'Pronto'),
  playing(color: Colors.black, icon: Icons.pause_outlined, text: 'Executando'),
  success(color: Colors.green, icon: Icons.check_outlined, text: 'Sucesso'),
  error(color: Colors.red, icon: Icons.error_outline, text: 'Erro'),
  inative(color: Colors.grey, icon: Icons.link_off_outlined, text: 'Inativo');

  const CornetaStatus({required this.color, required this.icon, required this.text});
  final Color color;
  final IconData icon;
  final String text;

  static CornetaStatus getStatus(String value) {
    return switch (value) {
      'ready' => ready,
      'playing' => playing,
      'success' => success,
      'error' => error,
      'inative' => inative,
      _ => ready,
    };
  }
}

class Corneta {
  int id;
  String local;
  String name;
  IpAddress ip;
  String user;
  String password;
  String song;
  ValueNotifier<CornetaStatus> status;
  ValueNotifier<bool> selected = ValueNotifier(false);

  Corneta({
    this.id = 0,
    required this.local,
    required this.name,
    required this.ip,
    required this.user,
    required this.password,
    required this.song,
    required this.status,
  });
}
