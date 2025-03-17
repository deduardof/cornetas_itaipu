import 'package:cornetas_itaipu/src/data/services/local_storage_service.dart';
import 'package:flutter/material.dart';

class CredentialsPage extends StatefulWidget {
  const CredentialsPage({super.key});

  @override
  State<CredentialsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends State<CredentialsPage> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  final loader = ValueNotifier(true);
  final visibility = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final (:user, :password) = await LocalStorage.instance.getCredentials();
      userController.text = user;
      passController.text = password;
      loader.value = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    userController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    print('Width: $width');
    return ValueListenableBuilder(
      valueListenable: loader,
      builder:
          (_, isLoading, _) =>
              (isLoading)
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
                              loader.value = true;
                              await LocalStorage.instance.saveCredentials(user: userController.text.trim(), password: passController.text.trim());
                              loader.value = false;
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
