import 'package:flutter/services.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/fallbacks/error_box.dart';
import 'package:spotube/components/fallbacks/no_default_metadata_plugin.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/string.dart';
import 'package:spotube/hooks/controllers/use_shadcn_text_editing_controller.dart';
import 'package:spotube/pages/search/tabs/albums.dart';
import 'package:spotube/pages/search/tabs/all.dart';
import 'package:spotube/pages/search/tabs/artists.dart';
import 'package:spotube/pages/search/tabs/playlists.dart';
import 'package:spotube/pages/search/tabs/tracks.dart';
import 'package:spotube/provider/metadata_plugin/search/all.dart';
import 'package:spotube/services/kv_store/kv_store.dart';
import 'package:auto_route/auto_route.dart';
import 'package:spotube/services/metadata/errors/exceptions.dart';

final searchTermStateProvider = StateProvider<String>((ref) {
  return "";
});

@RoutePage()
class SearchPage extends HookConsumerWidget {
  static const name = "search";

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useShadcnTextEditingController();
    final focusNode = useFocusNode();
    final searchTerm = ref.watch(searchTermStateProvider);
    final searchChipSnapshot =
        ref.watch(metadataPluginSearchChipsProvider);

    final selectedChip = useState<String?>(
      searchChipSnapshot.asData?.value.first ?? "all",
    );

    ref.listen(
      metadataPluginSearchChipsProvider,
      (previous, next) {
        selectedChip.value =
            next.asData?.value.first ?? "all";
      },
    );

    useEffect(() {
      controller.text = searchTerm;
      return null;
    }, []);

    void onSubmitted(String value) {
      ref.read(searchTermStateProvider.notifier).state = value;
      focusNode.unfocus();

      if (value.trim().isEmpty) {
        return;
      }

      KVStoreService.setRecentSearches(
        {
          value,
          ...KVStoreService.recentSearches,
        }.toList(),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        context.navigateTo(const HomeRoute());
      },
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          headers: [
            if (kTitlebarVisible)
              const TitleBar(
                automaticallyImplyLeading: false,
                height: 30,
              ),
          ],
          child: ColoredBox(
            color: const Color(0xFF121212),
            child: Builder(
              builder: (context) {
                if (searchChipSnapshot.error
                    case MetadataPluginException(
                      errorCode:
                          MetadataPluginErrorCode
                              .noDefaultMetadataPlugin,
                      message: _,
                    )) {
                  return const NoDefaultMetadataPlugin();
                }

                if (searchChipSnapshot.hasError) {
                  return ErrorBox(
                    error: searchChipSnapshot.error!,
                    onRetry: () {
                      ref.invalidate(
                        metadataPluginSearchChipsProvider,
                      );
                    },
                  );
                }

                return Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(
                        20,
                        18,
                        20,
                        4,
                      ),
                      child: Text(
                        context.l10n.search,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 29,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.7,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: ListenableBuilder(
                              listenable: controller,
                              builder: (context, _) {
                                final suggestions =
                                    controller.text.isEmpty
                                        ? KVStoreService
                                            .recentSearches
                                        : KVStoreService
                                            .recentSearches
                                            .where(
                                              (search) =>
                                                  weightedRatio(
                                                    search
                                                        .toLowerCase(),
                                                    controller
                                                        .text
                                                        .toLowerCase(),
                                                  ) >
                                                  50,
                                            )
                                            .toList();

                                return AutoComplete(
                                  suggestions:
                                      suggestions.length <= 2
                                          ? [
                                              ...suggestions,
                                              "Twenty One Pilots",
                                              "Linkin Park",
                                            ]
                                          : suggestions,
                                  completer: (suggestion) =>
                                      suggestion,
                                  mode:
                                      AutoCompleteMode.replaceAll,
                                  child: TextField(
                                    autofocus: true,
                                    controller: controller,
                                    focusNode: focusNode,
                                    features: [
                                      const InputFeature.leading(
                                        Icon(
                                          SpotubeIcons.search,
                                        ),
                                      ),
                                      InputFeature.trailing(
                                        AnimatedCrossFade(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          crossFadeState:
                                              controller
                                                      .text
                                                      .isNotEmpty
                                                  ? CrossFadeState
                                                      .showFirst
                                                  : CrossFadeState
                                                      .showSecond,
                                          firstChild:
                                              IconButton.ghost(
                                            size:
                                                ButtonSize.small,
                                            icon: const Icon(
                                              SpotubeIcons.close,
                                            ),
                                            onPressed: () {
                                              controller.clear();
                                            },
                                          ),
                                          secondChild:
                                              const SizedBox.square(
                                            dimension: 28,
                                          ),
                                        ),
                                      ),
                                    ],
                                    textInputAction:
                                        TextInputAction.search,
                                    placeholder: Text(
                                      context.l10n.search,
                                    ),
                                    onSubmitted: onSubmitted,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 48,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Row(
                          children: [
                            if (searchChipSnapshot
                                    .asData?.value !=
                                null)
                              for (final chip
                                  in searchChipSnapshot
                                      .asData!.value) ...[
                                _SearchFilterChip(
                                  label: chip.capitalize(),
                                  selected:
                                      selectedChip.value ==
                                          chip,
                                  onPressed: () {
                                    selectedChip.value =
                                        chip;
                                  },
                                ),
                                const Gap(8),
                              ],
                          ],
                        ),
                      ),
                    ),
                    const Gap(6),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 300,
                        ),
                        child: switch (
                            selectedChip.value) {
                          "tracks" =>
                            const SearchPageTracksTab(),
                          "albums" =>
                            const SearchPageAlbumsTab(),
                          "artists" =>
                            const SearchPageArtistsTab(),
                          "playlists" =>
                            const SearchPagePlaylistsTab(),
                          _ => const SearchPageAllTab(),
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  const _SearchFilterChip({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 160,
        ),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF1ED760)
              : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                selected ? Colors.black : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
