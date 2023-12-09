import 'package:application/utils/styles/styles.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:application/view/widgets/savings_info_row.dart';
import 'package:application/view_model/home_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavingsCard extends StatelessWidget {
  const SavingsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeScreenViewModel>(context, listen: false);

    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        decoration: Styles.boxDecorationWithShadow,
        child: Card(
          color: Colors.transparent,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: FutureBuilder<List<int>>(
              future: Future.wait([
                viewModel.getProductsCount(),
                viewModel.getStoresCount(),
              ]),
              builder:
                  (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomCircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text(TranslationEN.error);
                } else if (snapshot.hasData) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SavingsInfoRow(
                          title: '${TranslationEN.numberOfProducts}:',
                          value: '${snapshot.data![0]} db',
                        ),
                      ),
                      SavingsInfoRow(
                        title: '${TranslationEN.numberOfStores}:',
                        value: '${snapshot.data![1]} db',
                      ),
                    ],
                  );
                } else {
                  return const Text(TranslationEN.noData);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
