import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:equatable/equatable.dart';
import '/ui/core/flutter_flow/lat_lng.dart';

export 'package:algolia/algolia.dart';

const kAlgoliaApplicationId = 'V99JCL8JRD';
const kAlgoliaApiKey = '107b743b8f80778d6e13db8d6c7772f3';

class AlgoliaQueryParams extends Equatable {
  const AlgoliaQueryParams(this.index, this.term, this.latLng, this.maxResults, this.searchRadiusMeters);
  final String index;
  final String? term;
  final LatLng? latLng;
  final int? maxResults;
  final double? searchRadiusMeters;

  @override
  List<Object?> get props => [index, term, latLng, maxResults, searchRadiusMeters];
}

class AlgoliaService {
  AlgoliaService._()
      : algolia = const Algolia.init(
          applicationId: kAlgoliaApplicationId,
          apiKey: kAlgoliaApiKey,
          extraUserAgents: ['FlutterFlow_3.1.0'],
        );
  final Algolia algolia;

  static AlgoliaService? _instance;
  static AlgoliaService get instance => _instance ??= AlgoliaService._();

  // Cache that will ensure identical queries are not repeatedly made.
  static final Map<AlgoliaQueryParams, List<AlgoliaObjectSnapshot>> _algoliaCache = {};

  Future<List<AlgoliaObjectSnapshot>> algoliaQuery({
    required String index,
    String? term,
    int? maxResults,
    FutureOr<LatLng>? location,
    double? searchRadiusMeters,
    bool useCache = false,
  }) async {
    // User must specify search term or location.
    if ((term ?? '').isEmpty && location == null) {
      return [];
    }
    LatLng? loc;
    if (location != null) {
      loc = await location;
    }
    final params = AlgoliaQueryParams(index, term, loc, maxResults, searchRadiusMeters);

    if (useCache && _algoliaCache.containsKey(params)) {
      return _algoliaCache[params]!;
    }

    AlgoliaQuery query = algolia.index(index);
    if (term != null) {
      query = query.query(term);
    }
    if (maxResults != null) {
      query = query.setHitsPerPage(maxResults);
    }
    if (loc != null) {
      query = query.setAroundLatLng('${loc.latitude},${loc.longitude}');
      query = query.setAroundRadius(searchRadiusMeters?.round() ?? 'all');
    }

    AlgoliaQuerySnapshot? snapshot;
    try {
      snapshot = await query.getObjects();
    } catch (error, stackTrace) {
      print('Algolia error: $error\nStack trace: $stackTrace');
    }
    return _algoliaCache[params] = snapshot?.hits ?? [];
  }
}
