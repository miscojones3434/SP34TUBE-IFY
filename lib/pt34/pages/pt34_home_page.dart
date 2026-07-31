import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/pt34/core/pt34_brand.dart';

/// Pantalla principal propia de SP34TUBE-IFY.
///
/// Mantiene intactos el reproductor, los metadatos, YouTube Audio,
/// la biblioteca, las carátulas y todas las funciones originales
/// de Spotube.
@RoutePage()
class Pt34HomePage extends HookConsumerWidget {
  static const name = 'pt34-home';

  const Pt34HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        headers: const [
          TitleBar(
            title: Text(Pt34Brand.appName),
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
                    const Text(Pt34Brand.appName).h2(),
                    const Gap(8),
                    const Text(Pt34Brand.slogan).muted(),
                    const Gap(32),
                    const Text('Tu espacio musical').h3(),
                    const Gap(16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.history),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Mi actividad').h3(),
                                  const Gap(6),
                                  const Text(
                                    'Consulta tu actividad musical y las '
                                    'estadísticas reales registradas por Spotube.',
                                  ),
                                ],
                              ),
                            ),
                            const Gap(12),
                            Button.outline(
                              onPressed: () {
                                context.navigateTo(
                                  const Pt34MyActivityRoute(),
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
                            const Icon(Icons.library_music),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Mis canciones').h3(),
                                  const Gap(6),
                                  const Text(
                                    'Accede a tus playlists, descargas y '
                                    'canciones locales reales.',
                                  ),
                                ],
                              ),
                            ),
                            const Gap(12),
                            Button.outline(
                              onPressed: () {
                                context.navigateTo(
                                  const Pt34MySongsRoute(),
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
                            const Icon(Icons.person),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Perfil PT34').h3(),
                                  const Gap(6),
                                  const Text(
                                    'Consulta el perfil real de la cuenta '
                                    'conectada mediante el proveedor configurado.',
                                  ),
                                ],
                              ),
                            ),
                            const Gap(12),
                            Button.outline(
                              onPressed: () {
                                context.navigateTo(
                                  const Pt34ProfileRoute(),
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
                            const Text('Estado de integración').h3(),
                            const Gap(8),
                            const Text(
                              'Inicio, actividad, canciones y perfil PT34 '
                              'están conectados con funciones reales de Spotube.',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(24),
                    const Text('Motores originales conservados').h3(),
                    const Gap(12),
                    const Text(
                      'Spotube mantiene su reproducción, búsqueda, catálogo, '
                      'metadatos, carátulas, biblioteca, cola y YouTube Audio.',
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
