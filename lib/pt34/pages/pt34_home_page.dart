import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/pt34/core/pt34_brand.dart';

/// Pantalla principal propia de SP34TUBE-IFY.
///
/// No modifica el reproductor, los metadatos, YouTube Audio
/// ni ninguna función original de Spotube.
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
                    const Gap(12),
                    const Text(
                      'Aquí se integrarán Mi actividad, Mis canciones, '
                      'Crear música con IA, distribución musical y perfil PT34.',
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
