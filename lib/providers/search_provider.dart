import 'package:flutter/material.dart';
import 'package:hadith_reader/model/hadith_model.dart';
import 'package:hadith_reader/service/hadith_service.dart';

class SearchProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  final List<HadithModel> _filteredHadiths = [];
  List<HadithModel> get filteredHadiths => _filteredHadiths;

  int _currentPage = 1;
  bool _isLoading = false;
  bool hasMore = false;
  String _lastQuery = '';

  ScrollController scrollController = ScrollController();

  SearchProvider() {
    searchController.addListener(_onSearchChanged);
    scrollController.addListener(_onScroll);
    _fetchHadiths();
    debugPrint("SearchProvider initialized.");
  }

  Future<void> _fetchHadiths({bool isNewSearch = false}) async {
    if (_isLoading) {
      debugPrint("Fetch blocked: Already loading.");
      return;
    }
    if (!hasMore) {
      debugPrint("Fetch blocked: No more data to load.");
      return;
    }

    debugPrint(
        "Fetching hadiths... isNewSearch: $isNewSearch | Page: $_currentPage | Query: '$_lastQuery'");

    _isLoading = true;
    notifyListeners();

    if (isNewSearch) {
      debugPrint("Resetting data for new search...");
      _currentPage = 1;
      _filteredHadiths.clear();
      hasMore = true;
    }

    try {
      List<HadithModel> newHadiths = await HadithService.fetchHadiths(
          page: _currentPage, query: _lastQuery);

      if (newHadiths.isEmpty) {
        debugPrint("No new Hadiths found. Setting hasMore to false.");
        hasMore = false;
      } else {
        // Apply filtering but maintain pagination
        List<HadithModel> filteredNewHadiths = newHadiths
            .where((hadith) =>
                hadith.hadithEnglish.toLowerCase().contains(_lastQuery))
            .toList();

        if (filteredNewHadiths.isEmpty && _filteredHadiths.isEmpty) {
          // If filtered results are empty from the first page, stop loading
          hasMore = false;
        } else {
          _filteredHadiths.addAll(filteredNewHadiths);
          _currentPage++;
          debugPrint(
              "Fetched ${newHadiths.length} Hadiths, Filtered: ${filteredNewHadiths.length}, Total: ${_filteredHadiths.length}");
        }
      }
    } catch (e) {
      debugPrint("Error fetching hadiths: $e");
    }

    _isLoading = false;
    notifyListeners();
    debugPrint("_isLoading set to false. UI should update.");
  }

  void _onSearchChanged() {
    final query = searchController.text.trim().toLowerCase();
    debugPrint("Search changed: '$query'");

    if (query != _lastQuery) {
      _lastQuery = query;
      hasMore = true;
      debugPrint("New search query detected. Resetting data.");
      _fetchHadiths(isNewSearch: true);
    }
  }

  void _onScroll() {
    debugPrint(
        "Scrolling... Position: ${scrollController.position.pixels}, Max: ${scrollController.position.maxScrollExtent}");

    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100 &&
        !_isLoading) {
      debugPrint("Reached near the bottom. Fetching more Hadiths...");
      _fetchHadiths();
    }
  }

  @override
  void dispose() {
    debugPrint("Disposing SearchProvider...");
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
