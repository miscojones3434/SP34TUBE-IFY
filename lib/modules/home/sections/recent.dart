import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/modules/album/album_card.dart';
import 'package:spotube/modules/playlist/playlist_card.dart';
import 'package:spotube/provider/history/recent.dart';

class HomeRecentlyPlayedSection extends HookConsumerWidget {
  const HomeRecentlyPlayedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(recentlyPlayedItems);

    final historyData =
        history.asData?.value ?? FakeData.historyRecentlyPlayedItems;

    if (history.asData?.value.isEmpty == true) {
      return const SizedBox.shrink();
    }

    final visibleItems = historyData
        .where(
          (item) => item.playlist != null || item.album != null,
        )
        .take(8)
        .toList();

    if (visibleItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Skeletonizer(
      enabled: history.isLoading,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          12,
          4,
          12,
          18,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 8.0;

            final columns = constraints.maxWidth >= 900
                ? 4
                : constraints.maxWidth >= 600
                    ? 3
                    : 2;

            final itemWidth =
                (constraints.maxWidth - spacing * (columns - 1)) /
                    columns;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final item in visibleItems)
                  SizedBox(
                    width: itemWidth,
                    child: item.playlist != null
                        ? PlaylistCard.tile(
                            item.playlist!,
                          )
                        : AlbumCard.tile(
                            item.album!,
                          ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
