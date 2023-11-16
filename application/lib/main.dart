import 'package:application/utils/colors.dart';
import 'package:application/view/screens/base_screen.dart';
import 'package:application/view/screens/home_screen.dart';
import 'package:application/view/screens/loading_screen.dart';
import 'package:application/view/screens/login_screen.dart';
import 'package:application/view/screens/offer_screen.dart';
import 'package:application/view/screens/offers_screen.dart';
import 'package:application/view/screens/product_screen.dart';
import 'package:application/view/screens/products_screen.dart';
import 'package:application/view/screens/profile_screen.dart';
import 'package:application/view/screens/settings_screen.dart';
import 'package:application/view/screens/shopping_list_screen.dart';
import 'package:application/view/screens/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

import 'package:application/view/screens/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: const Color.fromRGBO(67, 153, 182, 1.00),
    // systemNavigationBarColor: Colors.transparent,
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
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
              // systemNavigationBarColor:
              //     const Color.fromRGBO(67, 153, 182, 1.00),
              systemNavigationBarColor: Colors.transparent,
            ),
            backgroundColor: Colors.white, // Az AppBar hátterének színe
            elevation: 0, // Az AppBar elevációjának eltávolítása
          ),
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.white, modalElevation: 0.0)),
      routes: {
        'start': (context) => const StartScreen(),
        'base': (context) => const BaseScreen(),
        'home': (context) => HomeScreen(),
        'signup': (context) => const SignUpScreen(),
        'login': (context) => const LogInScreen(),
      },
      // initialRoute: 'start',
      // home: const StartScreen(),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            }

            if (snapshot.hasData) {
              // return ProductsScreen();
              // return ShoppingListScreen();
              // return ProductScreen();
              // return OfferScreen();
              // return ProfileScreen();
              return const BaseScreen();
            }

            return const StartScreen();
          }),
    );
  }
}
