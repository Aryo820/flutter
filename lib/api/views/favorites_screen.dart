import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppkd_b6/api/models/post_models_rick.dart';
import 'package:ppkd_b6/api/service/dio_client_2.dart';
import 'package:ppkd_b6/api/service/favorites_service.dart';
import 'package:ppkd_b6/api/views/detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  static const routeName = '/favorites';
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();

  List<Result> _characters = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final ids = await _favoritesService.getFavorites();
      if (ids.isEmpty) {
        setState(() {
          _characters = [];
          _isLoading = false;
        });
        return;
      }

      final dio = createDioClient();
      final response = await dio.get('/api/character/${ids.join(',')}');
      final data = response.data;
      // API mengembalikan object tunggal bila hanya 1 id, list bila banyak.
      final List<dynamic> raw = data is List ? data : [data];

      setState(() {
        _characters = raw
            .map((e) => Result.fromJson(e as Map<String, dynamic>))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _removeFavorite(int id) async {
    await _favoritesService.toggleFavorite(id);
    setState(() {
      _characters.removeWhere((c) => c.id == id);
    });
  }

  Color _getStatusColor(Status? status) {
    switch (status) {
      case Status.ALIVE:
        return const Color(0xFF4CAF50);
      case Status.DEAD:
        return const Color(0xFFE74C3C);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF433371)),
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Color(0xFF7A7580)),
            const SizedBox(height: 16),
            Text(
              'Failed to load favorites',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1C1C15),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFavorites,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_characters.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.favorite_border,
                size: 64,
                color: Color(0xFF7A7580),
              ),
              const SizedBox(height: 16),
              Text(
                'No Favorites Yet',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1C1C15),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap the heart on any character to save it here.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: const Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFavorites,
      backgroundColor: Colors.white,
      color: const Color(0xFF433371),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _characters.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final post = _characters[index];
          final statusColor = _getStatusColor(post.status);
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF433371).withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(post: post),
                    ),
                  );
                  _loadFavorites();
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: post.image ?? "",
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            width: 64,
                            height: 64,
                            color: const Color(0xFFF7F3E8),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            width: 64,
                            height: 64,
                            color: const Color(0xFFF7F3E8),
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Color(0xFF7A7580),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.name ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1C1C15),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${post.status?.name ?? "Unknown"} • ${post.species ?? ""}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: const Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () => _removeFavorite(post.id!),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF9EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF9EE),
        elevation: 0,
        foregroundColor: const Color(0xFF433371),
        title: Text(
          'Favorites',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF433371),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(child: _buildBody()),
    );
  }
}
