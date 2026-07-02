import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'bloc/app_bloc.dart';

import 'data/database_helper.dart';
import 'data/app_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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