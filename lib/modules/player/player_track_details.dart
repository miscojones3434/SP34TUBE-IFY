import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/links/artist_link.dart';
import 'package:spotube/components/links/link_text.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';

class PlayerTrackDetails extends HookConsumerWidget {
  final Color? color;
  final SpotubeTrackObject? track;

  const PlayerTrackDetails({
    super.key,
    this.color,
    this.track,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final playback = ref.watch(audioPlayerProvider);
    final activeTrack = playback.activeTrack;
    final displayedTrack = track ?? activeTrack;

    final titleColor = color ?? Colors.white;
    const artistColor = Color(0xFFB3B3B3);

    return Row(
      children: [
        if (activeTrack != null)
          Padding(
            padding: const EdgeInsets.all(4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: 52,
                height: 52,
                child: UniversalImage(
                  path: (displayedTrack?.album.images).asUrlString(
                    placeholder: ImagePlaceholder.albumArt,
                  ),
                  placeholder: Assets.images.albumPlaceholder.path,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        const SizedBox(width: 8),
        if (mediaQuery.mdAndDown)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activeTrack?.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activeTrack?.artists.asString() ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: artistColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        if (mediaQuery.lgAndUp)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinkText(
                  activeTrack?.name ?? '',
                  TrackRoute(
                    trackId: activeTrack?.id ?? '',
                  ),
                  push: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                ArtistLink(
                  artists: activeTrack?.artists ?? [],
                  textStyle: const TextStyle(
                    color: artistColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  onRouteChange: (route) {
                    context.router.navigateNamed(route);
                  },
                  onOverflowArtistClick: activeTrack == null
                      ? null
                      : () {
                          context.navigateTo(
                            TrackRoute(
                              trackId: activeTrack.id,
                            ),
                          );
                        },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
