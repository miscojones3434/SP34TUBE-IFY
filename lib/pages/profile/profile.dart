import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/core/user.dart';
import 'package:url_launcher/url_launcher_string.dart';

@RoutePage()
class ProfilePage extends HookConsumerWidget {
  static const name = "profile";

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(metadataPluginUserProvider);
    final meData = me.asData?.value ?? FakeData.user;

    return SafeArea(
      child: Scaffold(
        headers: [
          TitleBar(
            title: Text(context.l10n.profile),
          ),
        ],
        child: ColoredBox(
          color: const Color(0xFF121212),
          child: Skeletonizer(
            enabled: me.isLoading,
            child: CustomScrollView(
              slivers: [
                const SliverGap(24),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1ED760),
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(600),
                            child: UniversalImage(
                              path: meData.images.asUrlString(
                                index: 1,
                                placeholder:
                                    ImagePlaceholder.artist,
                              ),
                              width: 190,
                              height: 190,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Gap(20),
                        Text(
                          meData.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                          ),
                        ),
                        const Gap(8),
                        const Text(
                          'Cuenta conectada',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFB3B3B3),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Gap(24),
                        Button.outline(
                          leading: const Icon(
                            SpotubeIcons.edit,
                            color: Colors.white,
                            size: 19,
                          ),
                          onPressed: () {
                            launchUrlString(
                              meData.externalUri,
                              mode:
                                  LaunchMode.externalApplication,
                            );
                          },
                          child: const Text(
                            'Abrir perfil',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverGap(28),
                SliverCrossAxisConstrained(
                  maxCrossAxisExtent: 500,
                  child: SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF242424),
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xFF1ED760),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                SpotubeIcons.user,
                                color: Colors.black,
                                size: 22,
                              ),
                            ),
                            Gap(14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Perfil de SP34TUBE-IFY',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),
                                  Gap(4),
                                  Text(
                                    'Tus playlists, artistas, álbumes y biblioteca pertenecen a la cuenta conectada.',
                                    style: TextStyle(
                                      color:
                                          Color(0xFFB3B3B3),
                                      fontSize: 13,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SliverGap(200),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
