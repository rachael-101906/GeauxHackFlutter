import 'package:flutter/material.dart';
import 'organism.dart';

class GraphicCard extends StatelessWidget {
  final Organism organism;
  final double? width;
  final double? imageHeight;

  const GraphicCard({
    super.key,
    required this.organism,
    this.width,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow( blurRadius: 6, offset: const Offset(0, 3)),
      ],
    ),
    child: Column(
      children: [
        Text('Name: ${organism.commonName}'),
          Text('Scientific Name: ${organism.scientificName}'),
          Text('Bio Realm: ${organism.bioRealm}'),
          Text('Countries: ${organism.countries.join(", ")}'),
          Text('Red List Category: ${organism.redListCategory}'),
        ],
      ),
    );
  }
}
