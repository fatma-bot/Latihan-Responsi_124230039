import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latres/models/amiibo_model.dart';

class FavoriteService {
  static const String _key = 'favorite_amiibo';

  Future<List<AmiiboModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? dataString = prefs.getStringList(_key);

    if (dataString == null) return [];

    return dataString.map((item) {
      return AmiiboModel.fromJson(jsonDecode(item));
    }).toList();
  }

  Future<void> addFavorite(AmiiboModel amiibo) async {
    final prefs = await SharedPreferences.getInstance();
    final List<AmiiboModel> currentList = await getFavorites();

    if (!currentList.any((element) => element.tail == amiibo.tail)) {
      currentList.add(amiibo);
      _saveList(prefs, currentList);
    }
  }

  Future<void> removeFavorite(String tail) async {
    final prefs = await SharedPreferences.getInstance();
    final List<AmiiboModel> currentList = await getFavorites();

    currentList.removeWhere((item) => item.tail == tail);
    _saveList(prefs, currentList);
  }

  Future<bool> isFavorite(String tail) async {
    final List<AmiiboModel> currentList = await getFavorites();
    return currentList.any((item) => item.tail == tail);
  }

  Future<void> _saveList(
    SharedPreferences prefs,
    List<AmiiboModel> list,
  ) async {
    final List<String> stringList = list
        .map((item) => jsonEncode(item.toJson()))
        .toList();
    await prefs.setStringList(_key, stringList);
  }
}
