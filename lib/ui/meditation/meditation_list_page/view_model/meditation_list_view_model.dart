import 'package:flutter/material.dart';
import '/data/models/firebase/meditation_model.dart';
import '/data/repositories/meditation_repository.dart';
import '/data/repositories/auth_repository.dart';

class MeditationListViewModel extends ChangeNotifier {
  final MeditationRepository _meditationRepository;
  final AuthRepository _authRepository;

  MeditationListViewModel({
    required MeditationRepository meditationRepository,
    required AuthRepository authRepository,
  })  : _meditationRepository = meditationRepository,
        _authRepository = authRepository;

  Stream<List<MeditationModel>> get meditationsStream => _meditationRepository.getMeditations();

  // State
  bool _isSearching = false;
  bool get isSearching => _isSearching;

  bool _isFiltered = false;
  bool get isFiltered => _isFiltered;

  bool _isOrdered = false;
  bool get isOrdered => _isOrdered;

  bool _isFavourites = false;
  bool get isFavourites => _isFavourites;

  String _orderString = '';
  String get orderString => _orderString;
  set orderString(String value) {
    _orderString = value;
    notifyListeners();
  }

  String _listaCategorias = '';
  String get listaCategorias => _listaCategorias;
  set listaCategorias(String value) {
    _listaCategorias = value;
    notifyListeners();
  }

  // Text Controller for Search
  TextEditingController? textSearchFieldTextController;
  FocusNode? textSearchFieldFocusNode;
  String? Function(BuildContext, String?)? get textSearchFieldTextControllerValidator => null;

  // Data Lists
  List<MeditationModel>? _algoliaSearchResults;
  List<MeditationModel>? get algoliaSearchResults => _algoliaSearchResults;

  List<MeditationModel>? _listFiltered;
  List<MeditationModel>? get listFiltered => _listFiltered;

  List<MeditationModel>? _listNumPlayed;
  List<MeditationModel>? get listNumPlayed => _listNumPlayed;

  List<MeditationModel>? _listNewest;
  List<MeditationModel>? get listNewest => _listNewest;

  List<MeditationModel>? _listFavourites;
  List<MeditationModel>? get listFavourites => _listFavourites; // For ordered by favourites

  List<MeditationModel>? _listLongest;
  List<MeditationModel>? get listLongest => _listLongest;

  List<MeditationModel>? _listShortest;
  List<MeditationModel>? get listShortest => _listShortest;

  List<MeditationModel> _userFavorites = [];
  List<MeditationModel> get userFavorites => _userFavorites; // For favorites toggle

  void initState() {
    textSearchFieldTextController = TextEditingController();
    textSearchFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    textSearchFieldTextController?.dispose();
    textSearchFieldFocusNode?.dispose();
    super.dispose();
  }

  void toggleSearching() {
    _isSearching = true;
    notifyListeners();
  }

  void cancelSearching() {
    _isSearching = false;
    textSearchFieldTextController?.clear();
    _algoliaSearchResults = null;
    notifyListeners();
  }

  Future<void> search(String term) async {
    if (term.isEmpty) {
      _algoliaSearchResults = null;
      notifyListeners();
      return;
    }
    try {
      _algoliaSearchResults = await _meditationRepository.searchMeditations(term);
    } catch (e) {
      _algoliaSearchResults = [];
    }
    notifyListeners();
  }

  Future<void> applyFilter(String category) async {
    _listaCategorias = category;
    if (_listaCategorias.isEmpty) {
      _isFiltered = false;
      notifyListeners();
      return;
    }

    _isFiltered = true;
    _isSearching = false;
    _isFavourites = false;
    notifyListeners();

    // Note: The original code used `arrayContains` with a single string, which implies 'category' field in Firestore is a list of strings.
    // The repository method expects a List<String>.
    _listFiltered = await _meditationRepository.getMeditationsFiltered([_listaCategorias]);
    notifyListeners();
  }

  Future<void> applySort(String order) async {
    _orderString = order;
    _isOrdered = true;
    _isFiltered = false;
    _isSearching = false;
    _isFavourites = false;
    notifyListeners();

    if (order == 'orderByNumPlayed') {
      _listNumPlayed = await _meditationRepository.getMeditationsOrdered(order);
    } else if (order == 'orderByNewest') {
      _listNewest = await _meditationRepository.getMeditationsOrdered(order);
    } else if (order == 'orderByFavourites') {
      _listFavourites = await _meditationRepository.getMeditationsOrdered(order);
    } else if (order == 'orderByLongest') {
      _listLongest = await _meditationRepository.getMeditationsOrdered(order);
    } else if (order == 'orderByShortest') {
      _listShortest = await _meditationRepository.getMeditationsOrdered(order);
    }
    notifyListeners();
  }

  Future<void> toggleFavorites() async {
    _isFavourites = !_isFavourites;
    _isSearching = false;
    _isFiltered = false;
    _isOrdered = false;
    notifyListeners();

    if (_isFavourites) {
      final userId = _authRepository.currentUserUid;
      if (userId.isEmpty) {
        _userFavorites = [];
      } else {
        _userFavorites = await _meditationRepository.getFavoriteMeditations(userId);
      }
      if (_userFavorites.isEmpty) {
        _isFavourites = false; // Revert if no favorites
      }
    } else {
      _userFavorites = [];
    }
    notifyListeners();
  }
}
