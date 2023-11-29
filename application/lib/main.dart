import 'package:application/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:application/view/screens/start_screen.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
              // systemNavigationBarColor:
              //     const Color.fromRGBO(67, 153, 182, 1.00),
              systemNavigationBarColor: Colors.white,
            ),
            backgroundColor: Colors.white, // Az AppBar hátterének színe
            elevation: 0, // Az AppBar elevációjának eltávolítása
          ),
          bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Colors.white, modalElevation: 0.0)),
      routes: {
        'start': (context) => const StartScreen(),
        // 'base': (context) => const BaseScreen(),
        // 'home': (context) => HomeScreen(),
        // 'signup': (context) => const SignUpScreen(),
        // 'login': (context) => const LogInScreen(),
      },
      // initialRoute: 'start',
      // home: const StartScreen(),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // return const LoadingScreen();
            }

            if (snapshot.hasData) {
              // return ProductsScreen();
              // return ShoppingListScreen();
              // return ProductScreen();
              // return OfferScreen();
              // return ProfileScreen();
              // return const BaseScreen();
            }

            return const StartScreen();
          }),
    );
  }
}
