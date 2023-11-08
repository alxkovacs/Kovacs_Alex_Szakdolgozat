import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
    required this.number,
    required this.title,
    required this.store,
    required this.imageName,
  }) : super(key: key);

  final int number;
  final String title;
  final String store;
  final String imageName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0, // Állítsd be a kívánt szélességet
      child: Card(
        color: const Color.fromRGBO(67, 153, 182, 0.15),
        // shadowColor: const Color.fromRGBO(67, 153, 182, 0.25),
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 8.0), // A belső térköz beállítása
          child: Row(
            children: <Widget>[
              Image.asset(
                imageName,
                height: 70.0, // A kép magasságának beállítása
                width: 70.0, // A kép szélességének beállítása
                // fit: BoxFit.cover, // Ha szeretnéd, hogy a kép kitöltse a rendelkezésre álló helyet
              ),
              // SizedBox(width: 4.0), // Elválasztó tér a kép és a szöveg között
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '${number + 1}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 15.0), // Elválasztó tér a kép és a szöveg között
              Expanded(
                // A maradék hely kitöltése a szöveggel
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // A szöveg balra igazítása
                  // mainAxisAlignment: MainAxisAlignment
                  //     .center, // A szöveg vertikális középre igazítása
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ), // A cím stílusának beállítása
                    // SizedBox(height: 5),
                    Text(
                      store,
                      style: TextStyle(fontSize: 12.0),
                    ), // Az alcím stílusának beállítása
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
