import 'package:cornetas_itaipu/src/controllers/songs_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({super.key});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  final formKey = GlobalKey<FormState>();
  final labelController = TextEditingController();
  final nameController = TextEditingController();
  final controller = SongsController();
  int editingId = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: 800,
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: [
                  Text('Sons da Corneta', style: Theme.of(context).textTheme.titleLarge),
                  TextFormField(
                    controller: labelController,
                    decoration: InputDecoration(prefixIcon: Icon(Icons.audiotrack_outlined), labelText: 'Nome'),
                    validator: controller.validateLabel,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).nextFocus();
                    },
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(prefixIcon: Icon(Icons.audiotrack_outlined), labelText: 'Nome do arquivo'),
                    validator: controller.validateName,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[-a-zA-Z0-9_.]"))],
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          final label = labelController.text.trim();
                          final name = nameController.text.trim();
                          if (editingId == 0) {
                            controller.addSong(label: label, name: name);
                          } else {
                            controller.updateSong(id: editingId, label: label, name: name);
                            editingId = 0;
                          }
                          labelController.clear();
                          nameController.clear();
                        }
                      },
                      label: Text('Salvar'),
                      icon: Icon(Icons.check),
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(child: Divider(endIndent: 20)),
                      Text('Sons cadastrados', style: Theme.of(context).textTheme.titleLarge),
                      Flexible(child: Divider(indent: 20)),
                    ],
                  ),
                  ListenableBuilder(
                    listenable: controller,
                    builder:
                        (_, _) =>
                            (controller.songs.isEmpty)
                                ? Center(child: Text('Não há áudios cadastrados.'))
                                : Flexible(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.songs.length,
                                    itemBuilder: (_, index) {
                                      final song = controller.songs[index];
                                      return Center(
                                        child: ListTile(
                                          title: RichText(
                                            text: TextSpan(
                                              text: song.label,
                                              style:
                                                  (song.selected)
                                                      ? TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.tertiary)
                                                      : TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                                              children: [
                                                TextSpan(
                                                  text: ' - ${song.name}',
                                                  style: TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic),
                                                ),
                                              ],
                                            ),
                                          ),
                                          tileColor:
                                              (song.selected) ? Theme.of(context).colorScheme.tertiaryFixed : Theme.of(context).colorScheme.onPrimary,
                                          leading: (song.selected) ? Icon(Icons.check, color: Theme.of(context).colorScheme.tertiary) : null,
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            spacing: 10,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  editingId = song.id;
                                                  labelController.text = song.label;
                                                  nameController.text = song.name;
                                                },
                                                icon: Icon(Icons.edit_outlined, color: Theme.of(context).colorScheme.primary),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  controller.removeSong(song: song);
                                                  if (controller.songs.isNotEmpty) {
                                                    controller.setDefaultSong(song: controller.songs.first);
                                                  }
                                                },
                                                icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                                              ),
                                            ],
                                          ),
                                          shape: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                                          onTap: () {
                                            controller.setDefaultSong(song: song);
                                          },
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
      ),
    );
  }
}
