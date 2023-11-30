import 'package:application/providers/home_screen_provider.dart';
import 'package:application/utils/colors.dart';
import 'package:application/utils/image_src.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/auth_image_widget.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:application/view/widgets/horizontal_list.dart';
import 'package:application/view/widgets/savings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(homeScreenViewModelProvider);
    final productsSnapshot = ref.watch(topViewedProductsProvider);

    return Scaffold(
      backgroundColor: AppColor.lightBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hello, ${viewModel.userFirstName}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                const AuthImageWidget(
                  imagePath: ImageSrc.homeScreenImage,
                ),
                const SavingsCard(),
                const SizedBox(height: 15),
                GridView.builder(
                  shrinkWrap: true, // Add this line
                  physics: const NeverScrollableScrollPhysics(), // And this one
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Két elem lesz egy sorban
                    crossAxisSpacing: 10, // vízszintes térköz az elemek között
                    mainAxisSpacing: 0, // függőleges térköz az elemek között
                    childAspectRatio: 4, // az elemek aránya
                  ),
                  itemCount: viewModel.menu.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  viewModel.menu[index]['goToPage']()),
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
                            padding: const EdgeInsets.only(
                              left: 0,
                              top: 0,
                              right: 0,
                              bottom: 0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Középre igazítás a függőleges tengely mentén
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Középre igazítás a vízszintes tengely mentén
                              children: <Widget>[
                                Text(
                                  viewModel.menu[index]['name'],
                                  textAlign: TextAlign
                                      .center, // Szöveg középre igazítása
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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
                productsSnapshot.when(
                  data: (products) {
                    // Itt adja át a termékek listáját a `HorizontalList` widgetnek.
                    return HorizontalList(products: products);
                  },
                  loading: () => const CustomCircularProgressIndicator(),
                  error: (e, _) => Text('${TranslationEN.error}: $e'),
                ),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    TranslationEN.productsRecommendedForYou,
                    style: Styles.homeScreenHorizontalListTitle,
                  ),
                ),
                const SizedBox(height: 15),
                productsSnapshot.when(
                  data: (products) {
                    // Itt adja át a termékek listáját a `HorizontalList` widgetnek.
                    return HorizontalList(products: products);
                  },
                  loading: () => const CustomCircularProgressIndicator(),
                  error: (e, _) => Text('${TranslationEN.error}: $e'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
