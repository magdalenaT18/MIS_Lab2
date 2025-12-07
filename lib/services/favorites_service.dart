class FavoritesService {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();


  final List<String> favoriteIds = [];

  bool isFavorite(String id) => favoriteIds.contains(id);

  void toggle(String id) {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
    } else {
      favoriteIds.add(id);
    }
  }
}
