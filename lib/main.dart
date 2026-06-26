import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'bloc/app_bloc.dart';

import 'data/database_helper.dart';
import 'data/app_settings.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Ensure the database is initialized
  await DatabaseHelper.instance.database;
  await AppSettings.init();
  
  final profile = await DatabaseHelper.instance.getPlayerProfile();
  final bool isFirstOpen = profile.isFirstOpen;
  
  if (isFirstOpen) {
    final updatedProfile = profile.copyWith(isFirstOpen: false);
    await DatabaseHelper.instance.updatePlayerProfile(updatedProfile);
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(BalancoApp(isFirstOpen: isFirstOpen));
  });
}

class BalancoApp extends StatelessWidget {
  final bool isFirstOpen;
  
  const BalancoApp({super.key, required this.isFirstOpen});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(),
      child: MaterialApp(
        title: 'Balanco',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: isFirstOpen ? const SplashScreen() : const MainScreen(),
      ),
    );
  }
}