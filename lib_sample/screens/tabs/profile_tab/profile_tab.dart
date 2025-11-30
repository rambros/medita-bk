import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/screens/tabs/profile_tab/settings.dart';
import '../../../providers/user_data_provider.dart';
import 'guest_user.dart';
import 'user_info.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('profile').tr(),
          pinned: true,
          titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                user == null ? const GuestUser() : UserInfo(user: user, ref: ref),
                const AppSettings(),
              ],
            ),
          ),
        )
      ],
    );
  }
}
