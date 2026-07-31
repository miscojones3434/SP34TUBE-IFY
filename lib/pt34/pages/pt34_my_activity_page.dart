import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/pt34/core/pt34_brand.dart';

/// Pantalla propia de actividad musical de SP34TUBE-IFY.
///
/// Conecta con las estadísticas reales que ya mantiene Spotube.
///
/// No inventa reproducciones, minutos, artistas, álbumes ni playlists.
/// No sustituye ni modifica las estadísticas originales de Spotube.
@RoutePage()
class Pt34MyActivityPage extends HookConsumerWidget {
  static const name = 'pt34-my-activity';

  const Pt34MyActivityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        headers: const [
          TitleBar(
            title: Text(Pt34Brand.myActivityTitle),
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
                    const Text(Pt34Brand.myActivityTitle).h2(),
                    const Gap(8),
                    const Text(
                      'Consulta tu actividad musical real registrada por Spotube.',
                    ).muted(),
                    const Gap(32),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.bar_chart),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Resumen de actividad').h3(),
                                  const Gap(6),
                                  const Text(
                                    'Abre el resumen completo de estadísticas '
                                    'musicales disponible en Spotube.',
                                  ),
                                ],
                              ),
                            ),
                            const Gap(12),
                            Button.outline(
                              onPressed: () {
                                context.navigateTo(
                                  const StatsRoute(),
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
                            const Icon(Icons.schedule),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Minutos escuchados').h3(),
                                  const Gap(6),
                                  const Text(
                                    'Consulta los minutos reales de escucha '
                                    'registrados por el sistema.',
                                  ),
                                ],
                              ),
                            ),
                            const Gap(12),
                            Button.outline(
                              onPressed: () {
                                context.navigateTo(
                                  const StatsMinutesRoute(),
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
                            const Icon(Icons.play_circle),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Reproducciones').h3(),
                                  const Gap(6),
                                  const Text(
                                    'Consulta las reproducciones registradas '
                                    'por las estadísticas originales.',
                                  ),
                                ],
                              ),
                            ),
                            const Gap(12),
                            Button.outline(
                              onPressed: () {
                                context.navigateTo(
                                  const StatsStreamsRoute(),
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
                            const Icon(Icons.person_search),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Artistas escuchados').h3(),
                                  const Gap(6),
                                  const Text(
                                    'Consulta los artistas registrados en '
                                    'tu actividad musical.',
                                  ),
                                ],
                              ),
                            ),
                            const Gap(12),
                            Button.outline(
                              onPressed: () {
                                context.navigateTo(
                                  const StatsArtistsRoute(),
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
                            const Icon(Icons.album),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Álbumes escuchados').h3(),
                                  const Gap(6),
                                  const Text(
                                    'Consulta los álbumes registrados en '
                                    'las estadísticas de escucha.',
                                  ),
                                ],
                              ),
                            ),
                            const Gap(12),
                            Button.outline(
                              onPressed: () {
                                context.navigateTo(
                                  const StatsAlbumsRoute(),
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
                            const Icon(Icons.queue_music),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Playlists escuchadas').h3(),
                                  const Gap(6),
                                  const Text(
                                    'Consulta las playlists registradas en '
                                    'tu actividad musical.',
                                  ),
                                ],
                              ),
                            ),
                            const Gap(12),
                            Button.outline(
                              onPressed: () {
                                context.navigateTo(
                                  const StatsPlaylistsRoute(),
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
                            const Text('Actividad de creación').h3(),
                            const Gap(8),
                            const Text(
                              'Esta sección mostrará únicamente actividad '
                              'propia de PT34 cuando exista almacenamiento real.',
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
                            const Text('Sistemas originales intactos').h3(),
                            const Gap(8),
                            const Text(
                              'Las estadísticas, el historial, el reproductor '
                              'y los proveedores originales de Spotube '
                              'continúan funcionando sin cambios.',
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
