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
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth > 600 ? 24 : 12;
    final viewModel = Provider.of<HomeScreenViewModel>(context, listen: false);

    return Container(
      decoration: Styles.boxDecorationWithShadow,
      child: Card(
        color: Colors.transparent,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: FutureBuilder<List<int>>(
            future: Future.wait([
              viewModel.getProductsCount(),
              viewModel.getStoresCount(),
            ]),
            builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CustomCircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text(TranslationEN.error);
              } else if (snapshot.hasData) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SavingsInfoRow(
                      title: '${TranslationEN.numberOfProducts}:',
                      value: '${snapshot.data![0]} db',
                    ),
                    const SizedBox(height: 10),
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
    );
  }
}
