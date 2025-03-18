import 'package:cornetas_itaipu/src/controllers/cornetas_controller.dart';
import 'package:flutter/material.dart';

class ListCornetasWidget extends StatefulWidget {
  const ListCornetasWidget({super.key, required this.controller});
  final CornetasController controller;

  @override
  State<ListCornetasWidget> createState() => _ListCornetasWidgetState();
}

class _ListCornetasWidgetState extends State<ListCornetasWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 800,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 10.0, bottom: 8.0),
              child: Text('Cornetas cadastradas', style: Theme.of(context).textTheme.titleLarge),
            ),
            Divider(height: 0),
            ListenableBuilder(
              listenable: widget.controller,
              builder:
                  (_, _) =>
                      (widget.controller.cornetas.isEmpty)
                          ? Center(child: Text('Não há cornetas cadastradas.'))
                          : Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.controller.cornetas.length,
                              itemBuilder: (_, index) {
                                final corneta = widget.controller.cornetas[index];
                                return ListTile(
                                  leading: SizedBox(
                                    width: 200,
                                    child: Text(corneta.grupo, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                                  ),
                                  title: Text(corneta.nome),
                                  subtitle: Text(corneta.ip.toString()),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Deseja remover a corneta IP: ${corneta.nome}?',
                                              style: Theme.of(context).textTheme.titleLarge,
                                            ),
                                            titlePadding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                                            actionsAlignment: MainAxisAlignment.spaceEvenly,
                                            actions: [
                                              OutlinedButton.icon(onPressed: Navigator.of(context).pop, label: Text('Cancelar')),
                                              FilledButton.icon(
                                                onPressed: () {
                                                  widget.controller.remove(index);
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
      ),
    );
  }
}
