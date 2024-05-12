import 'home_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = '/home';

  static final routes = [
    ...HomeRoutes.routes
  ];
}