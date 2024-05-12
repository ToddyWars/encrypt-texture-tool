import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:unzip_mc_texture/app/modules/home/services/home_service.dart';

import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController(Dio()));
    Get.put(HomeService(Dio()));
  }
}