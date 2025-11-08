import 'package:flutter/material.dart';

class DropdownSelect extends StatefulWidget {
  const DropdownSelect({super.key});

  @override
  State<DropdownSelect> createState() => _DropdownSelectState();
}

class _DropdownSelectState extends State<DropdownSelect> {
  String? selectedType;
  String? selectedBiome;
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

  final List<String> biomes = [
    'Forest',
    'Desert',
    'Grassland',
    'Tundra',
    'Freshwater',
    'Marine',
  ];

  @override
  void dispose() {
    _removeToolTip();
    super.dispose();
  }

  void _showToolTip(String animalName, String description) {
    _removeToolTip();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlay = Overlay.of(context);
      if (overlay == null) return;

      _overlayEntry = OverlayEntry(
        builder: (context) => GestureDetector(
          onTap: _removeToolTip,
          behavior: HitTestBehavior.translucent,
          child: Container(
            color: Colors.transparent,
            child: AnimalToolTip(
              targetKey: _buttonKey,
              animalName: animalName,
              description: description,
              onDismiss: _removeToolTip,
            ),
          ),
        ),
      );

      overlay.insert(_overlayEntry!);
    });
  }

  void _removeToolTip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: _buildTypeDropdown()),
            const SizedBox(width: 20),
            Expanded(child: _buildBiomeDropdown()),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          key: _buttonKey,
          onPressed: !_isToolTipVisible ? _generateRandomAnimal : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD9EFDE),
            foregroundColor: const Color(0xFF232E26),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Generate Random Animal',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9EFDE), width: 2),
      ),
      child: DropdownButton<String>(
        value: selectedType,
        hint: const Text(
          'Select Type',
          style: TextStyle(color: Colors.grey),
        ),
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF232E26)),
        style: const TextStyle(color: Color(0xFF232E26), fontSize: 16),
        dropdownColor: Colors.white,
        onChanged: (String? newValue) {
          setState(() {
            selectedType = newValue;
          });
        },
        items: types.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBiomeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9EFDE), width: 2),
      ),
      child: DropdownButton<String>(
        value: selectedBiome,
        hint: const Text(
          'Select Biome',
          style: TextStyle(color: Colors.grey),
        ),
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF232E26)),
        style: const TextStyle(color: Color(0xFF232E26), fontSize: 16),
        dropdownColor: Colors.white,
        onChanged: (String? newValue) {
          setState(() {
            selectedBiome = newValue;
          });
        },
        items: biomes.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  void _generateRandomAnimal() {
    if (selectedType == null || selectedBiome == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both a type and a biome'),
          backgroundColor: Color(0xFF232E26),
        ),
      );
    } else {
      // Example logic (replace with actual implementation)
      setState(() {
        _isToolTipVisible = true;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        String animalName = 'Sample Animal';
        String description = 'This is a sample description of the animal.';

        setState(() {
          _isToolTipVisible = false;
        });

        _showToolTip(animalName, description);
      });
    }
  }
}

class AnimalToolTip extends StatefulWidget {
  final String animalName;
  final GlobalKey? targetKey;
  final String description;
  final VoidCallback onDismiss;

  const AnimalToolTip({
    super.key,
    required this.animalName,
    required this.description,
    required this.targetKey,
    required this.onDismiss,
  });

  @override
  _AnimalToolTipState createState() => _AnimalToolTipState();
}

class _AnimalToolTipState extends State<AnimalToolTip>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Offset _getToolTipPosition() {
    final RenderBox renderBox =
        widget.targetKey!.currentContext!.findRenderObject() as RenderBox;

    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    return Offset(offset.dx + size.width / 2, offset.dy);
  }

  @override
  Widget build(BuildContext context) {
    final toolTipPosition = _getToolTipPosition();

    return Positioned(
      left: toolTipPosition.dx,
      top: toolTipPosition.dy - 10,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD9EFDE),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/intro_picture.jpg',
                      width: double.infinity,
                      height: 100,
                    ),
                    tooltip: 'Close',
                    iconSize: 100,
                    onPressed: () {
                      widget.onDismiss();
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          widget.animalName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF232E26),
                          ),
                        ),
                        Text(
                          widget.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF232E26),
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
      ),
    );
  }
}
