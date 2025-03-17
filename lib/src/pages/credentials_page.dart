import 'package:cornetas_itaipu/src/controllers/credentials_controller.dart';
import 'package:cornetas_itaipu/src/data/services/data_service.dart';
import 'package:flutter/material.dart';

class CredentialsPage extends StatefulWidget {
  const CredentialsPage({super.key});

  @override
  State<CredentialsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends State<CredentialsPage> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  final controller = CredentialsController();
  final visibility = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    userController.text = DataService.instance.userCredential;
    passController.text = DataService.instance.passwordCredential;
  }

  @override
  void dispose() {
    super.dispose();
    userController.dispose();
    passController.dispose();
    visibility.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder:
          (_, _) =>
              (controller.isLoading)
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      spacing: 20,
                      children: [
                        const SizedBox(height: 10),
                        Text('Informe a credencial de acesso', style: Theme.of(context).textTheme.titleLarge),
                        TextFormField(controller: userController, decoration: InputDecoration(prefixIcon: Icon(Icons.person_outline))),
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
                              ),
                        ),
                        SizedBox(
                          width: double.maxFinite - 40,
                          height: 40,
                          child: FilledButton.icon(
                            onPressed: () async {
                              final user = userController.text.trim();
                              final password = passController.text.trim();
                              await controller.saveCredentials(user: user, password: password);
                            },
                            label: Text('Salvar'),
                            icon: Icon(Icons.check),
                          ),
                        ),
                      ],
                    ),
                  ),
    );
  }
}
