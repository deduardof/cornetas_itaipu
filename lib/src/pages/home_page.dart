import 'package:cornetas_itaipu/src/pages/credentials_page.dart';
import 'package:cornetas_itaipu/src/pages/network_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cornetas de Itaipu'),
        bottom: TabBar(
          controller: tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(icon: Icon(Icons.campaign_outlined), text: 'Executar'),
            Tab(icon: Icon(Icons.lan_outlined), text: 'IPs'),
            Tab(icon: Icon(Icons.settings_outlined), text: 'Acesso'),
          ],
        ),
      ),
      body: TabBarView(controller: tabController, children: [Text('Executar'), NetworkPage(), CredentialsPage()]),
    );
  }
}
