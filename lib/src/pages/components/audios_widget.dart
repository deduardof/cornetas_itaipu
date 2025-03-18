import 'package:cornetas_itaipu/src/controllers/config_controller.dart';
import 'package:flutter/material.dart';

class AudiosWidget extends StatefulWidget {
  const AudiosWidget({super.key, required this.controller});
  final ConfigController controller;

  @override
  State<AudiosWidget> createState() => _AudiosWidgetState();
}

class _AudiosWidgetState extends State<AudiosWidget> {
  final formKey = GlobalKey<FormState>();
  final audioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 800,
        height: 400,
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                Row(
                  children: [
                    Flexible(child: Divider(endIndent: 20)),
                    Text('Áudios', style: Theme.of(context).textTheme.titleLarge),
                    Flexible(child: Divider(indent: 20)),
                  ],
                ),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: audioController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.audiotrack_outlined),
                      labelText: 'Áudio disponível para sirene',
                      suffixIcon: IconButton(
                        onPressed: () async {
                          if (formKey.currentState?.validate() ?? false) {
                            await widget.controller.addAudio(audio: audioController.text.trim());
                            audioController.clear();
                          }
                        },
                        icon: Icon(Icons.add),
                      ),
                    ),
                    validator: widget.controller.validateAudio,
                  ),
                ),
                ListenableBuilder(
                  listenable: widget.controller,
                  builder:
                      (_, _) =>
                          (widget.controller.audios.isEmpty)
                              ? Center(child: Text('Não há áudios cadastrados.'))
                              : Flexible(
                                child: ListView.builder(
                                  itemCount: widget.controller.audios.length,
                                  itemBuilder: (_, index) {
                                    final audio = widget.controller.audios[index];
                                    return Center(
                                      child: ListTile(
                                        title: Text(audio),
                                        tileColor: Colors.white,
                                        trailing: IconButton(
                                          onPressed: () async {
                                            await widget.controller.removeAudio(index: index);
                                          },
                                          icon: Icon(Icons.delete_outline, color: Colors.red),
                                        ),
                                        shape: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
