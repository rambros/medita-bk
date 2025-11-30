import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../models/course.dart';
import '../../models/review.dart';
import '../../models/review_user.dart';
import '../../models/user_model.dart';
import '../../providers/user_data_provider.dart';
import '../course_details.dart/course_reviews.dart';
import 'reviews_provider.dart';
import '../../services/firebase_service.dart';
import '../../utils/snackbars.dart';

final courseRatingProvider = StateProvider.family.autoDispose<double, Course>((ref, course) => course.rating);

class RatingForm extends ConsumerStatefulWidget {
  const RatingForm({super.key, required this.review, required this.course});

  final Course course;
  final Review? review;

  @override
  ConsumerState<RatingForm> createState() => _RatingFormState();
}

class _RatingFormState extends ConsumerState<RatingForm> {
  double _rating = 0.0;
  var reviewCtlr = TextEditingController();
  final _btnController = RoundedLoadingButtonController();
  late String _btnText;

  @override
  void initState() {
    super.initState();
    _btnText = widget.review == null ? 'submit' : 'update';
    _rating = widget.review?.rating ?? 0.0;
    reviewCtlr.text = widget.review?.review ?? '';
  }

  _handleSubmit() async {
    final user = ref.read(userDataProvider)!;
    final navigator = Navigator.of(context);
    if (_rating != 0.0) {
      _btnController.start();

      // Save Review
      await FirebaseService().saveReview(widget.course.id, _reviewData(user));

      // Uopdate Course Avarage Rating
      final double avarageRating = await FirebaseService().getCourseAverageRating(widget.course.id);
      await FirebaseService().saveCourseRating(widget.course.id, avarageRating);
      ref.read(courseRatingProvider(widget.course).notifier).update((state) => avarageRating);

      // Update user reviews list
      _updateUserReviewList(user);

      //refresh course reviews
      ref.invalidate(courseReviewProvider);

      // updating all reviews
      if (mounted) {
        ref.invalidate(allReviewsProvider);
        await ref.read(allReviewsProvider.notifier).getData(widget.course.id, ref);
      }

      await Future.delayed(const Duration(seconds: 1));
      navigator.pop();
    } else {
      openSnackbar(context, 'Choose your rating first');
    }
  }

  _updateUserReviewList (UserModel user) async {
    if(!user.reviews!.contains(widget.course.id)){
      await FirebaseService().updateUserReviewList(user, widget.course);
      await ref.read(userDataProvider.notifier).getData();
    }
  }

  Review _reviewData(UserModel user) {
    final String id = widget.review?.id ?? FirebaseService.getUID('reviews');
    final createdAt = widget.review?.createdAt ?? DateTime.now().toUtc();
    final reviewUser = ReviewUser(id: user.id, name: user.name, imageUrl: user.imageUrl);

    final Review review = Review(
      id: id,
      courseId: widget.course.id,
      rating: _rating,
      review: reviewCtlr.text.isEmpty ? null : reviewCtlr.text,
      createdAt: createdAt,
      reviewUser: reviewUser,
      courseTitle: widget.course.name,
      courseAuthorId: widget.course.author.id,
    );

    return review;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ),
      bottomSheet: BottomAppBar(
        child: RoundedLoadingButton(
          animateOnTap: false,
          elevation: 0,
          color: Theme.of(context).primaryColor,
          controller: _btnController,
          child: Text(
            _btnText,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontSize: 18),
          ).tr(),
          onPressed: () => _handleSubmit(),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                unratedColor: Colors.grey.shade300,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.orange,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              const SizedBox(height: 30),
              const Text('write-review').tr(),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.multiline,
                controller: reviewCtlr,
                minLines: 3,
                maxLines: null,
                decoration: InputDecoration(border: const OutlineInputBorder(), hintText: 'write-your-review'.tr()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
