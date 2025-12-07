// lib/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import '../models/meal.dart';

import '../services/api_service.dart';
import '../services/favorites_service.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService favoritesService = FavoritesService();
  final ApiService apiService = ApiService();

  bool isLoading = true;
  List<Meal> favoriteMeals = [];

  @override
  void initState() {
    super.initState();
    loadFavoriteMeals();
  }

  Future<void> loadFavoriteMeals() async {
    // за секое ID повикај detail API (ќе добиеш MealDetail, но можеш и само Meal со thumb/name)
    final List<Meal> result = [];
    for (final id in favoritesService.favoriteIds) {
      final detail = await apiService.getMealDetails(id); // враќа MealDetail
      // направи „лесен“ Meal од MealDetail
      result.add(Meal(
        idMeal: detail.idMeal,
        strMeal: detail.strMeal,
        strMealThumb: detail.strMealThumb,
      ));
    }
    setState(() {
      favoriteMeals = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite meals')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteMeals.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
        itemCount: favoriteMeals.length,
        itemBuilder: (context, index) {
          final meal = favoriteMeals[index];
          return ListTile(
            leading: Image.network(
              meal.strMealThumb,
              width: 56,
              fit: BoxFit.cover,
            ),
            title: Text(meal.strMeal),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                setState(() {
                  favoritesService.toggle(meal.idMeal);
                  favoriteMeals.removeAt(index);
                });
              },
            ),
            onTap: () async {
              final detail =
              await apiService.getMealDetails(meal.idMeal);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MealDetailScreen(mealDetail: detail),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
