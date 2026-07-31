import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_undraw/flutter_undraw.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/components/fallbacks/error_box.dart';
import 'package:spotube/components/track_presentation/presentation_props.dart';
import 'package:spotube/components/track_presentation/presentation_state.dart';
import 'package:spotube/components/track_presentation/use_track_tile_play_callback.dart';
import 'package:spotube/components/track_presentation/use_is_user_playlist.dart';
import 'package:spotube/components/track_tile/track_tile.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class PresentationListSection extends HookConsumerWidget {
  const PresentationListSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = TrackPresentationOptions.of(context);
    final playlist = ref.watch(audioPlayerProvider);

    final state = ref.watch(
      presentationStateProvider(options.collection),
    );

    final notifier = ref.read(
      presentationStateProvider(options.collection).notifier,
    );

    final isUserPlaylist = useIsUserPlaylist(
      ref,
      options.collectionId,
    );

    final onTileTap = useTrackTilePlayCallback(ref);

    if (state.presentationTracks.isEmpty &&
        !options.pagination.isLoading) {
      if (options.error != null) {
        return SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF181818),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF2A2A2A),
              ),
            ),
            child: ErrorBox(
              error: options.error!,
              onRetry: options.pagination.onRefresh,
            ),
          ),
        );
      }

      return SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 28,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF181818),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF2A2A2A),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Undraw(
                illustration: UndrawIllustration.dreamer,
                color: const Color(0xFF1ED760),
                height: 180 * context.theme.scaling,
              ),
              const Gap(18),
              Text(
                isUserPlaylist
                    ? context.l10n.no_tracks_added_yet
                    : context.l10n.no_tracks,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverInfiniteList(
      isLoading: options.pagination.isLoading,
      onFetchData: options.pagination.onFetchMore,
      itemCount: state.presentationTracks.length,
      hasReachedMax: !options.pagination.hasNextPage,
      loadingBuilder: (context) {
        return Skeletonizer(
          enabled: true,
          child: _TrackRowContainer(
            selected: false,
            child: TrackTile(
              index: 0,
              playlist: playlist,
              track: FakeData.track,
            ),
          ),
        );
      },
      emptyBuilder: (context) {
        return Skeletonizer(
          enabled: true,
          child: Column(
            children: List.generate(
              10,
              (index) {
                return _TrackRowContainer(
                  selected: false,
                  child: TrackTile(
                    track: FakeData.track,
                    index: index,
                    playlist: playlist,
                  ),
                );
              },
            ),
          ),
        );
      },
      itemBuilder: (context, index) {
        return HookBuilder(
          builder: (context) {
            final track = state.presentationTracks[index];

            final isSelected = useMemoized(
              () => state.selectedTracks.any(
                (selectedTrack) =>
                    selectedTrack.id == track.id,
              ),
              [
                track.id,
                state.selectedTracks,
              ],
            );

            return _TrackRowContainer(
              selected: isSelected,
              child: TrackTile(
                userPlaylist: isUserPlaylist,
                playlistId: options.collectionId,
                index: index,
                playlist: playlist,
                track: track,
                selected: isSelected,
                onTap: () async {
                  await onTileTap(track, index);
                },
                onChanged: state.selectedTracks.isEmpty
                    ? null
                    : (selected) {
                        if (selected == true) {
                          notifier.selectTrack(track);
                        } else {
                          notifier.deselectTrack(track);
                        }
                      },
                onLongPress: () {
                  notifier.selectTrack(track);
                  HapticFeedback.selectionClick();
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _TrackRowContainer extends StatelessWidget {
  final Widget child;
  final bool selected;

  const _TrackRowContainer({
    required this.child,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 160,
      ),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF1E3A28)
            : const Color(0xFF121212),
        borderRadius: BorderRadius.circular(8),
        border: selected
            ? Border.all(
                color: const Color(0xFF1ED760),
                width: 1,
              )
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: child,
      ),
    );
  }
}
