import 'package:cornetas_itaipu/src/controllers/cornetas_controller.dart';
import 'package:cornetas_itaipu/src/pages/components/add_corneta_widget.dart';
import 'package:cornetas_itaipu/src/pages/components/list_cornetas_widget.dart';
import 'package:flutter/material.dart';

class CornetasPage extends StatefulWidget {
  const CornetasPage({super.key});

  @override
  State<CornetasPage> createState() => _CornetasPageState();
}

class _CornetasPageState extends State<CornetasPage> {
  final controller = CornetasController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(width: 800, child: Column(children: [AddCornetaWidget(controller: controller), ListCornetasWidget(controller: controller)])),
    );
  }
}
