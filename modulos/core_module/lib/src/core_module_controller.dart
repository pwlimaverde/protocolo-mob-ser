import 'package:dependencies_module/dependencies_module.dart';
import 'package:flutter/material.dart';

class CoreModuleController extends GetxController
    with LoaderMixin, MessagesMixin {
  @override
  void onInit() {
    super.onInit();
    loaderListener(
      statusLoad: statusLoad,
    );
    messageListener(
      message: message,
    );
    pageAtual(Get.find<GetStorage>().read("pageAtual"));
  }

  //Controller de Loading
  final statusLoad = false.obs;

  //Controller de Messages
  final message = Rxn<MessageModel>();

  //Controller de Pages
  final pageAtual = 0.obs;

  //Controller de Query
  final _size = Get.size.obs;
  double get size => _size.value.width;
  double get sizeW =>
      showMenu ? _size.value.width : _size.value.width - menuWidth;
  double get sizeH => _size.value.height - hederHeight;

  void getQuery({required BuildContext context}) {
    _size(MediaQuery.of(context).size);
  }

  bool get showMenu => _size.value.width <= 1080;

  double getWidthProporcao({
    required BuildContext context,
    required double proporcao,
  }) {
    getQuery(
      context: context,
    );
    return ((proporcao * sizeW) / 100) - 16;
  }

  double getSizeProporcao({
    required double size,
    required double proporcao,
  }) {
    var prop = ((size * proporcao) / 100);
    return prop;
  }
}
