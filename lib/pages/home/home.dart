import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/modules/home/sections/featured.dart';
import 'package:spotube/modules/home/sections/new_releases.dart';
import 'package:spotube/modules/home/sections/recent.dart';
import 'package:spotube/modules/home/sections/sections.dart';
import 'package:spotube/provider/metadata_plugin/core/user.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/platform.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  static const name = "home";

  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useScrollController();
    final selectedFilter = useState(_HomeFilter.all);

    final mediaQuery = MediaQuery.of(context);
    final user = ref.watch(metadataPluginUserProvider);
    final userData = user.asData?.value ?? FakeData.user;

    final layoutMode = ref.watch(
      userPreferencesProvider.select(
        (state) => state.layoutMode,
      ),
    );

    final compactHeader =
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
              if (compactHeader)
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  elevation: 0,
                  toolbarHeight: 64,
                  titleSpacing: 12,
                  backgroundColor: const Color(0xFF000000),
                  foregroundColor: Colors.white,
                  surfaceTintColor: const Color(0xFF000000),
                  title: Row(
                    children: [
                      _HomeProfileAvatar(
                        imageUrl: userData.images.asUrlString(
                          index: 1,
                          placeholder: ImagePlaceholder.artist,
                        ),
                        fallbackText: userData.name,
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
                                text: 'Todos',
                                selected:
                                    selectedFilter.value == _HomeFilter.all,
                                onPressed: () {
                                  selectedFilter.value = _HomeFilter.all;
                                },
                              ),
                              const Gap(8),
                              _HomeFilterChip(
                                text: 'Música',
                                selected:
                                    selectedFilter.value == _HomeFilter.music,
                                onPressed: () {
                                  selectedFilter.value = _HomeFilter.music;
                                },
                              ),
                              const Gap(8),
                              _HomeFilterChip(
                                text: 'Pódcasts',
                                selected:
                                    selectedFilter.value ==
                                        _HomeFilter.podcasts,
                                onPressed: () {
                                  selectedFilter.value =
                                      _HomeFilter.podcasts;
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

              const SliverGap(8),

              if (selectedFilter.value == _HomeFilter.all) ...[
                const SliverToBoxAdapter(
                  child: HomeRecentlyPlayedSection(),
                ),
                const SliverToBoxAdapter(
                  child: HomeFeaturedSection(),
                ),
                const SliverToBoxAdapter(
                  child: HomeNewReleasesSection(),
                ),
                const SliverSafeArea(
                  sliver: HomePageBrowseSection(),
                ),
              ],

              if (selectedFilter.value == _HomeFilter.music) ...[
                const SliverToBoxAdapter(
                  child: HomeRecentlyPlayedSection(),
                ),
                const SliverToBoxAdapter(
                  child: HomeFeaturedSection(),
                ),
                const SliverToBoxAdapter(
                  child: HomeNewReleasesSection(),
                ),
                const SliverSafeArea(
                  sliver: HomePageBrowseSection(),
                ),
              ],

              if (selectedFilter.value == _HomeFilter.podcasts)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _PodcastsEmptyState(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _HomeFilter {
  all,
  music,
  podcasts,
}

class _HomeProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final String fallbackText;
  final VoidCallback onPressed;

  const _HomeProfileAvatar({
    required this.imageUrl,
    required this.fallbackText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final initial = fallbackText.trim().isEmpty
        ? 'P'
        : fallbackText.trim().substring(0, 1).toUpperCase();

    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: ClipOval(
        child: SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                alignment: Alignment.center,
                color: const Color(0xFF535353),
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              UniversalImage(
                path: imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeFilterChip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onPressed;

  const _HomeFilterChip({
    required this.text,
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
          milliseconds: 160,
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
          text,
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

class _PodcastsEmptyState extends StatelessWidget {
  const _PodcastsEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 48,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pódcasts',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            Gap(8),
            Text(
              'No hay pódcasts disponibles en el proveedor conectado.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFB3B3B3),
                fontSize: 14,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
