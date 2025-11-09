import 'package:flutter/material.dart';
import '/pages/dropdownSelect.dart';
import 'package:flutter_application_1/components/image_carousel.dart';

class IntroCard extends StatefulWidget {
  const IntroCard({super.key});

  @override
  State<IntroCard> createState() => _IntroCardState();
}

class _IntroCardState extends State<IntroCard> {
  @override
  Widget build(BuildContext context) {
    return const IntroView();
  }
}

class IntroView extends StatelessWidget {
  const IntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 600),
      decoration: const BoxDecoration(
        color: Color(0xFF232E26),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 900;
          return Padding(
            padding: const EdgeInsets.all(40.0),
            child: isWideScreen
                ? _buildWideLayout()
                : _buildNarrowLayout(),
          );
        },
      ),
    );
  }

  // Layout for wide screens (desktop/tablet landscape)
  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left side: Text content
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: const Text(
                  'Your Ultimate Endangered Species Guide',
                  textAlign: TextAlign.center, 
                  style: TextStyle(
                    color: Color(0xFFD9EFDE),
                    fontSize: 60,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Did you know that there are more than 47,000 species that are threatened by extinction?',
                textAlign: TextAlign.center, 
                style: TextStyle(
                  color: Color(0xFFD9EFDE),
                  fontSize: 25,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: const Text(
                  'Generate a random endangered animal to learn more about!',
                  textAlign: TextAlign.center, // 💡 Also centering this text
                  style: TextStyle(
                    color: Color(0xFFD9EFDE),
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const DropdownSelect(),
            ],
          ),
        ),
        const SizedBox(width: 50),
        // Right side: Image
        Expanded(
          flex: 1,
          child:  ImageCarousel(),
         ),
      ],
    );
  }

  // Layout for narrow screens (mobile/tablet portrait)
  Widget _buildNarrowLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Your Ultimate Endangered Species Guide',
          textAlign: TextAlign.center, // 💡 Ensures text is centered
          style: TextStyle(
            color: Color(0xFFD9EFDE),
            fontSize: 36,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Did you know that there are more than 47,000 species that are threatened by extinction?',
          textAlign: TextAlign.center, // 💡 Also centering this text
          style: TextStyle(
            color: Color(0xFFD9EFDE),
            fontSize: 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 30),
        Container(
         child: ImageCarousel(),
        ),
        const SizedBox(height: 30),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Generate a random endangered animal to learn more about!',
              textAlign: TextAlign.center, // 💡 Also centering this text
              style: TextStyle(
                color: Color(0xFFD9EFDE),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 20),
            const DropdownSelect(),
          ],
        ),
      ],
    );
  }
}
