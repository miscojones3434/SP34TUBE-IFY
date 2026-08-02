import 'package:flutter/material.dart' as material;

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/history/recent.dart';

class HomeRecentlyPlayedSection extends HookConsumerWidget {
  const HomeRecentlyPlayedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(recentlyPlayedItems);

    if (history.hasError) {
      return const SizedBox.shrink();
    }

    if (history.isLoading) {
      return const _SpotifyRecentSkeleton();
    }

    final historyData =
        history.asData?.value ?? const <HistoryTableData>[];

    final visibleItems = historyData
        .map(_SpotifyRecentItem.fromHistory)
        .whereType<_SpotifyRecentItem>()
        .take(8)
        .toList(growable: false);

    if (visibleItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: GridView.builder(
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: visibleItems.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 64,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          return _SpotifyRecentTile(
            item: visibleItems[index],
          );
        },
      ),
    );
  }
}

class _SpotifyRecentTile extends StatelessWidget {
  final _SpotifyRecentItem item;

  const _SpotifyRecentTile({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return material.Material(
      color: const Color(0xFF2A2A2A),
      borderRadius: BorderRadius.circular(4),
      clipBehavior: Clip.antiAlias,
      child: material.InkWell(
        onTap: () {
          switch (item.type) {
            case _SpotifyRecentItemType.playlist:
              final playlist = item.playlist!;

              context.navigateTo(
                PlaylistRoute(
                  id: playlist.id,
                  playlist: playlist,
                ),
              );
              break;

            case _SpotifyRecentItemType.album:
              final album = item.album!;

              context.navigateTo(
                AlbumRoute(
                  id: album.id,
                  album: album,
                ),
              );
              break;
          }
        },
        child: Row(
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: UniversalImage(
                path: item.imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpotifyRecentSkeleton extends StatelessWidget {
  const _SpotifyRecentSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: GridView.builder(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 8,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 64,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: ColoredBox(
                      color: Color(0xFF404040),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        'Contenido reciente',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

enum _SpotifyRecentItemType {
  playlist,
  album,
}

class _SpotifyRecentItem {
  final _SpotifyRecentItemType type;
  final SpotubeSimplePlaylistObject? playlist;
  final SpotubeSimpleAlbumObject? album;

  const _SpotifyRecentItem._({
    required this.type,
    this.playlist,
    this.album,
  });

  factory _SpotifyRecentItem.playlist(
    SpotubeSimplePlaylistObject playlist,
  ) {
    return _SpotifyRecentItem._(
      type: _SpotifyRecentItemType.playlist,
      playlist: playlist,
    );
  }

  factory _SpotifyRecentItem.album(
    SpotubeSimpleAlbumObject album,
  ) {
    return _SpotifyRecentItem._(
      type: _SpotifyRecentItemType.album,
      album: album,
    );
  }

  static _SpotifyRecentItem? fromHistory(
    HistoryTableData historyItem,
  ) {
    try {
      switch (historyItem.type) {
        case HistoryEntryType.playlist:
          return _SpotifyRecentItem.playlist(
            SpotubeSimplePlaylistObject.fromJson(
              historyItem.data,
            ),
          );

        case HistoryEntryType.album:
          return _SpotifyRecentItem.album(
            SpotubeSimpleAlbumObject.fromJson(
              historyItem.data,
            ),
          );

        case HistoryEntryType.track:
          return null;
      }
    } catch (_) {
      return null;
    }
  }

  String get title {
    return switch (type) {
      _SpotifyRecentItemType.playlist => playlist!.name,
      _SpotifyRecentItemType.album => album!.name,
    };
  }

  String get imageUrl {
    return switch (type) {
      _SpotifyRecentItemType.playlist =>
        playlist!.images.from200PxTo300PxOrSmallestImage(
          ImagePlaceholder.collection,
        ),
      _SpotifyRecentItemType.album =>
        album!.images.from200PxTo300PxOrSmallestImage(
          ImagePlaceholder.collection,
        ),
    };
  }
}
