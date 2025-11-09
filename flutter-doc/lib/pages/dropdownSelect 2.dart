import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';

class DropdownSelect extends StatefulWidget {
  const DropdownSelect({super.key});

  @override
  State<DropdownSelect> createState() => _DropdownSelectState();
}

class _DropdownSelectState extends State<DropdownSelect> {
  String? selectedType;
  List<dynamic>? organisms;
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isToolTipVisible = false;

  final List<String> types = [
    'Mammal',
    'Bird',
    'Reptile',
    'Amphibian',
    'Fish',
    'Insect',
  ];

  // Map dropdown values to JSON class names
  final Map<String, String> typeToClass = {
    'Mammal': 'Mammalia',
    'Bird': 'Aves',
    'Reptile': 'Reptilia',
    'Amphibian': 'Amphibia',
    'Fish': 'Pisces',
    'Insect': 'Insecta',
  };

  @override
  void initState() {
    super.initState();
    _loadOrganisms();
  }

  @override
  void dispose() {
    _removeToolTip();
    super.dispose();
  }

  Future<void> _loadOrganisms() async {
    String jsonString = await rootBundle.loadString('assets/databases/organismsList.json');
    setState(() {
      organisms = json.decode(jsonString);
    });
  }

  void _showToolTip(String animalName, String description, String imagePath) {
    _removeToolTip();

    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final RenderBox renderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeToolTip,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [  
            Container(color: Colors.transparent),

            Positioned(
              left: offset.dx,
              top: offset.dy - 320, 
              child: AnimalToolTip(
                animalName: animalName,
                description: description,
                imagePath: imagePath,
                onDismiss: _removeToolTip,
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeToolTip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isToolTipVisible = false);
  }

  void _generateRandomAnimal() {
    if (selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a type'),
          backgroundColor: Color(0xFF232E26),
        ),
      );
      return;
    }

    setState(() => _isToolTipVisible = true);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (organisms == null) return;

      List<dynamic> filteredList = organisms!.where((organism) => organism['class'] == selectedType).toList();
      
      if (filteredList.isEmpty) {
        setState(() => _isToolTipVisible = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No animals found for $selectedType'),
            backgroundColor: Color(0xFF232E26),
          ),
        );
        return;
      }

      int randomIndex = Random().nextInt(filteredList.length);
      String animalName = filteredList[randomIndex]['common_name'];
      String description = filteredList[randomIndex]['description'] ?? 'No description available';
      String imagePath = filteredList[randomIndex]['imagePath'];

      _showToolTip(animalName, description, imagePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            SizedBox(width: 250, child: _buildTypeDropdown()),
          ],
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            key: _buttonKey,
            onPressed: _isToolTipVisible ? null : _generateRandomAnimal,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD9EFDE),
              foregroundColor: const Color(0xFF232E26),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              minimumSize: const Size(30, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Generate!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeDropdown() {
    return DropdownContainer(
      value: selectedType,
      hint: 'Select Type',
      items: types,
      onChanged: (val) => setState(() => selectedType = val),
    );
  }
}

class DropdownContainer extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownContainer({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value != null ? const Color(0xFF68B684) : const Color(0xFFD9EFDE),
          width: 2,
        ),
        boxShadow: value != null
            ? [
                BoxShadow(
                  color: const Color(0xFF68B684).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: Colors.grey)),
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down_circle,
            color: value != null ? const Color(0xFF68B684) : const Color(0xFF232E26),
          ),
          dropdownColor: Colors.white,
          style: const TextStyle(
            color: Color(0xFF232E26),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          onChanged: onChanged,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        ),
      ),
    );
  }
}

class AnimalToolTip extends StatefulWidget {
  final String animalName;
  final String description;
  final String imagePath;
  final VoidCallback onDismiss;

  const AnimalToolTip({
    super.key,
    required this.animalName,
    required this.description,
    required this.imagePath,
    required this.onDismiss,
  });

  @override
  _AnimalToolTipState createState() => _AnimalToolTipState();
}

class _AnimalToolTipState extends State<AnimalToolTip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(_fadeAnimation);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 360,
            decoration: BoxDecoration(
              color: const Color(0xFFD9EFDE),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 24,
                  offset: const Offset(0, 12),
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
                      child: Image.network(
                        widget.imagePath,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: const Color(0xFF68B684),
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.white,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: const Color(0xFF68B684),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: InkWell(
                        onTap: widget.onDismiss,
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
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
                        widget.animalName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF232E26),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF232E26),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}