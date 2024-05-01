import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'feature/auth/providers/auth_provider.dart';
import 'feature/auth/screens/login_screen.dart';
import 'feature/home/provider/bottom_nav_bar_provider.dart';
import 'feature/splash/screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => BottomNavBarProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => AuthProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FindersUnited',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.cyan,
              background: Colors.white,
            ),
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
            useMaterial3: true,
          ),
          home: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              var isAuthenticated = authProvider.isAuthenticated();
              return isAuthenticated
                  ? const SplashScreen()
                  : const LoginScreen();
            },
          ),
        ),
      ),
    );
  }
}
