import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'organism.dart';
import 'graphic_card.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  List<Organism> organisms = [];

Future<void> loadOrganisms() async {
    final String response = await rootBundle.loadString('databases/organismsList.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      organisms = data.map((json) => Organism.fromJson(json)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadOrganisms();
  }

  @override
  Widget build(BuildContext context) {
    return 
      ListView.builder(
              itemCount: organisms.length,
              itemBuilder: (context, index) {
                return GraphicCard(organism: organisms[index]);
              },

    );
  }
}
