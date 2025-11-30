import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/mixins/search_mixin.dart';
import 'package:lms_app/screens/search/search_view.dart';
import 'package:lms_app/utils/snackbars.dart';

class SearchAppBar extends ConsumerWidget with SearchMixin{
  const SearchAppBar({super.key, required this.searchTextCtlr});

  final TextEditingController searchTextCtlr;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: TextFormField(
        autofocus: true,
        controller: searchTextCtlr,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "search-course".tr(),
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          suffixIcon: IconButton(
              padding: const EdgeInsets.only(right: 10),
              icon: Icon(
                Icons.close,
                size: 22,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                searchTextCtlr.clear();
                ref.read(searchStartedProvider.notifier).update((state) => false);
              }),
        ),
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (value) async{
          if (value == '' || value.isEmpty) {
            openSnackbar(context, 'Type something!');
          } else {
            await addToSearchList(value: value, ref: ref);
            ref.read(searchStartedProvider.notifier).update((state) => true);
          }
        },
      ),
    );
  }
}
