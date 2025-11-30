import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lms_app/components/loading_list_tile.dart';
import 'package:lms_app/configs/app_assets.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/models/review.dart';
import 'package:lms_app/screens/course_details.dart/review_button.dart';
import 'package:lms_app/utils/empty_animation.dart';
import 'rating_form.dart';
import 'review_tile.dart';
import 'reviews_provider.dart';



class AllReviews extends ConsumerStatefulWidget {
  const AllReviews(this.course, {super.key});

  final Course course;

  @override
  ConsumerState<AllReviews> createState() => _AllReviewsState();
}

class _AllReviewsState extends ConsumerState<AllReviews> {
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController(initialScrollOffset: 0.0);
    _controller.addListener(_scrollListener);
    super.initState();
    Future.microtask(() => ref.read(allReviewsProvider.notifier).getData(widget.course.id, ref));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _scrollListener() async {
    var isEnd = _controller.offset >= _controller.position.maxScrollExtent && !_controller.position.outOfRange;
    if (isEnd) {
      ref.read(allReviewsProvider.notifier).getData(widget.course.id, ref);
    }
  }

  _onRefresh() async {
    ref.read(hasReviewsProvider.notifier).update((state) => false);
    ref.read(isReviewsLoadingProvider.notifier).update((state) => true);
    ref.invalidate(allReviewsProvider);
    await ref.read(allReviewsProvider.notifier).getData(widget.course.id, ref);
  }

  @override
  Widget build(BuildContext context) {
    final reviews = ref.watch(allReviewsProvider);
    final hasData = ref.watch(hasReviewsProvider);
    final isLoading = ref.watch(isReviewsLoadingProvider);
    final rating = ref.watch(courseRatingProvider(widget.course));

    return Scaffold(
      appBar: AppBar(
        title: const Text('student-feedbacks').tr(),
        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        centerTitle: true,
        elevation: 0,
        actions: [
          ReviewButton(course: widget.course),
        ],
      ),
      body: isLoading
          ? const LoadingListTile()
          : reviews.isEmpty
              ? EmptyAnimation(animationString: emptyAnimation, title: 'no-review'.tr())
              : RefreshIndicator(
                  onRefresh: () async => await _onRefresh(),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50, top: 20),
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _controller,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              rating.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.orange),
                            ),
                            const SizedBox(width: 10),
                            RatingBarIndicator(
                              itemSize: 25,
                              rating: rating,
                              itemPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 1.0),
                              itemCount: 5,
                              unratedColor: Colors.grey.shade400,
                              itemBuilder: (context, index) => const Icon(
                                LineIcons.starAlt,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: reviews.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 20),
                          itemBuilder: (BuildContext context, int index) {
                            final Review review = reviews[index];
                            return ReviewTile(review: review);
                          },
                        ),
                        Opacity(
                          opacity: hasData ? 1.0 : 0.0,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
