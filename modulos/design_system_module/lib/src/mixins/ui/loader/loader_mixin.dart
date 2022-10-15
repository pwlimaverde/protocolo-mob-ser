import 'package:dependencies_module/dependencies_module.dart';
import 'package:flutter/material.dart';

mixin LoaderMixin on GetxController {
  void loaderListener({
    required RxBool statusLoad,
  }) {
    ever<bool>(
      statusLoad,
      (loading) {
        if (loading) {
          Get.dialog(
            const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          Get.back();
        }
        // WidgetsBinding.instance.addPostFrameCallback((duration) async {
        //   if (loading) {
        //     Get.dialog(
        //       const Center(
        //         child: CircularProgressIndicator(),
        //       ),
        //     );
        //     Get.back();
        //   } else {
        //     Get.back();
        //   }
        // });
      },
    );
  }
}
