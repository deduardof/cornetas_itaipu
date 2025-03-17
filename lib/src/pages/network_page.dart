import 'package:cornetas_itaipu/src/controllers/network_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NetworkPage extends StatefulWidget {
  const NetworkPage({super.key});

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  final formKey = GlobalKey<FormState>();
  final controller = NetworkController();
  final addController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.init();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    addController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: addController,
              validator: controller.validateIP,
              decoration: InputDecoration(
                labelText: 'Adicionar IP da corneta',
                prefixIcon: Icon(Icons.lan_outlined),
                suffixIcon: IconButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      controller.addCorneta(value: addController.text.trim());
                      addController.clear();
                    }
                  },
                  icon: Icon(Icons.add),
                ),
                fillColor: Theme.of(context).colorScheme.onTertiary,
                filled: true,
              ),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]")), LengthLimitingTextInputFormatter(15)],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 10.0, bottom: 8.0),
            child: Text('Cornetas cadastradas', style: Theme.of(context).textTheme.titleLarge),
          ),
          Divider(height: 0),
          ListenableBuilder(
            listenable: controller,
            builder:
                (_, _) => Flexible(
                  child: ListView.builder(
                    itemCount: controller.cornetas.length,
                    itemBuilder: (_, index) {
                      final corneta = controller.cornetas[index];
                      return ListTile(
                        title: Text(corneta.toString()),
                        trailing: IconButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Deseja remover a corneta IP: ${corneta.toString()}?', style: Theme.of(context).textTheme.titleLarge),
                                  titlePadding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                                  actionsAlignment: MainAxisAlignment.spaceEvenly,
                                  actions: [
                                    OutlinedButton.icon(onPressed: Navigator.of(context).pop, label: Text('Cancelar')),
                                    FilledButton.icon(
                                      onPressed: () {
                                        controller.remove(index);
                                        Navigator.of(context).pop();
                                      },
                                      label: Text('Remover'),
                                      icon: Icon(Icons.delete_outline),
                                      style: OutlinedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                                    ),
                                  ],
                                );
                              },
                            );
                            // controller.remove(index);
                          },
                          icon: Icon(Icons.delete_outline, color: Colors.red),
                        ),
                        tileColor: Theme.of(context).colorScheme.onPrimary,
                        shape: Border(bottom: BorderSide(color: Colors.black12)),
                      );
                    },
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
