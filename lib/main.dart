import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balanco_game/features/home/screens/splash_screen.dart';
import 'package:balanco_game/core/theme/app_theme.dart';
import 'package:balanco_game/core/bloc/app_bloc.dart';

import 'package:balanco_game/core/data/database_helper.dart';
import 'package:balanco_game/core/data/app_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Ensure the database is initialized
  await DatabaseHelper.instance.database;
  await AppSettings.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const BalancoApp());
  });
}

class BalancoApp extends StatelessWidget {
  const BalancoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(),
      child: MaterialApp(
        title: 'Balanco',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
