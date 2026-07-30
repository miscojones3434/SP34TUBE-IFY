import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/core/auth.dart';
import 'package:spotube/provider/metadata_plugin/core/user.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Perfil propio de SP34TUBE-IFY.
///
/// Utiliza la sesión y el perfil reales proporcionados por el sistema
/// de metadatos de Spotube.
///
/// No crea usuarios ficticios, no emplea FakeData y no sustituye
/// el perfil original de Spotube.
@RoutePage()
class Pt34ProfilePage extends HookConsumerWidget {
  static const name = 'pt34-profile';

  const Pt34ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticated = ref.watch(metadataPluginAuthenticatedProvider);
    final user = ref.watch(metadataPluginUserProvider);

    return SafeArea(
      child: Scaffold(
        headers: const [
          TitleBar(
            title: Text('Perfil PT34'),
          ),
        ],
        child: authenticated.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => _ProfileMessage(
            title: 'No se pudo comprobar la sesión',
            message: error.toString(),
          ),
          data: (isAuthenticated) {
            if (!isAuthenticated) {
              return const _ProfileMessage(
                title: 'Cuenta no conectada',
                message:
                    'Inicia sesión o configura un proveedor de metadatos '
                    'compatible para mostrar aquí tu perfil real.',
              );
            }

            return user.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => _ProfileMessage(
                title: 'No se pudo cargar el perfil',
                message: error.toString(),
              ),
              data: (profile) {
                if (profile == null) {
                  return const _ProfileMessage(
                    title: 'Perfil no disponible',
                    message:
                        'La sesión está conectada, pero el proveedor todavía '
                        'no ha entregado los datos del perfil del usuario.',
                  );
                }

                final currentProfile = profile;
                final externalUri = currentProfile.externalUri ?? '';

                return CustomScrollView(
                  slivers: [
                    const SliverGap(24),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(600),
                              child: UniversalImage(
                                path: currentProfile.images.asUrlString(
                                  index: 1,
                                  placeholder: ImagePlaceholder.artist,
                                ),
                                width: 220,
                                height: 220,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Gap(20),
                            Text(
                              currentProfile.name,
                              textAlign: TextAlign.center,
                            ).h2(),
                            const Gap(8),
                            const Text(
                              'Perfil conectado mediante el proveedor real '
                              'configurado en Spotube.',
                              textAlign: TextAlign.center,
                            ).muted(),
                            const Gap(24),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text('Cuenta conectada').h3(),
                                    const Gap(8),
                                    Text(
                                      'Usuario: ${currentProfile.name}',
                                    ),
                                    const Gap(8),
                                    const Text(
                                      'La biblioteca, playlists, artistas y '
                                      'álbumes se obtienen mediante los sistemas '
                                      'auténticos de Spotube.',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(16),
                            if (externalUri.isNotEmpty)
                              Button.outline(
                                leading: const Icon(Icons.open_in_new),
                                onPressed: () {
                                  launchUrlString(
                                    externalUri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                                child: const Text(
                                  'Abrir perfil externo',
                                ),
                              ),
                            const Gap(24),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Sistemas originales conservados',
                                    ).h3(),
                                    const Gap(8),
                                    const Text(
                                      'Este perfil no sustituye ni modifica '
                                      'el perfil original, la autenticación, '
                                      'Spotify, los metadatos, las carátulas, '
                                      'la biblioteca ni el reproductor de Spotube.',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverGap(200),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ProfileMessage extends StatelessWidget {
  final String title;
  final String message;

  const _ProfileMessage({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                ).h3(),
                const Gap(10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
