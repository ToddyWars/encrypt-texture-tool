// ignore_for_file: avoid_print


import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // final HomeService _homeServices;
  // HomeController(this._homeServices);

  late final TabController tabController;
  
  late final RxBool processing = false.obs; // Adiciona a variável para controlar o processamento
  late final RxString processingMessage = ''.obs; // Adiciona a variável para armazenar a mensagem de processamento


  ScrollController scrollControllerHome = ScrollController();
  ScrollController scrollControllerLog = ScrollController();
  late final RxList<String> outputController = <String>[].obs;


  HomeController(find);
  @override
  Future<void> onInit() async {
    super.onInit();
    tabController = TabController(vsync: this, length: 4);
  }
}