import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutralyse_jd/presentation/widget/bottom_bar.dart';
import 'package:nutralyse_jd/presentation/pages/splash_screen.dart';
import 'package:nutralyse_jd/presentation/pages/home.dart';
import 'package:nutralyse_jd/presentation/pages/kamera.dart';
import 'package:nutralyse_jd/presentation/pages/profile.dart';
import 'package:nutralyse_jd/presentation/pages/login_screen.dart';
import 'package:nutralyse_jd/presentation/pages/sign_up_screen.dart';
import 'package:nutralyse_jd/presentation/pages/onboard.dart';
import 'package:nutralyse_jd/presentation/pages/forget_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(),
  );
}

  /// GoRouter config
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return LoginPage();
      },
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboard',
      builder: (BuildContext context, GoRouterState state) {
        return Onboard();
      },
    ),
    GoRoute(
      path: '/get-started',
      builder: (BuildContext context, GoRouterState state) {
        return SplashScreen();
      },
    ),
    GoRoute(
      path: '/sign-up',
      builder: (BuildContext context, GoRouterState state) {
        return Signup();
      },
    ),
    GoRoute(
      path: '/forget-password',
      builder: (BuildContext context, GoRouterState state) {
        return ForgotPasswordScreen();
      },
    ),
    ShellRoute(
      builder: (context, state, child) => NavigationMenu(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          path: '/camera',
          builder: (context, state) => Camera(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => Profile(),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nutralyse',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
