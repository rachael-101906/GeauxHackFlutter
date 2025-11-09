import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/quiz_widget2.dart';
import 'package:flutter_application_1/pages/footer.dart';
import '/pages/intro.dart';
import '/pages/quizView.dart';
import '/pages/map_markers.dart';
import 'signup_page.dart';
import 'user_profile.dart';
import 'view_all.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _introKey = GlobalKey();
  final GlobalKey _mapKey = GlobalKey();
  final GlobalKey _quizKey = GlobalKey();

  void _scrollToSection(GlobalKey sectionKey) {
    final context = sectionKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showProfileModal() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'User Profile',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            child: Container(
            width: 350,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 218, 236, 198),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(-5, 0),
                ),
              ],
            ),
            child: const UserProfileScreen(),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
    );
  }

    void _showQuizModal() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB3CBB2),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Endangered Species Quiz',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF232D25),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          color: const Color(0xFF232D25),
                        ),
                      ],
                    ),
                  ),
                  Expanded( 
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: AnimatedQuizSection(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: NavBar(
          onHomeTap: () => _scrollToSection(_introKey),
          onMapTap: () => _scrollToSection(_mapKey),
          onQuizTap: () => _scrollToSection(_quizKey),
          onProfileTap: _showProfileModal, 
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              IntroCard(key: _introKey),
              Container(
                key: _quizKey,
                child: QuizUI(
                  onQuizButtonPressed: _showQuizModal,
                ),
              ),
              SizedBox(
                height: 500,
                child: MapMarkersPage(key: _mapKey),
              ),
              const AppFooter(),
            ],
          ),
        ),
      );
    }
  }

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onMapTap;
  final VoidCallback onQuizTap;
  final VoidCallback onProfileTap; 

  const NavBar({
    super.key,
    required this.onHomeTap,
    required this.onMapTap,
    required this.onQuizTap,
    required this.onProfileTap, 
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0.0,
      backgroundColor: const Color.fromARGB(255, 218, 236, 198),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 100,
                width: 150,
                child: Image.asset(
                  'assets/images/ecoeden.jpeg',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNavItem('Home', onHomeTap),
                const SizedBox(width: 15),
                _buildNavItem('Quiz', onQuizTap),
                const SizedBox(width: 15),
                _buildNavItem('Map', onMapTap),
                const SizedBox(width: 4),
                _buildViewAllButton(context, 'View All Species'),
                const SizedBox(width: 8),
                _buildSignUpLoginButton(context, 'Sign Up/Log In'),
                const SizedBox(width: 15),
                _buildUserProfileButton('User Profile', onProfileTap), 
                const SizedBox(width: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }

  

  Widget _buildNavItem(String title, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.black, fontSize: 18),
      ),
    );
  }

  Widget _buildViewAllButton(BuildContext context, String title) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ViewAllPage()),
        );
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          width: 2,
          color: Color.fromARGB(255, 48, 67, 48),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.black, fontSize: 12),
      ),
    );
  }


  Widget _buildSignUpLoginButton(BuildContext context, String title) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignupScreen()),
        );
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          width: 2,
          color: Color.fromARGB(255, 48, 67, 48),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.black, fontSize: 20),
      ),
    );
  }


  Widget _buildUserProfileButton(String title, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 48, 67, 48),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        side: const BorderSide(
          width: 2,
          color: Color(0xFF232D25),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}