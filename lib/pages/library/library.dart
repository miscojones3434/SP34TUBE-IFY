import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' show Badge;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/side_bar_tiles.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/download_manager_provider.dart';

@RoutePage()
class LibraryPage extends HookConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadingCount = ref
        .watch(downloadManagerProvider)
        .where(
          (download) =>
              download.status == DownloadStatus.downloading ||
              download.status == DownloadStatus.queued,
        )
        .length;

    final router = context.watchRouter;

    final sidebarLibraryTileList = useMemoized(
      () => [
        ...getSidebarLibraryTileList(context.l10n),
        SideBarTiles(
          id: 'downloads',
          pathPrefix: 'library/downloads',
          title: context.l10n.downloads,
          route: const UserDownloadsRoute(),
          icon: SpotubeIcons.download,
        ),
      ],
      [context.l10n],
    );

    final currentIndex = sidebarLibraryTileList.indexWhere(
      (tile) => router.currentPath.startsWith(tile.pathPrefix),
    );

    final selectedIndex = currentIndex < 0 ? 0 : currentIndex;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        context.navigateTo(const HomeRoute());
      },
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Scaffold(
              backgroundColor: const Color(0xFF121212),
              headers: [
                if (constraints.smAndDown)
                  TitleBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: const Color(0xFF121212),
                    surfaceBlur: 0,
                    surfaceOpacity: 1,
                    height: 66,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: TabList(
                        index: selectedIndex,
                        onChanged: (index) {
                          context.navigateTo(
                            sidebarLibraryTileList[index].route,
                          );
                        },
                        children: [
                          for (var index = 0;
                              index < sidebarLibraryTileList.length;
                              index++)
                            TabItem(
                              child: _LibraryTabLabel(
                                tile: sidebarLibraryTileList[index],
                                selected: selectedIndex == index,
                                downloadingCount: downloadingCount,
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                else
                  const TitleBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Color(0xFF121212),
                    surfaceBlur: 0,
                    surfaceOpacity: 1,
                    height: 32,
                  ),
              ],
              child: const ColoredBox(
                color: Color(0xFF121212),
                child: AutoRouter(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LibraryTabLabel extends StatelessWidget {
  final SideBarTiles tile;
  final bool selected;
  final int downloadingCount;

  const _LibraryTabLabel({
    required this.tile,
    required this.selected,
    required this.downloadingCount,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF1ED760)
            : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Badge(
        isLabelVisible:
            tile.id == 'downloads' && downloadingCount > 0,
        label: Text(
          downloadingCount.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Text(
          tile.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontSize: 13,
            fontWeight:
                selected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
