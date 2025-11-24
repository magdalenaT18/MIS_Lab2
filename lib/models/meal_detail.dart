class MealDetail {
  final String idMeal;
  final String strMeal;
  final String strInstructions;
  final String strMealThumb;
  final String? strYoutube;
  final Map<String, String> ingredients;

  MealDetail({
    required this.idMeal,
    required this.strMeal,
    required this.strInstructions,
    required this.strMealThumb,
    this.strYoutube,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    Map<String, String> ingredients = {};
    for (var i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'] as String?;
      final measure = json['strMeasure$i'] as String?;
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients[ingredient] = measure ?? '';
      }
    }
    return MealDetail(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strInstructions: json['strInstructions'],
      strMealThumb: json['strMealThumb'],
      strYoutube: json['strYoutube'],
      ingredients: ingredients,
    );
  }
}
