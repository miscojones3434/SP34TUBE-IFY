import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/titlebar/titlebar.dart';

/// Pantalla propia de canciones y proyectos musicales de SP34TUBE-IFY.
///
/// Conecta con las secciones reales de biblioteca, playlists,
/// canciones guardadas, descargas y archivos locales de Spotube.
///
/// No inventa canciones, archivos ni datos del usuario.
/// No sustituye ni modifica la biblioteca original de Spotube.
@RoutePage()
class Pt34MySongsPage extends HookConsumerWidget {
  static const name = 'pt34-my-songs';

  const Pt34MySongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        headers: const [
          TitleBar(
            title: Text('Mis canciones'),
          ),
        ],
        child: CustomScrollView(
          slivers: [
            const SliverGap(24),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Mis canciones').h2(),
                    const Gap(8),
                    const Text(
                      'Accede a tu música real mediante las funciones '
                      'originales de Spotube.',
                    ).muted(),
                    const Gap(32),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.favorite),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Canciones guardadas y playlists',
                                  ).h3(),
                                  const Gap(6),
                                  const Text(
                                    'Abre tus canciones favoritas y las '
                                    'playlists reales de tu cuenta conectada.',
                                  ),
                                ],
                              ),
                            ),
                            const Gap(12),
                            Button.outline(
                              onPressed: () {
                                context.navigateTo(
                                  const LibraryRoute(
                                    children: [
                                      UserPlaylistsRoute(),
                                    ],
                                  ),
                                );
                              },
                              child: const Text('Abrir'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.download),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Canciones descargadas').h3(),
                                  const Gap(6),
                                  const Text(
                                    'Accede a las descargas reales gestionadas '
                                    'por el sistema original de Spotube.',
                                  ),
                                ],
                              ),
                            ),
                            const Gap(12),
                            Button.outline(
                              onPressed: () {
                                context.navigateTo(
                                  const LibraryRoute(
                                    children: [
                                      UserDownloadsRoute(),
                                    ],
                                  ),
                                );
                              },
                              child: const Text('Abrir'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.folder),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Música local').h3(),
                                  const Gap(6),
                                  const Text(
                                    'Abre las canciones reales almacenadas '
                                    'localmente en tu dispositivo.',
                                  ),
                                ],
                              ),
                            ),
                            const Gap(12),
                            Button.outline(
                              onPressed: () {
                                context.navigateTo(
                                  const LibraryRoute(
                                    children: [
                                      UserLocalLibraryRoute(),
                                    ],
                                  ),
                                );
                              },
                              child: const Text('Abrir'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Canciones creadas').h3(),
                            const Gap(8),
                            const Text(
                              'Aquí aparecerán únicamente las canciones reales '
                              'que guardes o generes mediante las funciones PT34.',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Proyectos en curso').h3(),
                            const Gap(8),
                            const Text(
                              'Esta sección mostrará los proyectos musicales '
                              'guardados cuando conectemos su almacenamiento real.',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Biblioteca original conservada').h3(),
                            const Gap(8),
                            const Text(
                              'Las playlists, álbumes, artistas, descargas y '
                              'canciones locales de Spotube siguen funcionando '
                              'en sus secciones originales.',
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
        ),
      ),
    );
  }
}
