import 'package:flutter/material.dart';
import 'package:pozitivity/screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "text": "Her gün daha iyi hisset.",
      "subtitle":
          "Olumlamaların gücüyle pozitif enerjini yükselt ve günü daha iyi karşıla.",
    },
    {
      "text": "Sana özel olumlama kategorileri.",
      "subtitle":
          "Kariyer, huzur ve güven gibi farklı yaşam alanlarında kişisel desteğini seç.",
    },
    {
      "text": "Favorilerini kaydet.",
      "subtitle":
          "Sana en iyi gelen olumlamaları işaretle ve onlara kolayca ulaş.",
    },
  ];

  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    const Color backgroundColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingData.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingCard(
                    title: onboardingData[index]['text']!,
                    subtitle: onboardingData[index]['subtitle']!,
                    decoration: DynamicStarDecoration(
                      starCount:
                          15,
                      baseColor: Colors.yellow.withOpacity(0.4),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                  (index) => buildDot(index, context, primaryColor),
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage == onboardingData.length - 1) {
                    _finishOnboarding();
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeIn,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 175, 202, 176),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
                child: Text(
                  _currentPage == onboardingData.length - 1 ? 'Başla' : 'İleri',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDot(int index, BuildContext context, Color primaryColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: _currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? primaryColor
            : primaryColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class OnboardingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget decoration;

  const OnboardingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        decoration,

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DynamicStarDecoration extends StatelessWidget {
  final int starCount; // Toplam yıldız
  final Color baseColor;

  const DynamicStarDecoration({
    super.key,
    this.starCount = 10,
    this.baseColor = const Color(0xFFF7C351),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final random = Random();
        List<Widget> stars = [];

        for (int i = 0; i < starCount; i++) {
          final double size =
              random.nextDouble() * 15 + 10;
          final double opacity =
              random.nextDouble() * 0.4 + 0.3;
          final double left = random.nextDouble() * constraints.maxWidth;
          final double top = random.nextDouble() * constraints.maxHeight;

          stars.add(
            Positioned(
              left: left,
              top: top,
              child: Transform.rotate(
                angle: random.nextDouble() *
                    pi *
                    2,
                child: Icon(
                  Icons.star,
                  color: baseColor.withOpacity(opacity),
                  size: size,
                ),
              ),
            ),
          );
        }
        return Stack(children: stars);
      },
    );
  }
}
