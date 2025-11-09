import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color.fromARGB(255, 218, 236, 198),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header text
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                height: 100,
                width: 150,
                child: Image.asset(
                  'assets/images/ecoeden.jpeg',
                  fit: BoxFit.contain,
                ),
              ),
                SizedBox(width: 20),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Creating a better world for all its inhabitants.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                  fontSize: 16,
                ),
          ),

          const SizedBox(height: 60),

          // Divider
          const Divider(thickness: 1, color: Color(0xFFB3CBB2)),
          const SizedBox(height: 20),

          // Bottom info row
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 30,
            children: [
              Text(
                '© 2025 EcoEden',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Contact Us',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
