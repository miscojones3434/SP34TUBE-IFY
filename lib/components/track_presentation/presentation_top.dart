import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/heart_button/heart_button.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/track_presentation/presentation_props.dart';
import 'package:spotube/components/track_presentation/use_action_callbacks.dart';
import 'package:spotube/components/track_presentation/use_is_user_playlist.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/modules/playlist/playlist_create_dialog.dart';

class TrackPresentationTopSection extends HookConsumerWidget {
  const TrackPresentationTopSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.sizeOf(context);
    final options = TrackPresentationOptions.of(context);
    final scale = context.theme.scaling;
    final isUserPlaylist = useIsUserPlaylist(
      ref,
      options.collectionId,
    );

    final decorationImage = DecorationImage(
      image: UniversalImage.imageProvider(options.image),
      fit: BoxFit.cover,
    );

    final imageDimension = mediaQuery.mdAndUp ? 210.0 : 190.0;

    final (
      :isLoading,
      :isActive,
      :onPlay,
      :onShuffle,
      :onAddToQueue,
    ) = useActionCallbacks(ref);

    final playbackActions = Wrap(
      spacing: 10 * scale,
      runSpacing: 10 * scale,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Tooltip(
          tooltip: TooltipContainer(
            child: Text(context.l10n.shuffle_playlist),
          ).call,
          child: IconButton.secondary(
            icon: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      onSurface: false,
                      size: 20,
                    ),
                  )
                : const Icon(
                    SpotubeIcons.shuffle,
                    color: Color(0xFF1ED760),
                  ),
            enabled: !isLoading && !isActive,
            onPressed: onShuffle,
          ),
        ),
        if (mediaQuery.width <= 320)
          Tooltip(
            tooltip: TooltipContainer(
              child: Text(context.l10n.add_to_queue),
            ).call,
            child: IconButton.secondary(
              icon: const Icon(
                SpotubeIcons.queueAdd,
                color: Colors.white,
              ),
              enabled: !isLoading && !isActive,
              onPressed: onAddToQueue,
            ),
          )
        else
          Button.secondary(
            leading: const Icon(
              SpotubeIcons.add,
              color: Colors.white,
            ),
            enabled: !isLoading && !isActive,
            onPressed: onAddToQueue,
            child: Text(
              context.l10n.queue,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Button.primary(
          alignment: Alignment.center,
          leading: switch ((isActive, isLoading)) {
            (true, false) => const Icon(
                SpotubeIcons.pause,
                color: Colors.black,
              ),
            (false, true) => const Center(
                child: CircularProgressIndicator(
                  onSurface: true,
                  size: 18,
                ),
              ),
            _ => const Icon(
                SpotubeIcons.play,
                color: Colors.black,
              ),
          },
          onPressed: onPlay,
          enabled: !isLoading && !isActive,
          child: Text(
            isActive ? context.l10n.pause : context.l10n.play,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );

    final additionalActions = Wrap(
      spacing: 8 * scale,
      runSpacing: 8 * scale,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (isUserPlaylist)
          IconButton.outline(
            size: ButtonSize.small,
            icon: const Icon(
              SpotubeIcons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return PlaylistCreateDialog(
                    playlistId: options.collectionId,
                    trackIds: options.tracks
                        .map((track) => track.id)
                        .toList(),
                  );
                },
              );
            },
          ),
        if (options.shareUrl != null)
          Tooltip(
            tooltip: TooltipContainer(
              child: Text(context.l10n.share),
            ).call,
            child: IconButton.outline(
              icon: const Icon(
                SpotubeIcons.share,
                color: Colors.white,
              ),
              size: ButtonSize.small,
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text: options.shareUrl!,
                  ),
                );

                if (!context.mounted) {
                  return;
                }

                showToast(
                  context: context,
                  location: ToastLocation.topRight,
                  builder: (context, overlay) {
                    return SurfaceCard(
                      child: Text(
                        context.l10n.copied_shareurl_to_clipboard(
                          options.shareUrl!,
                        ),
                      ).small(),
                    );
                  },
                );
              },
            ),
          ),
        if (options.onHeart != null)
          HeartButton(
            isLiked: options.isLiked,
            tooltip: options.isLiked
                ? context.l10n.remove_from_favorites
                : context.l10n.save_as_favorite,
            variance: ButtonVariance.outline,
            size: ButtonSize.small,
            onPressed: options.onHeart,
          ),
      ],
    );

    return SliverMainAxisGroup(
      slivers: [
        if (mediaQuery.mdAndUp)
          SliverGap(16 * scale),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: (mediaQuery.mdAndUp ? 16 : 12) * scale,
          ),
          sliver: SliverList.list(
            children: [
              Container(
                padding: EdgeInsets.all(
                  mediaQuery.mdAndUp ? 24 * scale : 18 * scale,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF282828),
                      Color(0xFF181818),
                      Color(0xFF121212),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16 * scale),
                  border: Border.all(
                    color: const Color(0xFF333333),
                    width: 1,
                  ),
                ),
                child: Flex(
                  direction: mediaQuery.mdAndUp
                      ? Axis.horizontal
                      : Axis.vertical,
                  crossAxisAlignment: mediaQuery.mdAndUp
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: imageDimension * scale,
                      width: imageDimension * scale,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8 * scale),
                        image: decorationImage,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(150),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: mediaQuery.mdAndUp ? 22 * scale : 0,
                      height: mediaQuery.mdAndUp ? 0 : 22 * scale,
                    ),
                    Expanded(
                      flex: mediaQuery.mdAndUp ? 1 : 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: mediaQuery.mdAndUp
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            options.title,
                            maxLines: 2,
                            minFontSize: 22,
                            maxFontSize: mediaQuery.mdAndUp ? 42 : 30,
                            textAlign: mediaQuery.mdAndUp
                                ? TextAlign.start
                                : TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: mediaQuery.mdAndUp ? 42 : 30,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                              height: 1.05,
                            ),
                          ),
                          if (options.description != null) ...[
                            const Gap(10),
                            AutoSizeText(
                              options.description!,
                              maxLines: 3,
                              minFontSize: 13,
                              maxFontSize: 16,
                              overflow: TextOverflow.ellipsis,
                              textAlign: mediaQuery.mdAndUp
                                  ? TextAlign.start
                                  : TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFB3B3B3),
                                fontSize: 15,
                                height: 1.35,
                              ),
                            ),
                          ],
                          const Gap(14),
                          Wrap(
                            spacing: 8 * scale,
                            runSpacing: 8 * scale,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: mediaQuery.mdAndUp
                                ? WrapAlignment.start
                                : WrapAlignment.center,
                            children: [
                              if (options.owner != null)
                                OutlineBadge(
                                  leading: options.ownerImage != null
                                      ? Avatar(
                                          initials:
                                              options.owner?[0] ?? 'U',
                                          provider: UniversalImage
                                              .imageProvider(
                                            options.ownerImage!,
                                          ),
                                          size: 20 * scale,
                                        )
                                      : null,
                                  child: Text(
                                    options.owner!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ).small(),
                                ),
                              additionalActions,
                            ],
                          ),
                          const Gap(18),
                          playbackActions,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
