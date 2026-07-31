import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
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

  /// Diseño compacto para los accesos rápidos de Inicio.
  /// No muestra controles permanentes de cola ni reproducción.
  final bool compact;

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
    this.compact = false,
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

    if (compact) {
      return Container(
        height: 64 * scale,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(5 * scale),
        ),
        clipBehavior: Clip.antiAlias,
        child: Button(
          enabled: !isLoading,
          onPressed: onTap,
          style: ButtonVariance.ghost.copyWith(
            padding: (context, states, value) => EdgeInsets.zero,
          ),
          child: Row(
            children: [
              if (imageUrl != null)
                SizedBox(
                  width: 64 * scale,
                  height: 64 * scale,
                  child: UniversalImage(
                    path: imageUrl!,
                    fit: BoxFit.cover,
                  ),
                )
              else
                SizedBox(
                  width: 64 * scale,
                  height: 64 * scale,
                  child: ClipRRect(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(5 * scale),
                    ),
                    child: image,
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12 * scale,
                    vertical: 8 * scale,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Padding(
                  padding: EdgeInsets.only(
                    right: 12 * scale,
                  ),
                  child: const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Button(
      leading: imageUrl != null
          ? Container(
              width: 50 * scale,
              height: 50 * scale,
              decoration: BoxDecoration(
                borderRadius: context.theme.borderRadiusMd,
                image: DecorationImage(
                  image: UniversalImage.imageProvider(imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : SizedBox(
              width: 50 * scale,
              height: 50 * scale,
              child: ClipRRect(
                borderRadius: context.theme.borderRadiusMd,
                child: image,
              ),
            ),
      style: ButtonVariance.ghost.copyWith(
        padding: (context, states, value) {
          return (ButtonVariance.ghost.padding(
            context,
            states,
          ) as EdgeInsets)
              .copyWith(
            right: 0,
            left: 0,
          );
        },
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            tooltip: TooltipContainer(
              child: Text(
                context.l10n.add_to_queue,
              ),
            ).call,
            child: IconButton.outline(
              icon: const Icon(
                SpotubeIcons.queueAdd,
              ),
              onPressed: onAddToQueuePressed,
              enabled: !isLoading,
            ),
          ),
          const Gap(8),
          Tooltip(
            tooltip: TooltipContainer(
              child: Text(
                context.l10n.play,
              ),
            ).call,
            child: IconButton.secondary(
              icon: switch ((isLoading, isPlaying)) {
                (true, _) => const CircularProgressIndicator(
                    size: 22,
                  ),
                (false, false) => const Icon(
                    SpotubeIcons.play,
                  ),
                (false, true) => const Icon(
                    SpotubeIcons.pause,
                  ),
              },
              onPressed: onPlaybuttonPressed,
              enabled: !isLoading,
            ),
          ),
        ],
      ),
      enabled: !isLoading,
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          if (cleanDescription.isNotEmpty)
            Text(
              description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ).xSmall().muted(),
        ],
      ),
    );
  }
}
