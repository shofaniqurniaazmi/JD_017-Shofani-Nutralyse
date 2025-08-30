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
import 'package:nutralyse_jd/presentation/pages/detail_gizi.dart';
import 'package:nutralyse_jd/presentation/pages/detail_rekomendasi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLoggedIn = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: isLoggedIn ? '/home' : '/',
  routes: [
    // Halaman awal
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const Signup(),
    ),
    GoRoute(
      path: '/onboard',
      builder: (context, state) => Onboard(),
    ),
    GoRoute(
      path: '/forget-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // Halaman full screen detail gizi (di luar ShellRoute)
    GoRoute(
      path: '/detail_gizi',
      builder: (context, state) => const RiwayatPage(),
    ),
    GoRoute(
      path: '/detail_rekomendasi',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        // Validasi data yang diterima
        if (extra == null ||
            !extra.containsKey('nama') ||
            !extra.containsKey('gambar') ||
            !extra.containsKey('persen')) {
          // Jika data tidak valid, redirect ke home
          WidgetsBinding.instance.addPostFrameCallback((_) {
            GoRouter.of(state.matchedLocation as BuildContext).go('/home');
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return DetailRekomendasiPage(foodData: extra);
      },
    ),
    GoRoute(
      path: '/camera',
      builder: (context, state) =>  Camera(),
    ),

    // Halaman yang pakai NavigationMenu
    ShellRoute(
      builder: (context, state, child) => NavigationMenu(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const Profile(),
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
