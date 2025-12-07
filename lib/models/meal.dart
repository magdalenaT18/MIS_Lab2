class Meal {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  bool isFavorite;

  Meal({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    this.isFavorite = false,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    idMeal: json['idMeal'],
    strMeal: json['strMeal'],
    strMealThumb: json['strMealThumb'],
  );
}
