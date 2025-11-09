import 'package:flutter/material.dart';
import '../components/textfield.dart';

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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => DonationPopUp(),
                  );
                },
                child: const Text(
                  'Donate Now',
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

class DonationPopUp extends StatelessWidget {
  DonationPopUp({super.key});

  final _amount = TextEditingController();
  final _card = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Support Our Cause'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
              'Your donation helps us protect endangered species and their habitats.'),
          const SizedBox(height: 16),
          CustomTextField(
            hint: "Enter Donation Amount",
            label: "Amount",
            controller: _amount,
          ),
          const SizedBox(height: 8),
          CustomTextField(
            hint: "Enter Credit Card Number",
            label: "Credit Card",
            controller: _card,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () {
            // Close the donation dialog
            if (_amount.text.isNotEmpty && _card.text.isNotEmpty) {
              Navigator.of(context).pop();
            }

            // Only show thank-you message if both fields are filled
           
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Thank You!'),
                  content: const Text(
                    'Thank you for your support! Your donation will help protect endangered species.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            
          },
          child: const Text('Donate'),
        ),
      ],
    );
  }
}

