import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:unzip_mc_texture/app/modules/home/home_binding.dart';
import 'app/l10n/translations.dart';
import 'app/routes/app_pages.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //HIVE
  await Hive.initFlutter();
  await initializeDateFormatting('pt_BR', null);
  await Hive.openBox('languages');

  //CONFIGURAÇÃO DO WINDOWS
  if (GetPlatform.isWindows && !GetPlatform.isWeb) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      title: 'Isekai MC',
      minimumSize: Size(375, 600),
      maximumSize: Size(375, 600),
      center: true, // Centraliza a janela
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      if (await windowManager.isVisible()) {
        await windowManager.show();
        await windowManager.focus();
      } else {
        await windowManager.setSize(const Size(375, 600));
        await windowManager.show();
        await windowManager.focus();
      }
    });
  }

  //CONFIGURAÇÃO DA LINGUAGEM
  final language = await Hive.box('languages').get('idioma');
  Locale locale = const Locale('pt', 'BR');
  if (language != null && language == 'en') {
    locale = const Locale('en', 'US');
  }

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'iMC - Tools',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xff303030),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff303030),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      initialBinding:
          HomeBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      translations: Messages(),
      locale: locale,
      fallbackLocale: const Locale('pt', 'BR'),
    ),
  );
}