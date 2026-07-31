import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/components/track_presentation/presentation_list.dart';
import 'package:spotube/components/track_presentation/presentation_props.dart';
import 'package:spotube/components/track_presentation/presentation_top.dart';
import 'package:spotube/components/track_presentation/presentation_modifiers.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/utils/platform.dart';

class TrackPresentation extends HookConsumerWidget {
  final TrackPresentationOptions options;

  const TrackPresentation({
    super.key,
    required this.options,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final focusNode = useFocusNode();
    final scale = context.theme.scaling;

    useEffect(() {
      if (!kIsMobile) {
        return null;
      }

      void listener() {
        if (!scrollController.hasClients) {
          return;
        }

        if (focusNode.hasFocus) {
          scrollController.animateTo(
            300 * scale,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }

      focusNode.addListener(listener);

      return () {
        focusNode.removeListener(listener);
      };
    }, [focusNode, scrollController, scale]);

    return Data<TrackPresentationOptions>.inherit(
      data: options,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          headers: const [
            TitleBar(),
          ],
          child: ColoredBox(
            color: const Color(0xFF121212),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                const TrackPresentationTopSection(),
                const SliverGap(16),
                SliverList.list(
                  children: [
                    TrackPresentationModifiersSection(
                      focusNode: focusNode,
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFF2A2A2A),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Basic(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 4,
                            ),
                            leading: constraints.mdAndUp
                                ? const Text(
                                    '#',
                                    style: TextStyle(
                                      color: Color(0xFFB3B3B3),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : null,
                            title: Row(
                              children: [
                                Expanded(
                                  flex: constraints.lgAndUp ? 5 : 6,
                                  child: Text(
                                    context.l10n.title,
                                    style: const TextStyle(
                                      color: Color(0xFFB3B3B3),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (constraints.mdAndUp)
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      context.l10n.album,
                                      style: const TextStyle(
                                        color: Color(0xFFB3B3B3),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                Text(
                                  context.l10n.duration,
                                  style: const TextStyle(
                                    color: Color(0xFFB3B3B3),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const PresentationListSection(),
                const SliverSafeArea(
                  sliver: SliverGap(10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
