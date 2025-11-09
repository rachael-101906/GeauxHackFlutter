import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/signup_page.dart';
import '/pages/intro.dart';
import 'package:flutter_application_1/components/quiz_widget2.dart';
import 'login_page.dart';
import 'user_profile.dart';
//import 'signup_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            IntroCard(),
            AnimatedQuizSection(),
          ],
        ),
      ),
    );
  }
}

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 218, 236, 198),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: logo
          Row(
            children: [
              Image.asset(
                'assets/images/ecoeden.jpeg',
                fit: BoxFit.contain,
                height: 32,
              ),
              const SizedBox(width: 12),
            ],
          ),

          // Right: nav items
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNavItem(context, 'Home', '/home'),
                const SizedBox(width: 4),
                _buildNavItem(context, 'Gallery', '/gallery'),
                const SizedBox(width: 4),
                _buildNavItem(context, 'Map', '/map'),
                const SizedBox(width: 4),
                _buildNavItem(context, 'Quiz', '/quiz'),
                const SizedBox(width: 4),
                _buildSignuplogininButton(context, 'Sign Up/Log In', '/contact'),
                const SizedBox(width: 8),
                _buildUserprofileButton(context, 'User Profile', '/adopt'),
                const SizedBox(width: 8),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildNavItem(BuildContext context, String title, String route) {
  return TextButton(
    onPressed: () {
      Navigator.pushNamed(context, route);
    },
    style: TextButton.styleFrom(
      foregroundColor: Colors.black,
      minimumSize: Size.zero,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    child: Text(
      title,
      style: const TextStyle(color: Colors.black, fontSize: 10),
    ),
  );
}

Widget _buildSignuplogininButton(BuildContext context, String title, String route) {
  return OutlinedButton(
    onPressed: () {
      Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignupScreen()));
    },
    style: OutlinedButton.styleFrom(
      side: const BorderSide(
        width: 2,
        color: Color.fromARGB(255, 48, 67, 48),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12.0),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          width: 3,
          strokeAlign: BorderSide.strokeAlignOutside,
          color: Color(0xFF232D25),
        ),
        borderRadius: BorderRadius.circular(50),
      ),
    ),
    child: Text(
      title,
      style: const TextStyle(color: Colors.black, fontSize: 10),
    ),
  );
}

Widget _buildUserprofileButton(BuildContext context, String title, String route) {
  return ElevatedButton(
    onPressed: () {
           Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserProfileScreen()));
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 48, 67, 48),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12.0),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          width: 1,
          strokeAlign: BorderSide.strokeAlignOutside,
          color: Color(0xFF232D25),
        ),
        borderRadius: BorderRadius.circular(50),
      ),
    ),
    child: Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 10),
    ),
  );

}
