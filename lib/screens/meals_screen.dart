import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';
import 'meal_detail_screen.dart';

class MealsScreen extends StatefulWidget {
  final String categoryName;

  const MealsScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final ApiService apiService = ApiService();
  final FavoritesService favoritesService = FavoritesService();

  List<Meal> meals = [];
  List<Meal> filteredMeals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  void loadMeals() async {
    List<Meal> ms = await apiService.getMealsByCategory(widget.categoryName);
    setState(() {
      meals = ms;
      filteredMeals = ms;
      isLoading = false;
    });
  }

  void filterMeals(String query) async {
    if (query.isEmpty) {
      setState(() => filteredMeals = meals);
    } else {
      List<Meal> searchedMeals = await apiService.searchMeals(query);
      searchedMeals = searchedMeals
          .where((m) => m.idMeal != null && m.idMeal.isNotEmpty)
          .toList();
      setState(() {
        filteredMeals = searchedMeals.where((m) => m.idMeal != null).toList();
      });
    }
  }

  void toggleFavorite(String mealId) {
    setState(() {
      favoritesService.toggle(mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration:
              const InputDecoration(labelText: 'Search meals'),
              onChanged: filterMeals,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 3 / 4,
              ),
              itemCount: filteredMeals.length,
              itemBuilder: (context, index) {
                final meal = filteredMeals[index];
                final isFavorite =
                favoritesService.isFavorite(meal.idMeal);

                return GestureDetector(
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
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8)),
                            child: Image.network(
                              meal.strMealThumb,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  meal.strMeal,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    toggleFavorite(meal.idMeal),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
