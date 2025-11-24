import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/ api_service.dart';

import 'meals_screen.dart';
import 'meal_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();

  List<Category> categories = [];
  List<Category> filteredCategories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  void loadCategories() async {
    List<Category> cats = await apiService.getCategories();
    setState(() {
      categories = cats;
      filteredCategories = cats;
      isLoading = false;
    });
  }

  void filterCategories(String query) {
    final filtered = categories.where((c) => c.strCategory.toLowerCase().contains(query.toLowerCase())).toList();
    setState(() {
      filteredCategories = filtered;
    });
  }

  void showRandomMeal() async {
    final randomMeal = await apiService.getRandomMeal();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MealDetailScreen(mealDetail: randomMeal)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.casino),
            onPressed: showRandomMeal,
            tooltip: 'Random meal',
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Search categories'),
              onChanged: filterCategories,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(category.strCategoryThumb, width: 60, fit: BoxFit.cover),
                    title: Text(category.strCategory),
                    subtitle: Text(
                      category.strCategoryDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MealsScreen(categoryName: category.strCategory),
                        ),
                      );
                    },
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
