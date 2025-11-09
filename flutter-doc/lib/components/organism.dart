
class Organism { 
  final String commonName;
  final String scientificName;
  final String bioRealm;
  final List<String> countries;
  final String redListCategory;
  final String url;
  final String imgPath;
  final int id;
  final String className;
  final String description;

  Organism({
    required this.commonName,
    required this.scientificName,
    required this.countries,
    required this.bioRealm,
    required this.redListCategory,
    required this.url,
    required this.imgPath,
    required this.id,
    required this.className,
    required this.description,
  });

  factory Organism.fromJson(Map<String, dynamic> json) {
  return Organism(
    commonName: json['common_name'] ?? 'Unknown',
    scientificName: json['scientific_name'] ?? 'Unknown',
    countries: List<String>.from(json['countries'] ?? []),
    bioRealm: json['biome'] ?? 'Unknown',
    redListCategory: json['redListCategory'] ?? json['category'] ?? 'Unknown',
    url: json['redlist_url'] ?? '',
    imgPath: json['imagePath'] ?? '',
    id: json['id'] ?? 0,
    className: json['class'] ?? 'Unknown',
    description: json['description'] ?? 'No description available.',
  );
}
}
