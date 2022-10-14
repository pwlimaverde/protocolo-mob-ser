import 'package:flutter/material.dart';
import 'package:dependencies_module/dependencies_module.dart';
import 'widgets/bodyops/bodyupload_csv_widget.dart';

class UploadRemessaPage extends GetView<UploadRemessaController> {
  const UploadRemessaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return designSystemController.scaffold(
      body: const BodyUploadRemessaWidget(),
      page: 1,
      context: context,
    );
  }
}
