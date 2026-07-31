import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/string.dart';

class PlaybuttonTile extends StatelessWidget {
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

  const PlaybuttonTile({
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
        description?.unescapeHtml().cleanHtml() ?? '';
    final scale = context.theme.scaling;

    return Container(
      height: 64 * scale,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(5 * scale),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          GestureDetector(
            onTap: isLoading ? null : onTap,
            behavior: HitTestBehavior.opaque,
            child: imageUrl != null
                ? SizedBox(
                    width: 64 * scale,
                    height: 64 * scale,
                    child: UniversalImage(
                      path: imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  )
                : SizedBox(
                    width: 64 * scale,
                    height: 64 * scale,
                    child: image,
                  ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: isLoading ? null : onTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12 * scale,
                  vertical: 8 * scale,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: cleanDescription.isEmpty ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                    ),
                    if (cleanDescription.isNotEmpty) ...[
                      const Gap(3),
                      Text(
                        cleanDescription,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFB3B3B3),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (onAddToQueuePressed != null)
            Tooltip(
              tooltip: TooltipContainer(
                child: Text(context.l10n.add_to_queue),
              ).call,
              child: IconButton.ghost(
                size: ButtonSize.small,
                icon: const Icon(
                  SpotubeIcons.queueAdd,
                  color: Color(0xFFB3B3B3),
                  size: 18,
                ),
                enabled: !isLoading,
                onPressed: onAddToQueuePressed,
              ),
            ),
          Tooltip(
            tooltip: TooltipContainer(
              child: Text(
                isPlaying
                    ? context.l10n.pause
                    : context.l10n.play,
              ),
            ).call,
            child: IconButton.ghost(
              size: ButtonSize.small,
              enabled: !isLoading,
              onPressed: onPlaybuttonPressed,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        size: 20,
                      ),
                    )
                  : Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1ED760),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isPlaying
                            ? SpotubeIcons.pause
                            : SpotubeIcons.play,
                        color: Colors.black,
                        size: 18,
                      ),
                    ),
            ),
          ),
          Gap(4 * scale),
        ],
      ),
    );
  }
}
