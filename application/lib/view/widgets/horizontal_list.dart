import 'package:application/view/widgets/horizontal_product_item.dart';
import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const HorizontalList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 220, // A magasság megadása elegendő lehet a GridView számára
      child: GridView.builder(
        shrinkWrap: true, // A GridView méretének korlátozása a tartalomhoz
        physics: const ScrollPhysics(), // Engedélyezi a vízszintes görgetést
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 0, // Függőleges térköz
          mainAxisSpacing: 10, // Vízszintes térköz
          childAspectRatio: 0.195, // Az elemek arányának beállítása
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
              left:
                  index < 3 ? 0 : 0, // Az első elemnek adunk bal oldali margót
              right: index > 5 ? 10 : 0,
            ),
            child: HorizontalProductItem(
              number: index,
              id: products[index]['id'],
              product: products[index]['name'],
              category: products[index]['category']['name'],
              emoji: products[index]['category']['emoji'],
            ),
          );
        },
      ),
    );
  }
}
