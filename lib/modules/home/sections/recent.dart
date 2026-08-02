import 'package:flutter/material.dart' as material;

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/history/recent.dart';
import 'package:spotube/provider/metadata_plugin/core/user.dart';

class HomeRecentlyPlayedSection extends HookConsumerWidget {
  const HomeRecentlyPlayedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(recentlyPlayedItems);
    final currentUser = ref.watch(metadataPluginUserProvider);

    if (history.hasError) {
      return const SizedBox.shrink();
    }

    if (history.isLoading) {
      return const _SpotifyRecentSkeleton();
    }

    final historyData = history.asData?.value ?? const [];
    final user = currentUser.asData?.value;

    final likedSongsPlaylist = user == null
        ? null
        : SpotubeSimplePlaylistObject(
            id: 'user-liked-tracks',
            name: context.l10n.liked_tracks,
            description: context.l10n.liked_tracks_description,
            externalUri: '',
            owner: user,
            images: [
              SpotubeImageObject(
                url: Assets.images.likedTracks.path,
                width: 300,
                height: 300,
              ),
            ],
          );

    final visibleItems = <_SpotifyRecentItem>[
      if (likedSongsPlaylist != null)
        _SpotifyRecentItem.likedSongs(likedSongsPlaylist),
      for (final historyItem in historyData)
        if (historyItem.playlist != null &&
            historyItem.playlist!.id != 'user-liked-tracks')
          _SpotifyRecentItem.playlist(historyItem.playlist!)
        else if (historyItem.album != null)
          _SpotifyRecentItem.album(historyItem.album!),
    ].take(8).toList(growable: false);

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
          mainAxisExtent: 56,
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
            case _SpotifyRecentItemType.likedSongs:
              context.navigateTo(
                LikedPlaylistRoute(
                  playlist: item.playlist!,
                ),
              );
              break;

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
              width: 56,
              height: 56,
              child: item.type == _SpotifyRecentItemType.likedSongs
                  ? const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF450AF5),
                            Color(0xFF8E8EE5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    )
                  : UniversalImage(
                      path: item.imageUrl,
                      fit: BoxFit.cover,
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
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
            mainAxisExtent: 56,
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
                    width: 56,
                    height: 56,
                    child: ColoredBox(
                      color: Color(0xFF404040),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9,
                      ),
                      child: Text(
                        'Contenido reciente',
                        maxLines: 2,
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
  likedSongs,
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

  factory _SpotifyRecentItem.likedSongs(
    SpotubeSimplePlaylistObject playlist,
  ) {
    return _SpotifyRecentItem._(
      type: _SpotifyRecentItemType.likedSongs,
      playlist: playlist,
    );
  }

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

  String get title {
    return switch (type) {
      _SpotifyRecentItemType.likedSongs => playlist!.name,
      _SpotifyRecentItemType.playlist => playlist!.name,
      _SpotifyRecentItemType.album => album!.name,
    };
  }

  String get imageUrl {
    return switch (type) {
      _SpotifyRecentItemType.likedSongs =>
        Assets.images.likedTracks.path,
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
