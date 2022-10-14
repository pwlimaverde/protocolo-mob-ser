import 'package:dependencies_module/dependencies_module.dart';
import 'package:flutter/material.dart';
import '../splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          children: [
            const Text(
              "Splash - Bem Vindo ao Sistema..",
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
              ),
            ),
            const Text(
              "teste",
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
              ),
            ),
            Text(
              Routes.initial.caminho,
              style: const TextStyle(
                fontSize: 30.0,
                color: Colors.white,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  Obx(() => Text(
                        '${controller.counter}',
                        style: Theme.of(context).textTheme.headline4,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
