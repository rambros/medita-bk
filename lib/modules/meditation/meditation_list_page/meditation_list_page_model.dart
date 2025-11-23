import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'meditation_list_page_widget.dart' show MeditationListPageWidget;
import 'package:flutter/material.dart';

class MeditationListPageModel
    extends FlutterFlowModel<MeditationListPageWidget> {
  ///  Local state fields for this page.

  String order = 'mais reproduzidas';

  bool isOrdered = false;

  String textToSearch = '';

  bool isSearching = false;

  bool isFiltered = false;

  bool isFavourites = false;

  List<MeditationsRecord> listFavorites = [];
  void addToListFavorites(MeditationsRecord item) => listFavorites.add(item);
  void removeFromListFavorites(MeditationsRecord item) =>
      listFavorites.remove(item);
  void removeAtIndexFromListFavorites(int index) =>
      listFavorites.removeAt(index);
  void insertAtIndexInListFavorites(int index, MeditationsRecord item) =>
      listFavorites.insert(index, item);
  void updateListFavoritesAtIndex(
          int index, Function(MeditationsRecord) updateFn) =>
      listFavorites[index] = updateFn(listFavorites[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getFavoritesMeditations] action in LikeButton widget.
  List<MeditationsRecord>? listaMediticaoesFavoritas;
  // Stores action output result for [Bottom Sheet - sortMeditationsDialog] action in Button widget.
  String? orderString;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  List<MeditationsRecord>? listNumPlayed;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  List<MeditationsRecord>? listNewest;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  List<MeditationsRecord>? listFavourites;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  List<MeditationsRecord>? listLongest;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  List<MeditationsRecord>? listShortest;
  // Stores action output result for [Bottom Sheet - filterMeditationsDialog] action in Button widget.
  String? listaCategorias;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  List<MeditationsRecord>? listFiltered;
  // State field(s) for TextSearchField widget.
  FocusNode? textSearchFieldFocusNode;
  TextEditingController? textSearchFieldTextController;
  String? Function(BuildContext, String?)?
      textSearchFieldTextControllerValidator;
  // Algolia Search Results from action on TextSearchField
  List<MeditationsRecord>? algoliaSearchResults = [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textSearchFieldFocusNode?.dispose();
    textSearchFieldTextController?.dispose();
  }
}
