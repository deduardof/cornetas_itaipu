import 'package:cornetas_itaipu/src/controllers/cornetas_controller.dart';
import 'package:cornetas_itaipu/src/data/models/corneta.dart';
import 'package:cornetas_itaipu/src/data/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CornetasPage extends StatefulWidget {
  const CornetasPage({super.key});

  @override
  State<CornetasPage> createState() => _CornetasPageState();
}

class _CornetasPageState extends State<CornetasPage> {
  final formKey = GlobalKey<FormState>();
  final controller = CornetasController();
  final localController = TextEditingController();
  final labelController = TextEditingController();
  final ipController = TextEditingController();
  final userController = TextEditingController();
  final passController = TextEditingController();
  final songController = TextEditingController();
  final lock = ValueNotifier(true);
  final passVisibility = ValueNotifier(false);
  final isEditing = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    final data = DataService.instance;
    userController.text = data.userCredential;
    passController.text = data.passwordCredential;
    if (data.songs.isNotEmpty) {
      songController.text = data.songs.firstWhere((s) => s.selected).name;
    }
  }

  @override
  void dispose() {
    super.dispose();
    localController.dispose();
    labelController.dispose();
    ipController.dispose();
    userController.dispose();
    passController.dispose();
    songController.dispose();
    lock.dispose();
    passVisibility.dispose();
    isEditing.dispose();
    controller.dispose();
  }

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
                spacing: 10,
                children: [
                  ValueListenableBuilder(
                    valueListenable: isEditing,
                    builder: (_, isEdit, _) => Text('${isEdit ? 'Alterar' : 'Cadastrar'} corneta', style: Theme.of(context).textTheme.titleLarge),
                  ),
                  Autocomplete<Corneta>(
                    displayStringForOption: (corneta) => corneta.local,
                    fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                      textEditingController = localController;
                      return TextFormField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(labelText: 'Local', prefixIcon: Icon(Icons.place_outlined)),
                        validator: controller.validateLocal,
                      );
                    },
                    optionsBuilder: (value) {
                      localController.text = value.text;
                      if (value.text.isEmpty) return <Corneta>[];
                      return controller.getCornetasWhere(value: value.text);
                    },
                    onSelected: (option) => localController.text = option.local,
                  ),
                  TextFormField(
                    controller: labelController,
                    validator: controller.validateLabel,
                    decoration: InputDecoration(labelText: 'Nome', prefixIcon: Icon(Icons.campaign_outlined)),
                    keyboardType: TextInputType.text,
                  ),
                  TextFormField(
                    controller: ipController,
                    validator: controller.validateIP,
                    decoration: InputDecoration(
                      labelText: 'IP',
                      prefixIcon: Icon(Icons.lan_outlined),
                      suffixIcon: IconButton(
                        onPressed: () {
                          final text = ipController.text.trim();
                          final corneta = controller.getCornetaByIp(text: text);
                          if (corneta != null) {
                            localController.text = corneta.local;
                            labelController.text = corneta.name;
                            ipController.text = corneta.ip.toString();
                            userController.text = corneta.user;
                            passController.text = corneta.password;
                            songController.text = corneta.song;
                            isEditing.value = true;
                          }
                        },
                        icon: Icon(Icons.search),
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]")), LengthLimitingTextInputFormatter(15)],
                  ),
                  ValueListenableBuilder(
                    valueListenable: controller.message,
                    builder:
                        (_, message, _) =>
                            (message.isNotEmpty)
                                ? Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text(message, style: Theme.of(context).inputDecorationTheme.errorStyle),
                                  ),
                                )
                                : SizedBox.shrink(),
                  ),
                  // SizedBox(height: 10),
                  ExpansionTile(
                    title: Text('Configurações de acesso', style: Theme.of(context).textTheme.titleLarge),
                    collapsedBackgroundColor: Theme.of(context).colorScheme.onSecondary,
                    collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    children: [
                      SizedBox(height: 10),
                      ValueListenableBuilder(
                        valueListenable: lock,
                        builder: (_, isLocked, child) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                lock.value = !lock.value;
                              },
                              label: Text((isLocked) ? 'Desbloquear' : 'Bloquear'),
                              icon: Icon((isLocked) ? Icons.lock_open_outlined : Icons.lock_outline),
                              style: OutlinedButton.styleFrom(fixedSize: Size(160, 40)),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      ValueListenableBuilder(
                        valueListenable: lock,
                        builder:
                            (_, isLocked, _) => Column(
                              spacing: 10,
                              children: [
                                TextFormField(
                                  controller: userController,
                                  validator: controller.validateLabel,
                                  enabled: !lock.value,
                                  decoration: InputDecoration(
                                    labelText: 'Usuário',
                                    prefixIcon: Icon(Icons.person_outline),
                                    fillColor: Theme.of(context).colorScheme.onTertiary,
                                    filled: true,
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                                ValueListenableBuilder(
                                  valueListenable: passVisibility,
                                  builder: (_, visibility, child) {
                                    return TextFormField(
                                      controller: passController,
                                      validator: controller.validateLabel,
                                      enabled: !lock.value,
                                      obscureText: !visibility,
                                      decoration: InputDecoration(
                                        labelText: 'Senha',
                                        prefixIcon: Icon(Icons.key),
                                        suffixIcon: IconButton(
                                          icon: Icon((visibility) ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                                          onPressed: () {
                                            passVisibility.value = !passVisibility.value;
                                          },
                                        ),
                                        fillColor: Theme.of(context).colorScheme.onTertiary,
                                        filled: true,
                                      ),
                                      keyboardType: TextInputType.text,
                                    );
                                  },
                                ),
                                TextFormField(
                                  controller: songController,
                                  validator: controller.validateLabel,
                                  enabled: !lock.value,
                                  decoration: InputDecoration(labelText: 'Som', prefixIcon: Icon(Icons.audiotrack_outlined)),
                                  keyboardType: TextInputType.text,
                                ),
                              ],
                            ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: () {
                        controller.message.value = '';
                        if (formKey.currentState?.validate() ?? false) {
                          controller.addCorneta(
                            local: localController.text.trim(),
                            label: labelController.text.trim(),
                            ip: ipController.text.trim(),
                            user: userController.text.trim(),
                            password: passController.text.trim(),
                            song: songController.text.trim(),
                          );

                          localController.clear();
                          labelController.clear();
                          ipController.clear();
                          userController.clear();
                          passController.clear();
                          songController.clear();
                        }
                      },
                      label: Text('Salvar'),
                      icon: Icon(Icons.check),
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
