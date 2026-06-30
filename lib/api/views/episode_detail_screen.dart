import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppkd_b6/api/models/episode_models.dart';
import 'package:ppkd_b6/api/models/post_models_rick.dart';
import 'package:ppkd_b6/api/service/dio_client_2.dart';
import 'package:ppkd_b6/api/views/detail_screen.dart';

class EpisodeDetailScreen extends StatefulWidget {
  final Episode episode;
  const EpisodeDetailScreen({super.key, required this.episode});

  @override
  State<EpisodeDetailScreen> createState() => _EpisodeDetailScreenState();
}

class _EpisodeDetailScreenState extends State<EpisodeDetailScreen> {
  late final Future<List<Result>> _charactersFuture;

  @override
  void initState() {
    super.initState();
    _charactersFuture = _fetchCharacters(widget.episode.characters ?? []);
  }

  int? _parseId(String url) {
    final segments = Uri.parse(url).pathSegments;
    return segments.isEmpty ? null : int.tryParse(segments.last);
  }

  Future<List<Result>> _fetchCharacters(List<String> urls) async {
    final ids = urls.map(_parseId).whereType<int>().toList();
    if (ids.isEmpty) return [];

    final dio = createDioClient();
    final response = await dio.get('/api/character/${ids.join(',')}');
    final data = response.data;
    final List<dynamic> raw = data is List ? data : [data];
    return raw
        .map((e) => Result.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6E2D8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF433371), size: 20),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: const Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1C1C15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ep = widget.episode;
    return Scaffold(
      backgroundColor: const Color(0xFFFDF9EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF9EE),
        elevation: 0,
        foregroundColor: const Color(0xFF433371),
        title: Text(
          ep.episode ?? 'Episode',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF433371),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              ep.name ?? '',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1C1C15),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoTile(
                  Icons.calendar_today,
                  'AIR DATE',
                  ep.airDate ?? '-',
                ),
                const SizedBox(width: 12),
                _buildInfoTile(
                  Icons.people,
                  'CHARACTERS',
                  '${ep.characters?.length ?? 0}',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Characters',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1C1C15),
              ),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Result>>(
              future: _charactersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF433371)),
                      ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    'Failed to load characters.',
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFFE74C3C),
                    ),
                  );
                }
                final characters = snapshot.data ?? [];
                if (characters.isEmpty) {
                  return Text(
                    'No characters.',
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF666666),
                    ),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: characters.length,
                  itemBuilder: (context, index) {
                    final c = characters[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(post: c),
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: c.image ?? '',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder: (_, __) => Container(
                                  color: const Color(0xFFF7F3E8),
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  color: const Color(0xFFF7F3E8),
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: Color(0xFF7A7580),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1C1C15),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
