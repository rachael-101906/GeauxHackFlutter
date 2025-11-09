import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../components/organism.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewAllPage extends StatefulWidget {
  const ViewAllPage({Key? key}) : super(key: key);

  @override
  State<ViewAllPage> createState() => _ViewAllPageState();
}

class _ViewAllPageState extends State<ViewAllPage> {
  late Future<List<Organism>> organismsFuture;

  @override
  void initState() {
    super.initState();
    organismsFuture = loadOrganisms();
  }

  Future<List<Organism>> loadOrganisms() async {
    final String response =
        await rootBundle.loadString('assets/databases/organismsList.json');
    final List<dynamic> data = json.decode(response);

    return data.map((json) => Organism.fromJson(json)).toList();
  }

  void _showOrganismDialog(BuildContext context, Organism organism) {
    showDialog(
      barrierColor: const Color.fromARGB(164, 169, 201, 147),
      context: context,
      builder: (context) => AlertDialog(
        title: Text(organism.commonName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                organism.imgPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported),
              ),
              const SizedBox(height: 10),
              Text('Scientific Name: ${organism.scientificName}'),
              Text('Class: ${organism.className}'),
              Text('Biome: ${organism.bioRealm}'),
              Text('Category: ${organism.redListCategory}'),
              Text('Description: ${organism.description}'),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  final url = Uri.parse(organism.url);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: const Text('View on IUCN Red List'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 49, 33),
      appBar: AppBar(
        title: const Text('View All Animals'),
      ),
      body: FutureBuilder<List<Organism>>(
        future: organismsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final organisms = snapshot.data ?? [];

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 cards per row
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3 / 4,
            ),
            itemCount: organisms.length,
            itemBuilder: (context, index) {
              final organism = organisms[index];
              return GestureDetector(
                onTap: () => _showOrganismDialog(context, organism),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.asset(
                            organism.imgPath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image, size: 50),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          organism.commonName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
