import 'package:application/providers/base_view_model_provider.dart';
import 'package:application/utils/colors.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/screens/home_screen.dart';
import 'package:application/view/screens/offers_screen.dart';
import 'package:application/view/screens/products_screen.dart';
import 'package:application/view/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BaseScreen extends ConsumerStatefulWidget {
  const BaseScreen({super.key});

  @override
  ConsumerState<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends ConsumerState<BaseScreen> {
  // Itt adunk hozzá minden oldalt, amit a BottomNavigationBar használni fog
  final List<Widget> _pages = [
    const HomeScreen(), // A HomeScreen lesz az alapértelmezett oldal
    const ProductsScreen(),
    Container(), // Ezt az indexet tartjuk fenn az "Hozzáadás" gomb számára
    const OffersScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(baseViewModelProvider);
    return Scaffold(
      body: IndexedStack(
        index: viewModel.selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColor.mainColor,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 10,
          unselectedFontSize: 13,
          selectedFontSize: 13,
          backgroundColor: AppColor.lightBackgroundColor,
          selectedItemColor: AppColor.mainColor,
          unselectedItemColor: AppColor.mainColor,
          selectedLabelStyle: const TextStyle(color: Colors.white),
          unselectedLabelStyle: const TextStyle(color: Colors.white),
          iconSize: 27.0,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: viewModel.selectedIndex == 0
                  ? const Icon(Icons.home)
                  : const Icon(Icons.home_outlined),
              label: TranslationEN.home,
            ),
            BottomNavigationBarItem(
              icon: viewModel.selectedIndex == 1
                  ? const Icon(Icons.saved_search)
                  : const Icon(Icons.search),
              label: TranslationEN.products,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: TranslationEN.add,
            ),
            BottomNavigationBarItem(
              icon: viewModel.selectedIndex == 3
                  ? const Icon(Icons.discount)
                  : const Icon(Icons.discount_outlined),
              label: TranslationEN.offers,
            ),
            BottomNavigationBarItem(
              icon: viewModel.selectedIndex == 4
                  ? const Icon(Icons.settings)
                  : const Icon(Icons.settings_outlined),
              label: TranslationEN.settings,
            ),
          ],
          currentIndex: viewModel.selectedIndex,
          onTap: (index) => viewModel.selectTab(index, context),
        ),
      ),
    );
  }
}
