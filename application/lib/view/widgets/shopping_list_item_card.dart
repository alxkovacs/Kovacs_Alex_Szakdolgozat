import 'package:application/model/product_model.dart';
import 'package:application/utils/colors.dart';
import 'package:flutter/material.dart';

class ShoppingListItemCard extends StatelessWidget {
  final ProductModel productModel;
  final VoidCallback onRemove;

  const ShoppingListItemCard({
    Key? key,
    required this.productModel,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0.0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                color: AppColor.mainColor.withOpacity(0.5),
                blurRadius: 10.0,
                spreadRadius: 1.0,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 0.0),
                blurRadius: 0.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Text(
            productModel.emoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 25.0),
        title: Text(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          productModel.product,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          productModel.category,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
