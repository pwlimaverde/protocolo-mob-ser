import 'package:dependencies_module/dependencies_module.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const AnimacaoInicial());
  initServices();
  await Future.delayed(const Duration(milliseconds: 1000));
  runApp(const MyApp());
}

class AnimacaoInicial extends StatelessWidget {
  const AnimacaoInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Container(
        color: Colors.grey,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema Registro de Protocolos MOB - SER',
      initialBinding: CoreModuleBindings(),
      getPages: [
        ...SplashModule().routers,
        ...UploadRemessaModule().routers,
        ...RemessasModule().routers,
        ...HomeModule().routers,
      ],
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    );
  }
}
