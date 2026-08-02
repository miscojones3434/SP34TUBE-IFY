import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/history/recent.dart';

class HomeRecentlyPlayedSection extends HookConsumerWidget {
  const HomeRecentlyPlayedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(recentlyPlayedItems);

    if (history.hasError) {
      return const SizedBox.shrink();
    }

    if (history.isLoading) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SpotifyHeader(),
          _SpotifyRecentSkeleton(),
        ],
      );
    }

    final historyData = history.asData?.value ?? const [];

    // Inyectamos la tarjeta fija de "Canciones que te gustan" al principio
    final visibleItems = <_SpotifyRecentItem>[
      _SpotifyRecentItem.likedSongs(),
      for (final item in historyData)
        if (item.playlist != null)
          _SpotifyRecentItem.playlist(item.playlist!)
        else if (item.album != null)
          _SpotifyRecentItem.album(item.album!),
    ].take(8).toList(growable: false);

    if (visibleItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SpotifyHeader(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: GridView.builder(
            shrinkWrap: true,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visibleItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 56, // Ajustado para coincidir con la proporción de la imagen real
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return _SpotifyRecentTile(
                item: visibleItems[index],
              );
            },
          ),
        ),
      ],
    );
  }
}

// --- NUEVO: Cabecera con Perfil y Filtros ---
class _SpotifyHeader extends StatelessWidget {
  const _SpotifyHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFD4815D), // Color similar al de la imagen
            child: Text(
              'S',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _FilterChip(label: 'Todos', isSelected: true),
          const SizedBox(width: 8),
          _FilterChip(label: 'Música', isSelected: false),
          const SizedBox(width: 8),
          _FilterChip(label: 'Pódcasts', isSelected: false),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1ED760) : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(20), // Forma de píldora
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
// --------------------------------------------

class _SpotifyRecentTile extends StatelessWidget {
  final _SpotifyRecentItem item;

  const _SpotifyRecentTile({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    // Lógica para renderizar la imagen web o el degradado de favoritos
    if (item.type == _SpotifyRecentItemType.likedSongs) {
      imageWidget = Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF450AF5), Color(0xFF8E8EE5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(
          Icons.favorite,
          color: Colors.white,
          size: 24,
        ),
      );
    } else {
      imageWidget = SizedBox(
        width: 56,
        height: 56,
        child: UniversalImage(
          path: item.imageUrl,
          fit: BoxFit.cover,
        ),
      );
    }

    return Material(
      color: const Color(0xFF2A2A2A), // Fondo de la tarjeta
      borderRadius: BorderRadius.circular(6), // Esquinas ligeramente más redondeadas
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          switch (item.type) {
            case _SpotifyRecentItemType.playlist:
              final playlist = item.playlist!;
              context.navigateTo(
                PlaylistRoute(
                  id: playlist.id,
                  playlist: playlist,
                ),
              );
              break;
            case _SpotifyRecentItemType.album:
              final album = item.album!;
              context.navigateTo(
                AlbumRoute(
                  id: album.id,
                  album: album,
                ),
              );
              break;
            case _SpotifyRecentItemType.likedSongs:
              // TODO: Navegar a la ruta de canciones que te gustan
              break;
          }
        },
        child: Row(
          children: [
            imageWidget,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpotifyRecentSkeleton extends StatelessWidget {
  const _SpotifyRecentSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: GridView.builder(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 8,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 56,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: ColoredBox(
                      color: Color(0xFF404040),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        'Cargando...',
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

enum _SpotifyRecentItemType {
  playlist,
  album,
  likedSongs, // Nuevo tipo añadido
}

class _SpotifyRecentItem {
  final _SpotifyRecentItemType type;
  final SpotubeSimplePlaylistObject? playlist;
  final SpotubeSimpleAlbumObject? album;

  const _SpotifyRecentItem._({
    required this.type,
    this.playlist,
    this.album,
  });

  factory _SpotifyRecentItem.likedSongs() {
    return const _SpotifyRecentItem._(
      type: _SpotifyRecentItemType.likedSongs,
    );
  }

  factory _SpotifyRecentItem.playlist(
    SpotubeSimplePlaylistObject playlist,
  ) {
    return _SpotifyRecentItem._(
      type: _SpotifyRecentItemType.playlist,
      playlist: playlist,
    );
  }

  factory _SpotifyRecentItem.album(
    SpotubeSimpleAlbumObject album,
  ) {
    return _SpotifyRecentItem._(
      type: _SpotifyRecentItemType.album,
      album: album,
    );
  }

  String get title {
    return switch (type) {
      _SpotifyRecentItemType.playlist => playlist!.name,
      _SpotifyRecentItemType.album => album!.name,
      _SpotifyRecentItemType.likedSongs => 'Canciones que te gustan',
    };
  }

  String get imageUrl {
    return switch (type) {
      _SpotifyRecentItemType.playlist =>
        playlist!.images.from200PxTo300PxOrSmallestImage(
          ImagePlaceholder.collection,
        ),
      _SpotifyRecentItemType.album =>
        album!.images.from200PxTo300PxOrSmallestImage(
          ImagePlaceholder.collection,
        ),
      _SpotifyRecentItemType.likedSongs => '', // No requiere URL web
    };
  }
}
