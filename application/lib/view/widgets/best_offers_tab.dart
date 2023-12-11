import 'package:application/model/price_and_store_model.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/screens/product_prices_screen.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class BestOffersTab extends StatelessWidget {
  final List<PriceAndStoreModel> priceAndStoreList;
  final String productId;
  final bool isLoading;

  const BestOffersTab({
    Key? key,
    required this.priceAndStoreList,
    required this.productId,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CustomCircularProgressIndicator();
    }

    if (priceAndStoreList.isEmpty) {
      return const Center(child: Text(TranslationEN.noPricesAvailable));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      itemCount: priceAndStoreList.length,
      itemBuilder: (context, index) {
        final priceAndStoreItem = priceAndStoreList[index];

        return ListTile(
          leading: Text('${index + 1}.',
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          title: Text(priceAndStoreItem.storeName,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          contentPadding: const EdgeInsets.only(
            left: 0.0,
            right: 0.0,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${priceAndStoreItem.priceCount} ${TranslationEN.pricePerUnit}',
                style: const TextStyle(fontSize: 11),
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 25,
              ),
            ],
          ),
          subtitle: Text(
              '${priceAndStoreItem.price} ${TranslationEN.currencyHUF}',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductPricesScreen(
                  productId: productId,
                  storeId: priceAndStoreItem.storeId,
                  storeName: priceAndStoreItem.storeName,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
