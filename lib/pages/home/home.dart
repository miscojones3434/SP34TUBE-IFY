import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/modules/connect/connect_device.dart';
import 'package:spotube/modules/home/sections/featured.dart';
import 'package:spotube/modules/home/sections/sections.dart';
import 'package:spotube/modules/home/sections/new_releases.dart';
import 'package:spotube/modules/home/sections/recent.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/platform.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  static const name = "home";

  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final controller = useScrollController();
    final selectedFilter = useState(0);
    final mediaQuery = MediaQuery.of(context);
    final layoutMode =
        ref.watch(userPreferencesProvider.select((s) => s.layoutMode));

    return SafeArea(
      bottom: false,
      child: Scaffold(
        headers: [
          if (kTitlebarVisible) const TitleBar(height: 30),
        ],
        child: ColoredBox(
          color: const Color(0xFF121212),
          child: DefaultTextStyle.merge(
            style: const TextStyle(
              color: Colors.white,
            ),
            child: CustomScrollView(
              controller: controller,
              slivers: [
                if (mediaQuery.smAndDown ||
                    layoutMode == LayoutMode.compact)
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    snap: true,
                    elevation: 0,
                    titleSpacing: 16,
                    backgroundColor: const Color(0xFF121212),
                    foregroundColor: Colors.white,
                    title: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _Sp34TubeIfyBrandMark(),
                        Gap(10),
                        Flexible(
                          child: Text(
                            'SP34TUBE-IFY',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      const ConnectDeviceButton(),
                      const Gap(6),
                      IconButton.ghost(
                        icon: const Icon(
                          SpotubeIcons.user,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          context.navigateTo(
                            const Pt34ProfileRoute(),
                          );
                        },
                      ),
                      const Gap(4),
                      IconButton.ghost(
                        icon: const Icon(
                          SpotubeIcons.settings,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          context.navigateTo(
                            const SettingsRoute(),
                          );
                        },
                      ),
                      const Gap(10),
                    ],
                  )
                else if (kIsMacOS)
                  const SliverGap(10),

                SliverToBoxAdapter(
                  child: _HomeFilterBar(
                    selectedIndex: selectedFilter.value,
                    onSelected: (index) {
                      selectedFilter.value = index;
                    },
                  ),
                ),

                const SliverGap(10),

                SliverList.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return switch (index) {
                      // 0 => const HomeGenresSection(),
                      0 => const HomeRecentlyPlayedSection(),
                      1 => const HomeFeaturedSection(),
                      // 3 => const HomePageFriendsSection(),
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
      ),
    );
  }
}

class _HomeFilterBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _HomeFilterBar({
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF121212),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Row(
        children: [
          _HomeFilterChip(
            label: 'Todos',
            selected: selectedIndex == 0,
            onPressed: () => onSelected(0),
          ),
          const Gap(8),
          _HomeFilterChip(
            label: 'Música',
            selected: selectedIndex == 1,
            onPressed: () => onSelected(1),
          ),
          const Gap(8),
          _HomeFilterChip(
            label: 'Pódcasts',
            selected: selectedIndex == 2,
            onPressed: () => onSelected(2),
          ),
        ],
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF1ED760)
              : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _Sp34TubeIfyBrandMark extends StatelessWidget {
  const _Sp34TubeIfyBrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFF1ED760),
        shape: BoxShape.circle,
      ),
      child: const Text(
        'P',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
