import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/pt34/core/pt34_brand.dart';

/// Pantalla propia de actividad musical de SP34TUBE-IFY.
///
/// Esta primera versión crea únicamente la estructura visual.
/// No modifica ni sustituye las estadísticas, el historial,
/// el reproductor ni los proveedores originales de Spotube.
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
                      'Tu actividad musical dentro de SP34TUBE-IFY.',
                    ).muted(),
                    const Gap(32),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Actividad de escucha').h3(),
                            const Gap(8),
                            const Text(
                              'Aquí se conectarán progresivamente tus '
                              'reproducciones, artistas, álbumes, listas y '
                              'estadísticas reales proporcionadas por Spotube.',
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
                              'Aquí se mostrarán tus canciones, proyectos, '
                              'generaciones y procesos propios de PT34 cuando '
                              'sus proveedores reales estén conectados.',
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
                            const Text('Motores originales intactos').h3(),
                            const Gap(8),
                            const Text(
                              'Esta pantalla no sustituye ni desactiva las '
                              'estadísticas, el historial ni los sistemas '
                              'originales de Spotube.',
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
