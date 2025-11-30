import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/screens/search/search_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin SearchMixin {
  static void getRecentSearchList({required WidgetRef ref}) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> recentSearchData = sp.getStringList('recent_search_data') ?? [];
    ref.read(recentSearchDataProvider.notifier).update((state) => [...recentSearchData]);
  }

  Future addToSearchList({required String value, required WidgetRef ref}) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> searchData = ref.read(recentSearchDataProvider);
    searchData.add(value);
    await sp.setStringList('recent_search_data', searchData);
    ref.read(recentSearchDataProvider.notifier).update((state) => [...searchData]);
  }

  Future removeFromSearchList({required String value, required WidgetRef ref}) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> searchData = ref.read(recentSearchDataProvider);
    searchData.remove(value);
    await sp.setStringList('recent_search_data', searchData);
    ref.read(recentSearchDataProvider.notifier).update((state) => [...searchData]);
  }
}
