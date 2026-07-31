import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/modules/home/sections/featured.dart';
import 'package:spotube/modules/home/sections/new_releases.dart';
import 'package:spotube/modules/home/sections/recent.dart';
import 'package:spotube/modules/home/sections/sections.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/platform.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  static const name = "home";

  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useScrollController();
    final selectedFilter = useState(0);
    final mediaQuery = MediaQuery.of(context);

    final layoutMode = ref.watch(
      userPreferencesProvider.select(
        (state) => state.layoutMode,
      ),
    );

    final showMobileHeader =
        mediaQuery.smAndDown || layoutMode == LayoutMode.compact;

    return SafeArea(
      bottom: false,
      child: Scaffold(
        headers: [
          if (kTitlebarVisible)
            const TitleBar(
              height: 30,
            ),
        ],
        child: ColoredBox(
          color: const Color(0xFF000000),
          child: CustomScrollView(
            controller: controller,
            slivers: [
              if (showMobileHeader)
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  toolbarHeight: 64,
                  titleSpacing: 12,
                  backgroundColor: const Color(0xFF000000),
                  foregroundColor: Colors.white,
                  surfaceTintColor: const Color(0xFF000000),
                  title: Row(
                    children: [
                      _HomeProfileButton(
                        onPressed: () {
                          context.navigateTo(
                            const Pt34ProfileRoute(),
                          );
                        },
                      ),
                      const Gap(8),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              _HomeFilterChip(
                                label: 'Todos',
                                selected: selectedFilter.value == 0,
                                onPressed: () {
                                  selectedFilter.value = 0;
                                },
                              ),
                              const Gap(8),
                              _HomeFilterChip(
                                label: 'Música',
                                selected: selectedFilter.value == 1,
                                onPressed: () {
                                  selectedFilter.value = 1;
                                },
                              ),
                              const Gap(8),
                              _HomeFilterChip(
                                label: 'Pódcasts',
                                selected: selectedFilter.value == 2,
                                onPressed: () {
                                  selectedFilter.value = 2;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else if (kIsMacOS)
                const SliverGap(10),

              const SliverGap(4),

              SliverList.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return switch (index) {
                    0 => const HomeRecentlyPlayedSection(),
                    1 => const HomeFeaturedSection(),
                    _ => const HomeNewReleasesSection(),
                  };
                },
              ),

              const SliverSafeArea(
                sliver: HomePageBrowseSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeProfileButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _HomeProfileButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFF535353),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          SpotubeIcons.user,
          color: Colors.white,
          size: 21,
        ),
      ),
    );
  }
}

class _HomeFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  const _HomeFilterChip({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 150,
        ),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF1ED760)
              : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          label,
          maxLines: 1,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
