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
    final selectedFilter = useState<int>(0);

    final mediaQuery = MediaQuery.of(context);

    final layoutMode = ref.watch(
      userPreferencesProvider.select(
        (preferences) => preferences.layoutMode,
      ),
    );

    final compactLayout =
        mediaQuery.smAndDown || layoutMode == LayoutMode.compact;

    return SafeArea(
      bottom: false,
      child: Scaffold(
        headers: [
          if (kTitlebarVisible) const TitleBar(height: 30),
        ],
        child: ColoredBox(
          color: Colors.black,
          child: CustomScrollView(
            controller: controller,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              if (compactLayout)
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 84,
                  titleSpacing: 16,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  title: Row(
                    children: [
                      _SpotifyCircleButton(
                        onTap: () {
                          context.navigateTo(
                            const SettingsRoute(),
                          );
                        },
                        child: const Icon(
                          SpotubeIcons.user,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              _SpotifyFilterButton(
                                label: "Todos",
                                selected: selectedFilter.value == 0,
                                onTap: () {
                                  selectedFilter.value = 0;
                                },
                              ),
                              const Gap(8),
                              _SpotifyFilterButton(
                                label: "Música",
                                selected: selectedFilter.value == 1,
                                onTap: () {
                                  selectedFilter.value = 1;
                                },
                              ),
                              const Gap(8),
                              _SpotifyFilterButton(
                                label: "Pódcasts",
                                selected: selectedFilter.value == 2,
                                onTap: () {
                                  selectedFilter.value = 2;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                      _SpotifyCircleButton(
                        onTap: () {
                          context.navigateTo(
                            const SettingsRoute(),
                          );
                        },
                        child: const Icon(
                          SpotubeIcons.settings,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                )
              else if (kIsMacOS)
                const SliverGap(10),

              const SliverGap(8),

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
                top: false,
                minimum: EdgeInsets.only(bottom: 130),
                sliver: HomePageBrowseSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpotifyFilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SpotifyFilterButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: 48,
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF1ED760)
              : const Color(0xFF292929),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          maxLines: 1,
          style: TextStyle(
            color: selected
                ? Colors.black
                : Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _SpotifyCircleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _SpotifyCircleButton({
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFF555555),
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}
