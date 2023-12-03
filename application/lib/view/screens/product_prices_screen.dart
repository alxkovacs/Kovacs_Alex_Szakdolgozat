import 'package:application/providers/product_prices_view_model_provider.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProductPricesScreen extends ConsumerStatefulWidget {
  final String productId;
  final String storeId;
  final String storeName;

  const ProductPricesScreen({
    Key? key,
    required this.productId,
    required this.storeId,
    required this.storeName,
  }) : super(key: key);

  @override
  ConsumerState<ProductPricesScreen> createState() =>
      _ProductPricesScreenState();
}

class _ProductPricesScreenState extends ConsumerState<ProductPricesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(productPricesViewModelProvider.notifier).fetchPrices(
              widget.productId,
              widget.storeId,
            ));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(productPricesViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          widget.storeName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: viewModel.isLoading
          ? const CustomCircularProgressIndicator()
          : viewModel.hasError
              ? Text('${TranslationEN.error}: ${viewModel.errorMessage}')
              : ListView.builder(
                  itemCount: viewModel.prices.length,
                  itemBuilder: (context, index) {
                    final priceItem = viewModel.prices[index];
                    final String formattedDate =
                        DateFormat('yyyy-MM-dd').format(priceItem.timestamp);
                    return ListTile(
                      title: Text(
                        formattedDate,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                      trailing: Text(
                        '${priceItem.price} ${TranslationEN.currencyHUF}',
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    );
                  },
                ),
    );
  }
}
