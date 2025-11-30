import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/ads/ad_manager.dart';
import 'package:lms_app/ads/banner_ad.dart';
import 'package:lms_app/components/loading_grid_tile.dart';
import 'package:lms_app/configs/app_assets.dart';
import 'package:lms_app/constants/custom_colors.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/screens/all_courses.dart/grid_list_course_tile.dart';
import 'package:lms_app/screens/search/search_view.dart';
import 'package:lms_app/services/firebase_service.dart';
import 'package:lms_app/theme/theme_provider.dart';
import 'package:lms_app/utils/empty_animation.dart';
import 'package:lms_app/utils/loading_widget.dart';
import 'package:lms_app/utils/next_screen.dart';
import 'grid_course_tile.dart';

enum GridStyle { grid, box, list }

enum CourseBy {
  latest,
  category,
  free,
  tag,
  author,
}

final gridStyleProvider = StateProvider<GridStyle>((ref) => GridStyle.list);

class AllCoursesView extends ConsumerStatefulWidget {
  const AllCoursesView({super.key, required this.courseBy, this.categoryId, this.tagId, this.authorId, required this.title});

  final String title;
  final CourseBy courseBy;
  final String? categoryId, tagId, authorId;

  @override
  ConsumerState<AllCoursesView> createState() => _AllCoursesViewState();
}

class _AllCoursesViewState extends ConsumerState<AllCoursesView> {
  List<Course> _courses = [];
  bool _hasData = false;
  bool _isLoading = true;
  DocumentSnapshot? _lastDocument;
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController(initialScrollOffset: 0.0);
    _controller.addListener(_scrollListener);
    super.initState();
    _getData();
  }

  _scrollListener() async {
    var isEnd = _controller.offset >= _controller.position.maxScrollExtent && !_controller.position.outOfRange;
    if (isEnd) {
      _getData();
    }
  }

  Future<QuerySnapshot> _getCourseQuery() async {
    QuerySnapshot snapshot;
    if (widget.courseBy == CourseBy.latest) {
      snapshot = await FirebaseService().getCoursesSnapshotByLatest(lastDocument: _lastDocument);
    } else if (widget.courseBy == CourseBy.category) {
      snapshot = await FirebaseService().getCoursesSnapshotByCategory(categoryId: widget.categoryId!, lastDocument: _lastDocument);
    } else if (widget.courseBy == CourseBy.free) {
      snapshot = await FirebaseService().getCoursesSnapshotByFreeCourses(lastDocument: _lastDocument);
    } else if (widget.courseBy == CourseBy.tag) {
      snapshot = await FirebaseService().getCoursesSnapshotByTag(tagId: widget.tagId!, lastDocument: _lastDocument);
    } else if (widget.courseBy == CourseBy.author) {
      snapshot = await FirebaseService().getCoursesSnapshotByAuhtor(authorId: widget.authorId!, lastDocument: _lastDocument);
    } else {
      snapshot = await FirebaseService().getCoursesSnapshotByLatest(lastDocument: _lastDocument);
    }
    return snapshot;
  }

  _getData() async {
    if (_lastDocument == null) {
      await _getCourseQuery().then((QuerySnapshot snapshot) {
        _courses = snapshot.docs.map((e) => Course.fromFirestore(e)).toList();
        _lastDocument = snapshot.docs.last;
        _isLoading = false;
        setState(() {});
      }).catchError((e) => _handleError(e.toString()));
    } else {
      _hasData = true;
      setState(() {});
      await _getCourseQuery().then((QuerySnapshot? snapshot) {
        _courses.addAll(snapshot!.docs.map((e) => Course.fromFirestore(e)).toList());
        _lastDocument = snapshot.docs.last;
        _hasData = false;
        setState(() {});
      }).catchError((e) => _handleError(e.toString()));
    }
  }

  _handleError(String error) {
    setState(() {
      _isLoading = false;
      _hasData = false;
    });
    debugPrint(error);
  }

  _onRefresh() async {
    _isLoading = true;
    _courses.clear();
    _hasData = false;
    _lastDocument = null;
    setState(() {});
    await _getData();
  }

  @override
  Widget build(BuildContext context) {
    final gridStyle = ref.watch(gridStyleProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        centerTitle: true,
        titleSpacing: 0,
        elevation: 0,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FeatherIcons.chevronLeft)),
        actions: [
          IconButton(
            style: IconButton.styleFrom(padding: const EdgeInsets.only(right: 10)),
            icon: const Icon(FeatherIcons.search),
            onPressed: () => NextScreen.normal(context, const SearchScreen()),
          ),
        ],
      ),
      bottomNavigationBar: AdManager.isBannerEnbaled(ref) ? const BannerAdWidget() : null,
      body: RefreshIndicator(
        onRefresh: () async => await _onRefresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _controller,
          child: Column(
            children: [
              FilterContainer(gridStyle: gridStyle, ref: ref),
              _isLoading
                  ? LoadingGridTile(gridStyle: gridStyle)
                  : _courses.isEmpty
                      ? EmptyAnimation(animationString: emptyAnimation, title: 'no-course'.tr())
                      : GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(20),
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: gridStyle == GridStyle.grid ? 2 : 1,
                            mainAxisExtent: gridStyle == GridStyle.grid
                                ? 250
                                : gridStyle == GridStyle.box
                                    ? 300
                                    : 170,
                            childAspectRatio: gridStyle == GridStyle.grid
                                ? 0.68
                                : gridStyle == GridStyle.box
                                    ? 1.3
                                    : 2.1,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: _courses.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Course course = _courses[index];
                            if (gridStyle == GridStyle.list) return GridListCourseTile(course: course);
                            return GridCourseTile(course: course, gridStyle: gridStyle);
                          },
                        ),
              Opacity(
                opacity: _hasData ? 1.0 : 0.0,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: LoadingIndicatorWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterContainer extends StatelessWidget {
  const FilterContainer({
    super.key,
    required this.gridStyle,
    required this.ref,
  });

  final GridStyle gridStyle;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return Container(
      height: 50,
      color: isDarkMode ? CustomColor.containerDark : CustomColor.container,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(
              FeatherIcons.grid,
              size: 22,
              color: gridStyle == GridStyle.grid ? Colors.blueAccent : Colors.blueGrey,
            ),
            onPressed: () => ref.read(gridStyleProvider.notifier).update((state) => GridStyle.grid),
          ),
          IconButton(
            icon: Icon(
              FeatherIcons.square,
              size: 22,
              color: gridStyle == GridStyle.box ? Colors.blueAccent : Colors.blueGrey,
            ),
            onPressed: () => ref.read(gridStyleProvider.notifier).update((state) => GridStyle.box),
          ),
          IconButton(
            icon: Icon(
              FeatherIcons.list,
              size: 22,
              color: gridStyle == GridStyle.list ? Colors.blueAccent : Colors.blueGrey,
            ),
            onPressed: () => ref.read(gridStyleProvider.notifier).update((state) => GridStyle.list),
          ),
        ],
      ),
    );
  }
}
