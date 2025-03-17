import 'package:cornetas_itaipu/src/data/services/cornetas_service.dart';
import 'package:cornetas_itaipu/src/data/services/data_service.dart';
import 'package:cornetas_itaipu/src/data/services/logger_service.dart';
import 'package:flutter/material.dart';

class ExecutePage extends StatefulWidget {
  const ExecutePage({super.key});

  @override
  State<ExecutePage> createState() => _ExecutePageState();
}

class _ExecutePageState extends State<ExecutePage> {
  final logController = TextEditingController();

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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                for (var ip in DataService.instance.ips) {
                  await CornetasService.instance.sendSignal(ip: ip, user: user, password: password);
                }
              },
              label: Text('Executar'),
              icon: Icon(Icons.campaign_outlined),
            ),
          ),
        ),
      ],
    );
  }
}
