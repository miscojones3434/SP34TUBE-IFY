import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/string.dart';
import 'package:spotube/utils/platform.dart';

class PlaybuttonCard extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onPlaybuttonPressed;
  final void Function()? onAddToQueuePressed;
  final String? description;

  final String? imageUrl;
  final Widget? image;
  final bool isPlaying;
  final bool isLoading;
  final String title;
  final bool isOwner;

  const PlaybuttonCard({
    required this.isPlaying,
    required this.isLoading,
    required this.title,
    this.description,
    this.onPlaybuttonPressed,
    this.onAddToQueuePressed,
    this.onTap,
    this.isOwner = false,
    this.imageUrl,
    this.image,
    super.key,
  }) : assert(
          imageUrl != null || image != null,
          "imageUrl and image can't be null at the same time",
        );

  @override
  Widget build(BuildContext context) {
    final cleanDescription =
        description?.unescapeHtml().cleanHtml() ?? "";

    final scale = context.theme.scaling;

    return SizedBox(
      width: 150 * scale,
      child: CardImage(
        image: Stack(
          children: [
            if (imageUrl != null)
              Container(
                width: 150 * scale,
                height: 150 * scale,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6 * scale),
                  image: DecorationImage(
                    image: UniversalImage.imageProvider(
                      imageUrl!,
                      height: 200 * scale,
                      width: 200 * scale,
                    ),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(90),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                width: 150 * scale,
                height: 150 * scale,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6 * scale),
                  child: image!,
                ),
              ),

            StatedWidget.builder(
              builder: (context, states) {
                final hovered =
                    states.contains(WidgetState.hovered);

                final showQueue =
                    (hovered || kIsMobile) && !isLoading;

                final showPlayback =
                    hovered || kIsMobile || isPlaying || isLoading;

                return Positioned(
                  right: 8,
                  bottom: 8,
                  child: Column(
                    children: [
                      AnimatedScale(
                        curve: Curves.easeOutBack,
                        duration: const Duration(
                          milliseconds: 220,
                        ),
                        scale: showQueue ? 1 : 0.75,
                        child: AnimatedOpacity(
                          duration: const Duration(
                            milliseconds: 180,
                          ),
                          opacity: showQueue ? 1 : 0,
                          child: IgnorePointer(
                            ignoring: !showQueue,
                            child: IconButton.secondary(
                              icon: const Icon(
                                SpotubeIcons.queueAdd,
                              ),
                              onPressed: onAddToQueuePressed,
                              size: ButtonSize.small,
                            ),
                          ),
                        ),
                      ),
                      const Gap(5),
                      AnimatedScale(
                        curve: Curves.easeOutBack,
                        duration: const Duration(
                          milliseconds: 180,
                        ),
                        scale: showPlayback ? 1 : 0.75,
                        child: AnimatedOpacity(
                          duration: const Duration(
                            milliseconds: 160,
                          ),
                          opacity: showPlayback ? 1 : 0,
                          child: IgnorePointer(
                            ignoring: !showPlayback,
                            child: IconButton.secondary(
                              icon: switch (
                                  (isLoading, isPlaying)) {
                                (true, _) =>
                                  const CircularProgressIndicator(
                                    size: 15,
                                  ),
                                (false, false) => const Icon(
                                    SpotubeIcons.play,
                                  ),
                                (false, true) => const Icon(
                                    SpotubeIcons.pause,
                                  ),
                              },
                              enabled: !isLoading,
                              onPressed: onPlaybuttonPressed,
                              size: ButtonSize.small,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            if (isOwner)
              const Positioned(
                right: 5,
                top: 5,
                child: SecondaryBadge(
                  style: ButtonStyle.secondaryIcon(
                    shape: ButtonShape.circle,
                    size: ButtonSize.small,
                  ),
                  child: Icon(
                    SpotubeIcons.user,
                  ),
                ),
              ),
          ],
        ),
        title: Tooltip(
          tooltip: TooltipContainer(
            child: Text(title),
          ).call,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ),
        subtitle: Text(
          cleanDescription.isEmpty
              ? "\n"
              : cleanDescription,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFFB3B3B3),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}
