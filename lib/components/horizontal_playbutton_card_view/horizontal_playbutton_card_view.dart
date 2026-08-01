import 'dart:ui';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/modules/album/album_card.dart';
import 'package:spotube/modules/artist/artist_card.dart';
import 'package:spotube/modules/playlist/playlist_card.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class HorizontalPlaybuttonCardView<T> extends HookWidget {
  final Widget title;
  final List<T> items;
  final Widget? error;
  final VoidCallback onFetchMore;
  final bool isLoadingNextPage;
  final bool hasNextPage;
  final Widget? titleTrailing;

  HorizontalPlaybuttonCardView({
    required this.title,
    required this.items,
    required this.hasNextPage,
    required this.onFetchMore,
    required this.isLoadingNextPage,
    this.titleTrailing,
    this.error,
    super.key,
  }) : assert(
          items.every(
            (item) =>
                item is SpotubeSimpleAlbumObject ||
                item is SpotubeSimplePlaylistObject ||
                item is SpotubeFullArtistObject,
          ),
        );

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    final isArtist = items.isNotEmpty &&
        items.every(
          (item) => item is SpotubeFullArtistObject,
        );

    final scale = context.theme.scaling;

    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: EdgeInsets.only(
        top: 12 * scale,
        bottom: 12 * scale,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16 * scale,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22 * scale,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      letterSpacing: -0.35,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: title,
                  ),
                ),
                if (titleTrailing != null) ...[
                  Gap(12 * scale),
                  DefaultTextStyle(
                    style: TextStyle(
                      color: const Color(0xFFB3B3B3),
                      fontSize: 13 * scale,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: titleTrailing!,
                  ),
                ],
              ],
            ),
          ),
          Gap(10 * scale),
          if (error != null)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16 * scale,
              ),
              child: error!,
            )
          else
            SizedBox(
              height: isArtist
                  ? 222 * scale
                  : 218 * scale,
              child: NotificationListener<ScrollNotification>(
                onNotification: (_) => true,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: PointerDeviceKind.values.toSet(),
                    scrollbars: false,
                  ),
                  child: items.isEmpty
                      ? ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16 * scale,
                          ),
                          itemCount: 5,
                          separatorBuilder: (_, __) =>
                              Gap(14 * scale),
                          itemBuilder: (context, index) {
                            return Skeletonizer(
                              enabled: true,
                              child: AlbumCard(
                                FakeData.albumSimple,
                              ),
                            );
                          },
                        )
                      : InfiniteList(
                          scrollController: scrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16 * scale,
                          ),
                          itemCount: items.length,
                          onFetchData: onFetchMore,
                          loadingBuilder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: 14 * scale,
                              ),
                              child: Skeletonizer(
                                enabled: true,
                                child: isArtist
                                    ? ArtistCard(
                                        FakeData.artist,
                                      )
                                    : AlbumCard(
                                        FakeData.albumSimple,
                                      ),
                              ),
                            );
                          },
                          isLoading: isLoadingNextPage,
                          hasReachedMax: !hasNextPage,
                          separatorBuilder: (context, index) =>
                              Gap(14 * scale),
                          itemBuilder: (context, index) {
                            final item = items[index];

                            return switch (item) {
                              SpotubeSimplePlaylistObject() =>
                                PlaylistCard(
                                  item,
                                ),
                              SpotubeSimpleAlbumObject() =>
                                AlbumCard(
                                  item,
                                ),
                              SpotubeFullArtistObject() =>
                                ArtistCard(
                                  item,
                                ),
                              _ => const SizedBox.shrink(),
                            };
                          },
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
