import 'package:flutter/material.dart';
import '../models/meal_detail.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetailScreen extends StatelessWidget {
  final MealDetail mealDetail;
  const MealDetailScreen({super.key, required this.mealDetail});

  void _launchYoutube(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(mealDetail.strMeal)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(mealDetail.strMealThumb),
            const SizedBox(height: 16),
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            for (var entry in mealDetail.ingredients.entries)
              Text('${entry.key} - ${entry.value}'),
            const SizedBox(height: 16),
            Text(
              'Instructions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(mealDetail.strInstructions),
            if (mealDetail.strYoutube != null && mealDetail.strYoutube!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton.icon(
                  onPressed: () => _launchYoutube(mealDetail.strYoutube!),
                  icon: const Icon(Icons.video_library),
                  label: const Text('Watch on YouTube'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
