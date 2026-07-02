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
<<<<<<< HEAD
=======
import 'features/discover/controllers/room_detail_controller.dart';
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d

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
<<<<<<< HEAD
        // Provider cho Profile
        ChangeNotifierProvider(create: (_) => ProfileController()),
=======
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => RoomDetailController()),
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
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