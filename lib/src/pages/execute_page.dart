import 'package:cornetas_itaipu/src/controllers/execute_controller.dart';
import 'package:flutter/material.dart';

class ExecutePage extends StatefulWidget {
  const ExecutePage({super.key});

  @override
  State<ExecutePage> createState() => _ExecutePageState();
}

class _ExecutePageState extends State<ExecutePage> {
  final controller = ExecuteController();
  /*   final logController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Logger.instance.addListener(_listener);
    logController.text = Logger.instance.text;
  }

  void _listener() {
    logController.text = Logger.instance.text;
  }

  @override
  void dispose() {
    super.dispose();
    logController.dispose();
    Logger.instance.removeListener(_listener);
  } */

  @override
  void initState() {
    super.initState();
    controller.isPlaying.addListener(() {
      print('isPlaying: ${controller.isPlaying.value}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 800,
        child: Column(
          children: [
            Flexible(
              child: ListView.separated(
                itemCount: controller.cornetas.length,
                itemBuilder: (_, index) {
                  final corneta = controller.cornetas[index];
                  return ExpansionTile(
                    collapsedBackgroundColor: Colors.white,
                    backgroundColor: Colors.white,
                    collapsedShape: Border(bottom: BorderSide(color: Colors.grey)),
                    leading: ValueListenableBuilder(
                      valueListenable: corneta.selected,
                      builder:
                          (_, isSelected, _) => Checkbox(
                            value: isSelected,
                            onChanged: (_) {
                              corneta.selected.value = !isSelected;
                              for (var c in corneta.cornetas) {
                                c.selected.value = corneta.selected.value;
                              }
                            },
                          ),
                    ),
                    title: Text(
                      corneta.local,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.tertiary),
                    ),
                    children:
                        corneta.cornetas.map((c) {
                          return ValueListenableBuilder(
                            valueListenable: c.status,
                            builder:
                                (_, status, _) => ListTile(
                                  contentPadding: EdgeInsets.only(left: 30, right: 20),
                                  leading: ValueListenableBuilder(
                                    valueListenable: c.selected,
                                    builder: (_, isSelected, _) {
                                      return Checkbox(
                                        value: isSelected,
                                        onChanged: (_) {
                                          c.selected.value = !isSelected;
                                          corneta.selected.value = corneta.cornetas.every((cor) => cor.selected.value);
                                        },
                                      );
                                    },
                                  ),
                                  title: Text(c.name, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                                  subtitle: Text(c.ip.toString()),
                                  tileColor: Colors.grey[100],
                                  trailing: IconButton(
                                    onPressed: () async {
                                      await controller.execute(corneta: c);
                                    },
                                    icon: Icon(c.status.value.icon, color: c.status.value.color),
                                  ),
                                  shape: Border(top: BorderSide(color: Colors.grey)),
                                ),
                          );
                        }).toList(),
                  );
                },
                separatorBuilder: (context, index) => Divider(height: 0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: FilledButton.icon(
                        onPressed: () async {
                          print('Stop all playing');
                          controller.stopAllPlaying();
                          print('Finished stop all playing');
                        },
                        label: Text('Cancelar todos'),
                        icon: Icon(Icons.cancel_outlined),
                        style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: ValueListenableBuilder(
                        valueListenable: controller.isPlaying,
                        builder:
                            (_, isPlaying, _) => FilledButton.icon(
                              onPressed:
                                  (isPlaying)
                                      ? null
                                      : () async {
                                        print('Start playing');
                                        await controller.executeSelected();
                                        print('Finished playing');
                                      },
                              label: (isPlaying) ? CircularProgressIndicator() : Text('Executar selecionados'),
                              icon: (isPlaying) ? null : Icon(Icons.play_arrow_outlined),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    /* ListenableBuilder(
      listenable: controller,
      builder:
          (_, _) => ListView.builder(
            itemCount: controller.cornetas.length,
            itemBuilder: (_, index) {
              final corneta = controller.cornetas[index];
              return ListTile(
                leading: Text(corneta.local),
                title: Text(corneta.name),
                subtitle: Text(corneta.ip.toString()),
                tileColor: Colors.white,
                trailing:
                    (corneta.status == CornetaStatus.running)
                        ? CircularProgressIndicator()
                        : IconButton(
                          onPressed: () async {
                            await controller.execute(corneta: corneta);
                          },
                          icon: Icon(Icons.play_arrow_outlined),
                        ),
              );
            },
          ),
    ); */

    /* Column(
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: logController,
              expands: true,
              minLines: null,
              maxLines: null,
              readOnly: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                labelText: 'Log de execução',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                suffixIcon: IconButton(
                  onPressed: () {
                    Logger.instance.clear();
                  },
                  icon: Icon(Icons.delete_forever_outlined, size: 36, color: Colors.red[800]),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.maxFinite,
          height: 80,
          child: Padding(
            padding: const EdgeInsets.only(top: 0, left: 20.0, bottom: 20.0, right: 20.0),
            child: FilledButton.icon(
              onPressed: () async {
                final user = DataService.instance.userCredential;
                final password = DataService.instance.passwordCredential;
                for (var corneta in DataService.instance.cornetas) {
                  await CornetasService.instance.sendSignal(ip: corneta.ip, user: user, password: password);
                }
              },
              label: Text('Executar'),
              icon: Icon(Icons.campaign_outlined),
            ),
          ),
        ),
      ],
    ); */
  }
}
