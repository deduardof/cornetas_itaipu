import 'package:cornetas_itaipu/src/controllers/home_controller.dart';
import 'package:cornetas_itaipu/src/pages/cornetas_page.dart';
import 'package:cornetas_itaipu/src/pages/credentials_page.dart';
import 'package:cornetas_itaipu/src/pages/execute_page.dart';
import 'package:cornetas_itaipu/src/pages/songs_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();

  @override
  void initState() {
    super.initState();
    controller.loadData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          centerTitle: true,
          title: FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/itaipu_logo.png', width: 100, height: 100),
                Text('Cornetas de Itaipu', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(icon: Icon(Icons.sensors_outlined), text: 'Executar'),
              Tab(icon: Icon(Icons.campaign_outlined), text: 'Cornetas'),
              Tab(icon: Icon(Icons.badge_outlined), text: 'Credenciais'),
              Tab(icon: Icon(Icons.audiotrack_outlined), text: 'Sons'),
            ],
          ),
          actions: [IconButton(icon: Icon(Icons.inventory_outlined), onPressed: () {})],
        ),
        body: ListenableBuilder(
          listenable: controller,
          builder:
              (_, _) =>
                  (controller.isLoading)
                      ? Center(child: CircularProgressIndicator())
                      : TabBarView(children: [ExecutePage(), CornetasPage(), CredentialsPage(), SongsPage()]),
        ),
      ),
    );
  }
}
