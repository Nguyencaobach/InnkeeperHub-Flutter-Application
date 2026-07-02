// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/network/api_client.dart';
import 'features/auth/views/splash_screen.dart';
import 'features/auth/views/login_screen.dart';
import 'state/user_state.dart';
import 'features/discover/controllers/discover_controller.dart';
import 'features/profile/controllers/profile_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserState()),
        // Cấp phát Kho chung cho dữ liệu Phòng (Khám phá)
        ChangeNotifierProvider(create: (_) => DiscoverController()), 
        ChangeNotifierProvider(create: (_) => ProfileController()),
      ],
      child: MaterialApp(
        title: 'innkeeperHub',
        debugShowCheckedModeBanner: false,
        navigatorKey: ApiClient.navigatorKey,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        routes: {
          '/login': (_) => const LoginScreen(),
        },
      ),
    );
  }
}