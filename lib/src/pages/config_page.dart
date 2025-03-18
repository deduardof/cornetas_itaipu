import 'package:cornetas_itaipu/src/controllers/config_controller.dart';
import 'package:cornetas_itaipu/src/pages/components/audios_widget.dart';
import 'package:cornetas_itaipu/src/pages/components/credentials_widget.dart';
import 'package:flutter/material.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final controller = ConfigController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 800,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [CredentialsWidget(controller: controller), AudiosWidget(controller: controller)],
        ),
      ),
    );
  }
}
