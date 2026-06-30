import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppkd_b6/api/models/episode_models.dart';
import 'package:ppkd_b6/api/models/post_models_rick.dart';
import 'package:ppkd_b6/api/service/dio_client_2.dart';
import 'package:ppkd_b6/api/service/favorites_service.dart';
import 'package:ppkd_b6/api/views/episode_detail_screen.dart';
import 'package:ppkd_b6/api/views/episodes_screen.dart';

class DetailScreen extends StatefulWidget {
  final Result post;
  const DetailScreen({super.key, required this.post});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final Future<List<Episode>> _episodesFuture;
  final FavoritesService _favoritesService = FavoritesService();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _episodesFuture = _fetchEpisodes(widget.post.episode ?? []);
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final isFav = await _favoritesService.isFavorite(widget.post.id!);
    setState(() {
      _isFavorite = isFav;
    });
  }

  Future<void> _toggleFavorite() async {
    await _favoritesService.toggleFavorite(widget.post.id!);
    await _loadFavoriteStatus();
  }

  Color _getStatusColor(Status? status) {
    if (status == null) return const Color(0xFF95A5A6);
    switch (status) {
      case Status.ALIVE:
        return const Color(0xFF4CAF50); // status-alive
      case Status.DEAD:
        return const Color(0xFFE74C3C); // status-dead
      case Status.UNKNOWN:
        return const Color(0xFF95A5A6); // status-unknown
    }
  }

  IconData _getGenderIcon(Gender? gender) {
    if (gender == null) return Icons.help_outline;
    switch (gender) {
      case Gender.MALE:
        return Icons.male;
      case Gender.FEMALE:
        return Icons.female;
      case Gender.GENDERLESS:
        return Icons.transgender;
      case Gender.UNKNOWN:
        return Icons.help_outline;
    }
  }

  int? _parseEpisodeId(String url) {
    try {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;
      if (segments.isNotEmpty) {
        return int.tryParse(segments.last);
      }
    } catch (_) {}
    return null;
  }

  Future<List<Episode>> _fetchEpisodes(List<String> urls) async {
    final ids = urls.map(_parseEpisodeId).whereType<int>().toList();
    if (ids.isEmpty) return [];

    final dio = createDioClient();
    final response = await dio.get('/api/episode/${ids.join(',')}');
    final data = response.data;

    // The API returns a single object when only one id is requested,
    // and a list when multiple ids are requested.
    final List<dynamic> rawEpisodes = data is List ? data : [data];

    return rawEpisodes
        .map((e) => Episode.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Widget _buildInfoRowItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF666666),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF1C1C15),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryIdCard() {
    final statusColor = _getStatusColor(widget.post.status);
    final statusText = widget.post.status?.name ?? "UNKNOWN";

    String subtitleText = widget.post.species ?? "Unknown";
    if (widget.post.type != null && widget.post.type!.isNotEmpty) {
      subtitleText += " (${widget.post.type})";
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE6E2D8), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF433371).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.name ?? "Unknown Specimen",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1C1C15),
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitleText,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        color: const Color(0xFF666666),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
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
                      statusText.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(color: Color(0xFFE6E2D8), thickness: 1),
          ),
          _buildInfoRowItem(
            icon: _getGenderIcon(widget.post.gender),
            iconColor: const Color(0xFF5B4B8A),
            iconBgColor: const Color(0xFF5B4B8A).withValues(alpha: 0.2),
            label: 'GENDER',
            value: widget.post.gender?.name ?? "Unknown",
          ),
          const SizedBox(height: 16),
          _buildInfoRowItem(
            icon: Icons.public,
            iconColor: const Color(0xFFFC8A40),
            iconBgColor: const Color(0xFFFC8A40).withValues(alpha: 0.2),
            label: 'ORIGIN',
            value: widget.post.origin?.name ?? "Unknown",
          ),
          const SizedBox(height: 16),
          _buildInfoRowItem(
            icon: Icons.location_on,
            iconColor: const Color(0xFF005B84),
            iconBgColor: const Color(0xFF005B84).withValues(alpha: 0.2),
            label: 'CURRENT LOCATION',
            value: widget.post.location?.name ?? "Unknown",
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsRow() {
    final int episodeCount = widget.post.episode?.length ?? 0;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 84,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE6E2D8), width: 1),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF433371).withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$episodeCount',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF433371),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'EPISODES',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: const Color(0xFF666666),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 84,
            decoration: BoxDecoration(
              color: const Color(0xFFFC8A40),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFC8A40).withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  final String shareUrl =
                      widget.post.url ??
                      "https://rickandmortyapi.com/api/character/${widget.post.id}";
                  Clipboard.setData(ClipboardData(text: shareUrl));
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: const Color(0xFFFC8A40),
                      content: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Multiverse link copied to clipboard!',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.share, color: Colors.white, size: 24),
                    const SizedBox(height: 4),
                    Text(
                      'SHARE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEpisodeCard(Episode info) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E2D8), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF433371).withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpisodeDetailScreen(episode: info),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5B4B8A).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        info.episode ?? '',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF433371),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      info.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1C1C15),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      info.airDate ?? '',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: const Color(0xFF666666),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Color(0xFF666666),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedEpisodesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Episodes',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1C1C15),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EpisodesScreen(),
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  children: [
                    Text(
                      'VIEW ALL',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF433371),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: Color(0xFF433371),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<Episode>>(
          future: _episodesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 130,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF433371),
                    ),
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return Container(
                height: 130,
                alignment: Alignment.center,
                child: Text(
                  'Failed to load episodes.',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFE74C3C),
                    fontSize: 14,
                  ),
                ),
              );
            }

            final episodes = snapshot.data ?? [];
            if (episodes.isEmpty) {
              return Container(
                height: 130,
                alignment: Alignment.center,
                child: Text(
                  'No episodes recorded.',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF666666),
                    fontSize: 14,
                  ),
                ),
              );
            }

            return SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: episodes.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return _buildEpisodeCard(episodes[index]);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF9EE),
      body: Stack(
        children: [
          // Background Color
          Positioned.fill(child: Container(color: const Color(0xFFFDF9EE))),
          // Hero Banner Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 353,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.post.image ?? "",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: const Color(0xFFF7F3E8),
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF433371),
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: const Color(0xFFF7F3E8),
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: Color(0xFF7A7580),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF433371).withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Scrollable Content
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 313), // 353 image height - 40 overlap
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        _buildPrimaryIdCard(),
                        const SizedBox(height: 16),
                        _buildQuickStatsRow(),
                        const SizedBox(height: 32),
                        _buildFeaturedEpisodesSection(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Floating Top Header Controls
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF433371,
                          ).withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF433371),
                      size: 20,
                    ),
                  ),
                ),
                // Favorite Button
                GestureDetector(
                  onTap: _toggleFavorite,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF433371,
                          ).withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Color(0xFF433371),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
