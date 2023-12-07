import 'package:application/utils/colors.dart';
import 'package:application/utils/roots.dart';
import 'package:application/view/screens/base_screen.dart';
import 'package:application/view/screens/loading_screen.dart';
import 'package:application/view/screens/login_screen.dart';
import 'package:application/view/screens/sign_up_screen.dart';
import 'package:application/view/screens/start_screen.dart';
import 'package:application/view_model/add_product_screen_view_model.dart';
import 'package:application/view_model/base_screen_view_model.dart';
import 'package:application/view_model/home_screen_view_model.dart';
import 'package:application/view_model/login_screen_view_model.dart';
import 'package:application/view_model/offers_screen_view_model.dart';
import 'package:application/view_model/products_screen_view_model.dart';
import 'package:application/view_model/sign_up_screen_view_model.dart';
import 'package:application/view_model/store_search_screen_view_model.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
    DevicePreview(
      enabled: false,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SignUpScreenViewModel()),
          ChangeNotifierProvider(create: (_) => LoginScreenViewModel()),
          ChangeNotifierProvider(create: (_) => BaseScreenViewModel()),
          ChangeNotifierProvider(create: (_) => HomeScreenViewModel()),
          ChangeNotifierProvider(create: (_) => ProductsScreenViewModel()),
          ChangeNotifierProvider(create: (_) => AddProductScreenViewModel()),
          ChangeNotifierProvider(create: (_) => StoreSearchScreenViewModel()),
          ChangeNotifierProvider(create: (_) => OffersScreenViewModel()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Szakdolgozat',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        primaryColor: AppColor.mainColor,
        scaffoldBackgroundColor: Colors.white,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black.withOpacity(0.75),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
          ),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
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
        Roots.logInScreen: (context) => const LoginScreen(),
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
