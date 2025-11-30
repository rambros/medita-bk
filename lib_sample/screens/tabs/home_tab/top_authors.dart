import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/components/author_card.dart';
import 'package:lms_app/components/loading_tile.dart';
import 'package:lms_app/models/user_model.dart';
import 'package:lms_app/screens/all_authors.dart';
import 'package:lms_app/services/firebase_service.dart';
import 'package:lms_app/utils/next_screen.dart';

final topAuthorsProvider = FutureProvider<List<UserModel>>((ref) async {
  final List<UserModel> authors = await FirebaseService().getTopAuthors(limit: 5);
  return authors;
});

class TopAuthors extends ConsumerWidget {
  const TopAuthors({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authors = ref.watch(topAuthorsProvider);
    return authors.when(
        data: (data) {
          return Visibility(
            visible: data.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RichText(
                              text: TextSpan(
                                  text: 'top'.tr(),
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                  children: [
                                const TextSpan(text: ' '),
                                TextSpan(
                                  text: 'instructors'.tr(),
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                                )
                              ])),
                        ),
                        TextButton(
                          onPressed: () => NextScreen.normal(context, const AllAuthors()),
                          style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                          child: Text(
                            'view-all',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ).tr(),
                        )
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: data.map((user) {
                        return AuthorCard(user: user);
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        error: (e, x) => Text('error: $e, $x'),
        loading: () => const LoadingTile(height: 300));
  }
}
