import 'package:cornetas_itaipu/src/controllers/cornetas_controller.dart';
import 'package:cornetas_itaipu/src/data/models/corneta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCornetaWidget extends StatefulWidget {
  const AddCornetaWidget({super.key, required this.controller});
  final CornetasController controller;

  @override
  State<AddCornetaWidget> createState() => _AddCornetaWidgetState();
}

class _AddCornetaWidgetState extends State<AddCornetaWidget> {
  final formKey = GlobalKey<FormState>();
  final labelController = TextEditingController();
  final ipController = TextEditingController();
  final groupController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    labelController.dispose();
    ipController.dispose();
    groupController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 800,
        height: 160,
        child: Form(
          key: formKey,
          child: Column(
            spacing: 10,
            children: [
              SizedBox(height: 20),
              Autocomplete<Corneta>(
                displayStringForOption: (corneta) => corneta.grupo,
                fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'Adicionar grupo',
                      prefixIcon: Icon(Icons.place_outlined),
                      fillColor: Theme.of(context).colorScheme.onTertiary,
                      filled: true,
                    ),
                  );
                },
                optionsBuilder: (value) {
                  groupController.text = value.text;
                  if (value.text.isEmpty) return <Corneta>[];
                  return widget.controller.cornetas.where((corneta) => corneta.grupo.contains(value.text)).toList();
                },
                onSelected: (option) => groupController.text = option.grupo,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: TextFormField(
                      controller: labelController,
                      validator: widget.controller.validateLabel,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.campaign_outlined),
                        fillColor: Theme.of(context).colorScheme.onTertiary,
                        filled: true,
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    flex: 2,
                    child: TextFormField(
                      controller: ipController,
                      validator: widget.controller.validateIP,
                      decoration: InputDecoration(
                        labelText: 'IP',
                        prefixIcon: Icon(Icons.lan_outlined),
                        fillColor: Theme.of(context).colorScheme.onTertiary,
                        filled: true,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]")), LengthLimitingTextInputFormatter(15)],
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: double.maxFinite,
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            final group = groupController.text.trim();
                            final label = labelController.text.trim();
                            final ip = ipController.text;
                            widget.controller.addCorneta(group: group, label: label, ip: ip);
                            groupController.clear();
                            labelController.clear();
                            ipController.clear();
                          }
                        },
                        icon: Icon(Icons.add),
                        label: Text('Adicionar'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
