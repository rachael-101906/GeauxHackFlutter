import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class MapAnimalDialog extends StatelessWidget {
  final String animalName;
  final String description;
  final String imagePath;
  final String url;
  final String redListCategory;
  final VoidCallback onDismiss;

  const MapAnimalDialog({
    super.key,
    required this.animalName,
    required this.description,
    required this.imagePath,
    required this.url,
    required this.redListCategory,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Material( 
      color: Colors.transparent,
      child: Center( 
        child: Container(
          width: 360,
          decoration: BoxDecoration(
            color: Color(0xFF232E26),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.asset(
                      imagePath,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 200,
                          color:  Color(0xFF232E26),
                          child: const Icon(Icons.image_not_supported, size: 50, color: Colors.white),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: InkWell(
                      onTap: onDismiss,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      animalName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB3CBB2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      redListCategory,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                        color: Color.fromARGB(255, 189, 210, 186),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFFB3CBB2),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                    onPressed: () async {
                      final uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      } else {
                        print('Could not launch $url');
                      }
                    },
                    child: const Text(
                      'Learn More',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF93B3CD),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
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


class MapMarkersPage extends StatefulWidget {
  const MapMarkersPage({super.key});

  @override
  State<MapMarkersPage> createState() => _MapMarkersPageState();
}

class _MapMarkersPageState extends State<MapMarkersPage> {
  List<dynamic>? organisms; 

  static const LatLng _pointCentral = LatLng(30.900, -30.060);

  static const LatLng _neotropicalPoint = LatLng(-10.0, -55.0);
  static const LatLng _oceanicPoint = LatLng(-15.0, -165.0);
  static const LatLng _nearticPoint = LatLng(55.0, -100.0);
  static const LatLng _afrotropicalPoint = LatLng(0.0, 20.0);
  static const LatLng _palearticPoint = LatLng(50.0, 75.0);
  static const LatLng _indomalayanPoint = LatLng(15.0, 95.0);
  static const LatLng _australiasianPoint = LatLng(-23.0, 133.0);

  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _getOrganisms();
    _setupMarkers();
  }
  
  void _setupMarkers() {
    _markers = [
      _buildCityMarker(_neotropicalPoint, 'Neotropical', Colors.greenAccent),
      _buildCityMarker(_oceanicPoint, 'Oceanic', const Color(0xFF93B3CD)),
      _buildCityMarker(_nearticPoint, 'Neartic', const Color(0xFFEECE57)),
      _buildCityMarker(_afrotropicalPoint, 'Afrotropical', const Color.fromARGB(255, 76, 88, 223)),
      _buildCityMarker(_palearticPoint, 'Paleartic', const Color(0xFFDD7F78)),
      _buildCityMarker(_indomalayanPoint, 'Indomalayan', const Color.fromARGB(255, 211, 158, 94)),
      _buildCityMarker(_australiasianPoint, 'Australasian', const Color.fromARGB(255, 167, 111, 204)),
    ];
  }

  Marker _buildCityMarker(LatLng point, String bioRealm, Color color) {
    return Marker(
      point: point,
      width: 95,
      height: 65,
      child: InkWell(
        onTap: () => getAnimalMarkers(bioRealm),
        child: Column(
          children: [
            Icon(Icons.location_pin, color: color, size: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                bioRealm,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getOrganisms() async {
    try {
      String jsonString = await rootBundle.loadString('assets/databases/organismsList.json');
      setState(() {
        organisms = json.decode(jsonString);
      });
    } catch (e) {
      print('Error loading organisms JSON: $e');
    }
  }

  void getAnimalMarkers(String bioRealm) {
    if (organisms == null) {
      return; 
    }

    Map<String, String> realmAnimals = {
      'Neotropical': 'Orinoco Crocodile',
      'Oceanic': 'Atlantic Bluefin Tuna',
      'Neartic': 'Monarch Butterfly',
      'Afrotropical': 'African Elephant',
      'Paleartic': 'Snow Leopard',
      'Indomalayan': 'Komodo Dragon',
      'Australasian': 'Kakapo',
    };

    String? targetName = realmAnimals[bioRealm];
    if (targetName == null) return;

    final animal = organisms!.firstWhere(
      (o) => o['common_name'] == targetName,
      orElse: () => {}, 
    );
    
    if (animal.isNotEmpty) { 
      showGeneralDialog(
        context: context,
        useRootNavigator: true, 
        barrierDismissible: true, 
        barrierLabel: 'Dismiss',
        transitionDuration: const Duration(milliseconds: 350),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          );
        },

        pageBuilder: (context, animation, secondaryAnimation) {
          return MapAnimalDialog( 
            animalName: animal['common_name'] ?? 'Unknown Animal',
            description: animal['description'] ?? 'No description available',
            imagePath: animal['imagePath'] ?? '', 
            url: animal['redlist_url'] ?? '',
            redListCategory: animal['redListCategory'] ?? 'Unknown',
            onDismiss: () => Navigator.of(context).pop(), 
          );
        },
      );
    } else {
      print('Animal "$targetName" not found in organisms list.');
    }
}
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color(0xFF232E26),
    body: Builder( 
      builder: (BuildContext innerContext) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 10), 
              child: Center( 
                child: Text(
                    'Tap on the markers to explore endangered animals and their corresponding biorealms!', 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:  Color(0xFFB3CBB2), 
                    ),
                  ),
                ),
            ),
            
            Expanded( 
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: FlutterMap(
                  options: const MapOptions(
                    initialCenter: _pointCentral,
                    initialZoom: 1.8,
                    interactionOptions: InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(markers: _markers),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}}