import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:spotube/collections/intents.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/player/player_track_details.dart';
import 'package:spotube/modules/root/spotube_navigation_bar.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/audio_player/querying_track_info.dart';
import 'package:spotube/services/audio_player/audio_player.dart';

class PlayerOverlayCollapsedSection extends HookConsumerWidget {
  final PanelController panelController;

  const PlayerOverlayCollapsedSection({
    super.key,
    required this.panelController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlist = ref.watch(audioPlayerProvider);
    final canShow = playlist.activeTrack != null;
    final isFetchingActiveTrack = ref.watch(queryingTrackInfoProvider);

    final playing =
        useStream(audioPlayer.playingStream).data ?? audioPlayer.isPlaying;

    final shouldShow = useState(true);

    ref.listen(navigationPanelHeight, (_, height) {
      shouldShow.value = height.ceil() == 72;
    });

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: canShow && shouldShow.value
          ? Padding(
              padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF282828),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF3A3A3A),
                    width: 0.5,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          panelController.open();
                        },
                        child: Container(
                          width: double.infinity,
                          color: Colors.transparent,
                          padding: const EdgeInsets.only(left: 4),
                          child: PlayerTrackDetails(
                            track: playlist.activeTrack,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton.ghost(
                          icon: const Icon(
                            SpotubeIcons.skipBack,
                            color: Colors.white,
                            size: 21,
                          ),
                          onPressed: isFetchingActiveTrack
                              ? null
                              : audioPlayer.skipToPrevious,
                        ),
                        Consumer(
                          builder: (context, ref, _) {
                            return IconButton.ghost(
                              icon: isFetchingActiveTrack
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF1ED760),
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(
                                      playing
                                          ? SpotubeIcons.pause
                                          : SpotubeIcons.play,
                                      color: Colors.white,
                                      size: 23,
                                    ),
                              onPressed: Actions.handler<PlayPauseIntent>(
                                context,
                                PlayPauseIntent(ref),
                              ),
                            );
                          },
                        ),
                        IconButton.ghost(
                          icon: const Icon(
                            SpotubeIcons.skipForward,
                            color: Colors.white,
                            size: 21,
                          ),
                          onPressed: isFetchingActiveTrack
                              ? null
                              : audioPlayer.skipToNext,
                        ),
                        const Gap(4),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
