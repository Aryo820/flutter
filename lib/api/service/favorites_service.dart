import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _key = 'favorite_characters';

  Future<Set<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList(_key) ?? [];
    return favoriteIds.map((id) => int.parse(id)).toSet();
  }

  Future<void> toggleFavorite(int characterId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    if (favorites.contains(characterId)) {
      favorites.remove(characterId);
    } else {
      favorites.add(characterId);
    }

    await prefs.setStringList(
      _key,
      favorites.map((id) => id.toString()).toList(),
    );
  }

  Future<bool> isFavorite(int characterId) async {
    final favorites = await getFavorites();
    return favorites.contains(characterId);
  }
}
