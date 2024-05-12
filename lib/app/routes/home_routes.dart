import 'package:get/get.dart';

import '../modules/home/home_binding.dart';
import '../modules/home/pages/home_page.dart';

class HomeRoutes {
  HomeRoutes._();

  static const home = '/home';

  static final routes = [
    GetPage(
        name: home,
        page: () => HomePage(),
        binding: HomeBinding(),
        // middlewares: [AuthMiddleware()],
        transition: Transition.size,
        transitionDuration: const Duration(seconds: 1)),
  ];
}