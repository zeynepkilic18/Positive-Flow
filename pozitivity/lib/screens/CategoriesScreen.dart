import 'package:flutter/material.dart';
import 'package:pozitivity/card/CategoryCard.dart';
import 'package:pozitivity/screens/AffirmationsScreen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      'name': 'Kendine Güven',
      'icon': Icons.accessibility_new,
      'color': Color(0xFFF7C351)
    },
    {
      'name': 'Başarı ve Kariyer',
      'icon': Icons.trending_up,
      'color': Color(0xFFE56A6A)
    },
    {
      'name': 'Huzur ve Rahatlama',
      'icon': Icons.spa,
      'color': Color(0xFF5ABF77)
    },
    {
      'name': 'Aşk & İlişkiler',
      'icon': Icons.favorite,
      'color': Color(0xFFE788A8)
    },
    {
      'name': 'Sağlık ve Zindelik',
      'icon': Icons.self_improvement,
      'color': Color(0xFF9B59B6)
    },
    {
      'name': 'Yaratıcılık ve İlham',
      'icon': Icons.lightbulb_outline,
      'color': Color(0xFFF1C40F)
    },
  ];

  @override
  Widget build(BuildContext context) {
    const Color screenBackgroundColor = Color(0xFFF0F5F1);

    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: screenBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Kategoriler',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: CategoryCard(
              name: category['name'] as String,
              icon: category['icon'] as IconData,
              color: category['color'] as Color,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AffirmationsScreen(
                      categoryName: category['name'] as String,
                      categoryColor: category['color'] as Color,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
