
class Organism { 
  final String commonName;
  final String scientificName;
  final String bioRealm;
  final List<String> countries;
  final String redListCategory;
  final String url;
  final int id;
  final String className;

  Organism({
    required this.commonName,
    required this.scientificName,
    required this.countries,
    required this.bioRealm,
    required this.redListCategory,
    required this.url,
    required this.id,
    required this.className,
  });

  factory Organism.fromJson(Map<String, dynamic> json){
    return Organism(
      commonName: json['common_name'],
      scientificName: json['scientific_name'],
      countries: List<String>.from(json['countries'] ?? []),
      bioRealm: json['biome'],
      redListCategory: json['category'],
      url: json['redlist_url'],
      id: json['id'],
      className: json['class'],
    );
  }
}