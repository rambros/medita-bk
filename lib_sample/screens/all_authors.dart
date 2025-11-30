import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/components/loading_list_tile.dart';
import 'package:lms_app/models/user_model.dart';
import 'package:lms_app/screens/author_profie/author_profile.dart';
import 'package:lms_app/services/firebase_service.dart';
import 'package:lms_app/utils/next_screen.dart';

import '../components/user_avatar.dart';

final authorsProvider = FutureProvider.autoDispose((ref) async {
  final List<UserModel> authors = await FirebaseService().getAllAuthors();
  return authors;
});

class AllAuthors extends ConsumerWidget {
  const AllAuthors({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authoraRef = ref.watch(authorsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Instructors'),
      ),
      body: authoraRef.when(
        data: (authors) {
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: authors.length,
            separatorBuilder: (BuildContext context, int index) => const Divider(height: 50),
            itemBuilder: (BuildContext context, int index) {
              final UserModel author = authors[index];
              return InkWell(
                onTap: () => NextScreen.iOS(context, AuthorProfile(user: author)),
                child: Row(
                  children: [
                    UserAvatar(imageUrl: author.imageUrl, radius: 60, iconSize: 40),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(author.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            Visibility(
                              visible: author.authorInfo?.jobTitle != null,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Text(
                                  author.authorInfo?.jobTitle ?? '',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey),
                                ),
                              ),
                            ),
                            Text('${author.authorInfo?.students ?? 0} Students')
                          ],
                        ),
                      ),
                    ),
                    const Icon(FeatherIcons.chevronRight),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const LoadingListTile(height: 130),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
      ),
    );
  }
}
