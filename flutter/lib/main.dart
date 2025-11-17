import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inswing/providers/connectivity_provider.dart';
import 'package:inswing/routes/app_router.dart';
import 'package:inswing/services/storage_service.dart';
import 'package:inswing/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local storage
  await Hive.initFlutter();
  await StorageService.init();
  
  // Initialize Firebase (if needed)
  // await Firebase.initializeApp();
  
  runApp(const ProviderScope(child: InSwingApp()));
}

class InSwingApp extends ConsumerWidget {
  const InSwingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state to determine initial route
    final router = ref.watch(goRouterProvider);
    
    // Initialize connectivity monitoring
    ref.read(connectivityControllerProvider.notifier).initialize();
    
    return MaterialApp.router(
      title: 'inSwing',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      builder: (context, child) {
        return Scaffold(
          body: child,
        );
      },
    );
  }
}