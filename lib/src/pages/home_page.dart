import 'package:cornetas_itaipu/src/controllers/home_controller.dart';
import 'package:cornetas_itaipu/src/pages/config_page.dart';
import 'package:cornetas_itaipu/src/pages/cornetas_page.dart';
import 'package:cornetas_itaipu/src/pages/execute_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController tabController;
  final controller = HomeController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    Future.delayed(Duration.zero, () async => controller.loadData());
  }

  @override
  void dispose() {
    tabController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/itaipu_logo.png', width: 100, height: 100),
            Text('Cornetas de Itaipu', style: Theme.of(context).textTheme.headlineLarge),
          ],
        ),
        bottom: TabBar(
          controller: tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(icon: Icon(Icons.sensors_outlined), text: 'Executar'),
            Tab(icon: Icon(Icons.campaign_outlined), text: 'Cornetas'),
            Tab(icon: Icon(Icons.settings_outlined), text: 'Acesso'),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder:
            (_, _) =>
                (controller.isLoading)
                    ? Center(child: CircularProgressIndicator())
                    : TabBarView(controller: tabController, children: [ExecutePage(), CornetasPage(), ConfigPage()]),
      ),
    );
  }
}
