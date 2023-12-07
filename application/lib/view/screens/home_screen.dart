import 'package:application/utils/colors.dart';
import 'package:application/utils/image_src.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/auth_image_widget.dart';
import 'package:application/view/widgets/horizontal_list.dart';
import 'package:application/view/widgets/savings_card.dart';
import 'package:application/view_model/home_screen_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;

    String userId = user!.uid;
    Future.microtask(() =>
        Provider.of<HomeScreenViewModel>(context, listen: false)
            .fetchData(userId));
  }

  @override
  Widget build(BuildContext context) {
    final homeScreenViewModel = Provider.of<HomeScreenViewModel>(context);

    return Scaffold(
      backgroundColor: AppColor.lightBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hello, ${homeScreenViewModel.userFirstName}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).textScaleFactor * 30,
                    ),
                  ),
                ),
                const AuthImageWidget(
                  imagePath: ImageSrc.homeScreenImage,
                ),
                const SavingsCard(),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    homeScreenViewModel.menu[0]['goToPage']()),
                          );
                        },
                        child: Container(
                          decoration: Styles.boxDecorationWithShadow,
                          child: Card(
                            shadowColor: Colors.transparent,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Text(
                                  homeScreenViewModel.menu[0]['name'],
                                  textAlign: TextAlign.center,
                                  style: Styles.homeScreenButtons,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    homeScreenViewModel.menu[1]['goToPage']()),
                          );
                        },
                        child: Container(
                          decoration: Styles.boxDecorationWithShadow,
                          child: Card(
                            shadowColor: Colors.transparent,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Text(
                                  homeScreenViewModel.menu[1]['name'],
                                  textAlign: TextAlign.center,
                                  style: Styles.homeScreenButtons,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    TranslationEN.mostViewedProducts,
                    style: Styles.homeScreenHorizontalListTitle,
                  ),
                ),
                const SizedBox(height: 15),
                if (homeScreenViewModel.topViewedProducts.isNotEmpty)
                  HorizontalList(
                      products: homeScreenViewModel.topViewedProducts),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    TranslationEN.productsRecommendedForYou,
                    style: Styles.homeScreenHorizontalListTitle,
                  ),
                ),
                const SizedBox(height: 15),
                if (homeScreenViewModel.topViewedProducts.isNotEmpty)
                  HorizontalList(
                      products: homeScreenViewModel.topViewedProducts),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
