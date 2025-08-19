import 'package:get/get.dart';

import '../controllers/attedance_controller.dart';

class AttedanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttedanceController>(
      () => AttedanceController(),
    );
  }
}
