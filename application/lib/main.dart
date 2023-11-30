import 'package:application/utils/colors.dart';
import 'package:application/utils/roots.dart';
import 'package:application/view/screens/base_screen.dart';
import 'package:application/view/screens/loading_screen.dart';
import 'package:application/view/screens/login_screen.dart';
import 'package:application/view/screens/sign_up_screen.dart';
import 'package:application/view/screens/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
  ));
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Szakdolgozat',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        primarySwatch: Colors.blue,
        primaryColor: AppColor.mainColor,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor:
                Colors.black.withOpacity(0.75), // A gomb szövegének színe
            textStyle: const TextStyle(
                fontWeight: FontWeight.bold), // A gomb szövegének stílusa
          ),
        ),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
          ),
          backgroundColor: Colors.white, // Az AppBar hátterének színe
          elevation: 0, // Az AppBar elevációjának eltávolítása
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
          modalElevation: 0.0,
        ),
      ),
      routes: {
        Roots.startScreen: (context) => const StartScreen(),
        Roots.baseScreen: (context) => const BaseScreen(),
        Roots.signUpScreen: (context) => const SignUpScreen(),
        Roots.logInScreen: (context) => const LogInScreen(),
      },
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            }

            if (snapshot.hasData) {
              return const BaseScreen();
            }

            return const StartScreen();
          }),
    );
  }
}
