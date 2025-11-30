import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/mixins/search_mixin.dart';
import 'package:lms_app/screens/search/search_view.dart';

class RecentSearches extends ConsumerWidget with SearchMixin {
  const RecentSearches({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentSearches = ref.watch(recentSearchDataProvider).reversed;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'recent-searches',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ).tr(),
          const SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: recentSearches
                .map(
                  (e) => ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(e),
                    leading: const Icon(CupertinoIcons.time, color: Colors.blueGrey),
                    trailing: IconButton(
                      icon: const Icon(FeatherIcons.delete, size: 20),
                      onPressed: () => removeFromSearchList(value: e, ref: ref),
                    ),
                    onTap: () {
                      ref.read(searchTextCtlrProvider).text = e;
                      ref.read(searchStartedProvider.notifier).update((state) => true);
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
