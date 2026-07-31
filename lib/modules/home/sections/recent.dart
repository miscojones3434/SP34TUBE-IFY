import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/models/metadata/metadata.dart';
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

    final recentItems = [
      for (final item in historyData)
        if (item.playlist != null)
          item.playlist!
        else if (item.album != null)
          item.album!,
    ].take(8).toList();

    if (recentItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Skeletonizer(
      enabled: history.isLoading,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          12,
          4,
          12,
          14,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columnCount = constraints.maxWidth >= 700 ? 4 : 2;
            const spacing = 8.0;

            final itemWidth =
                (constraints.maxWidth - spacing * (columnCount - 1)) /
                    columnCount;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final item in recentItems)
                  SizedBox(
                    width: itemWidth,
                    child: switch (item) {
                      SpotubeSimplePlaylistObject() =>
                        PlaylistCard.tile(item),
                      SpotubeSimpleAlbumObject() => AlbumCard.tile(item),
                      _ => const SizedBox.shrink(),
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
