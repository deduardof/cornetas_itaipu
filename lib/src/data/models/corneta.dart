import 'package:cornetas_itaipu/src/data/models/ip_address.dart';
import 'package:flutter/material.dart';

enum CornetaStatus {
  ready(color: Colors.grey),
  running(color: Colors.grey),
  success(color: Colors.green),
  error(color: Colors.red),
  inative(color: Colors.grey);

  const CornetaStatus({required this.color});
  final Color color;
}

class Corneta {
  final String grupo;
  final String nome;
  final IpAddress ip;
  final CornetaStatus status;

  Corneta({required this.grupo, required this.nome, required this.ip, this.status = CornetaStatus.ready});
}
