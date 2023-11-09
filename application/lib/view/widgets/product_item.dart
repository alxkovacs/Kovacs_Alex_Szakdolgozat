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
    return Card(
      color: const Color.fromRGBO(67, 153, 182, 0.05),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 8.0, horizontal: 8.0), // Körbefuttatott padding
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0, // Négyzet alakú képet biztosít
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  imageName,
                  fit: BoxFit.cover, // A kép kitölti a rendelkezésre álló teret
                ),
              ),
            ),
            SizedBox(width: 10.0),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                '${number + 1}',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis, // Több sor esetén pontokkal zárul
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow
                        .ellipsis, // Több sor esetén pontokkal zárul
                  ),
                  Text(
                    store,
                    style: TextStyle(fontSize: 12.0),
                    maxLines: 1,
                    overflow: TextOverflow
                        .ellipsis, // Több sor esetén pontokkal zárul
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
