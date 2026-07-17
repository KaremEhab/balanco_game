import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balanco_game/features/home/screens/splash/splash_screen.dart';
import 'package:balanco_game/core/theme/app_theme.dart';
import 'package:balanco_game/core/bloc/app_bloc.dart';

import 'package:balanco_game/core/data/database_helper.dart';
import 'package:balanco_game/core/data/app_settings.dart';
import 'package:balanco_game/core/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:balanco_game/core/navigation/global_navigator.dart';
import 'package:balanco_game/core/widgets/connectivity_sync_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Ensure the database is initialized
  await DatabaseHelper.instance.database;
  
  // HOTFIX: Restore user's lost offline progress
  final profile = await DatabaseHelper.instance.getPlayerProfile();
  if (profile.highestLevel < 15) {
    await DatabaseHelper.instance.updatePlayerProfile(profile.copyWith(highestLevel: 15));
  }

  await AppSettings.init();
  if (SupabaseConfig.isConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );
  }

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
      child: ConnectivitySyncWrapper(
        child: MaterialApp(
          navigatorKey: GlobalNavigator.navigatorKey,
          scaffoldMessengerKey: GlobalNavigator.scaffoldMessengerKey,
          title: 'Balanco',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
