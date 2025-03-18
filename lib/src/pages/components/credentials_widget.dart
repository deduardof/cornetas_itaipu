import 'package:cornetas_itaipu/src/controllers/config_controller.dart';
import 'package:cornetas_itaipu/src/data/services/data_service.dart';
import 'package:flutter/material.dart';

class CredentialsWidget extends StatefulWidget {
  const CredentialsWidget({super.key, required this.controller});
  final ConfigController controller;

  @override
  State<CredentialsWidget> createState() => _CredentialsWidgetState();
}

class _CredentialsWidgetState extends State<CredentialsWidget> {
  final formKey = GlobalKey<FormState>();

  final userController = TextEditingController();
  final passController = TextEditingController();

  final visibility = ValueNotifier(false);
  final loader = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    final data = DataService.instance;
    userController.text = data.userCredential;
    passController.text = data.passwordCredential;
  }

  @override
  void dispose() {
    super.dispose();
    userController.dispose();
    passController.dispose();
    visibility.dispose();
    loader.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: formKey,
        child: SizedBox(
          width: 800,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              spacing: 20,
              children: [
                Text('Informe a credencial de acesso', style: Theme.of(context).textTheme.titleLarge),
                TextFormField(
                  controller: userController,
                  decoration: InputDecoration(prefixIcon: Icon(Icons.person_outline)),
                  validator: (value) => (value?.isEmpty ?? true) ? 'Campo obrigatório.' : null,
                ),
                ValueListenableBuilder(
                  valueListenable: visibility,
                  builder:
                      (_, isVisible, _) => TextFormField(
                        controller: passController,
                        obscureText: !isVisible,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.key),
                          suffixIcon: IconButton(
                            icon: Icon((isVisible) ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: () => visibility.value = !visibility.value,
                          ),
                        ),
                        validator: (value) => (value?.isEmpty ?? true) ? 'Campo obrigatório.' : null,
                      ),
                ),
                SizedBox(
                  width: double.maxFinite - 40,
                  height: 48,
                  child: ValueListenableBuilder(
                    valueListenable: loader,
                    builder:
                        (_, isLoading, _) =>
                            (isLoading)
                                ? CircularProgressIndicator()
                                : FilledButton.icon(
                                  onPressed: () async {
                                    if (formKey.currentState?.validate() ?? false) {
                                      final user = userController.text.trim();
                                      final password = passController.text.trim();
                                      await widget.controller.saveCredentials(user: user, password: password);
                                    }
                                  },
                                  label: Text('Salvar'),
                                  icon: Icon(Icons.check),
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
