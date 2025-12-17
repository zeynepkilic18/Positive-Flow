import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AffirmationsScreen extends StatelessWidget {
  final String categoryName;
  final Color categoryColor;

  const AffirmationsScreen({
    super.key,
    required this.categoryName,
    required this.categoryColor,
  });

  Future<List<String>> fetchAffirmations() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('affirmations')
        .where('category', isEqualTo: categoryName)
        .get();

    return querySnapshot.docs.map((doc) => doc['text'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<String>>(
        future: fetchAffirmations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Bu kategoriye ait olumlama yok.'));
          } else {
            final affirmations = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: affirmations.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Card(
                    color: categoryColor.withOpacity(0.1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        affirmations[index],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
