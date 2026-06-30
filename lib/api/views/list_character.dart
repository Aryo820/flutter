import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppkd_b6/api/models/post_models_rick.dart';
import 'package:ppkd_b6/api/service/api_services.dart';
import 'package:ppkd_b6/api/service/dio_client_2.dart';
import 'package:ppkd_b6/api/service/favorites_service.dart';
import 'package:ppkd_b6/api/views/detail_screen.dart';
import 'package:ppkd_b6/api/views/episodes_screen.dart';
import 'package:ppkd_b6/api/views/favorites_screen.dart';
import 'package:ppkd_b6/api/views/locations_screen.dart';

class ListCharacter extends StatefulWidget {
  static const routeName = '/list_character';
  const ListCharacter({super.key});

  @override
  State<ListCharacter> createState() => _ListCharacterState();
}

class _ListCharacterState extends State<ListCharacter> {
  late final ApiService _apiService;
  final FavoritesService _favoritesService = FavoritesService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  List<Result> _allCharacters = [];
  Set<int> _favorites = {};
  String _searchQuery = "";
  String? _statusFilter; // alive | dead | unknown
  String? _genderFilter; // male | female
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _hasError = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final dio = createDioClient();
    _apiService = ApiService(dio);
    _loadFavorites();
    _loadCharacters(refresh: true);

    _searchController.addListener(() {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 400), () {
        final query = _searchController.text.trim();
        if (query == _searchQuery) return;
        _searchQuery = query;
        _loadCharacters(refresh: true);
      });
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _favoritesService.getFavorites();
    setState(() {
      _favorites = favorites;
    });
  }

  Future<void> _loadCharacters({bool refresh = false}) async {
    if (_isLoading) return;
    if (refresh) {
      _currentPage = 1;
      _totalPages = 1;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
      if (refresh) _allCharacters = [];
    });

    try {
      final response = await _apiService.getCharacters(
        page: _currentPage,
        name: _searchQuery.isEmpty ? null : _searchQuery,
        status: _statusFilter,
        gender: _genderFilter,
      );
      setState(() {
        if (refresh) {
          _allCharacters = response.results;
        } else {
          _allCharacters.addAll(response.results);
        }
        _totalPages = response.info.pages;
        _isLoading = false;
      });
    } on DioException catch (e) {
      // API mengembalikan 404 ketika filter tidak menghasilkan apa pun.
      if (e.response?.statusCode == 404) {
        setState(() {
          if (refresh) _allCharacters = [];
          _totalPages = _currentPage;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _currentPage < _totalPages) {
      _currentPage++;
      _loadCharacters();
    }
  }

  void _onStatusSelected(String? value) {
    setState(() => _statusFilter = _statusFilter == value ? null : value);
    _loadCharacters(refresh: true);
  }

  void _onGenderSelected(String? value) {
    setState(() => _genderFilter = _genderFilter == value ? null : value);
    _loadCharacters(refresh: true);
  }

  Future<void> _toggleFavorite(int characterId) async {
    await _favoritesService.toggleFavorite(characterId);
    await _loadFavorites();
  }

  Color _getStatusColor(Status? status) {
    if (status == null) return const Color(0xFF95A5A6); // status-unknown
    switch (status) {
      case Status.ALIVE:
        return const Color.fromARGB(255, 37, 151, 41); // status-alive
      case Status.DEAD:
        return const Color.fromARGB(255, 194, 57, 42); // status-dead
      case Status.UNKNOWN:
        return const Color.fromARGB(255, 124, 134, 134);
    }
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => onTap(),
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : const Color(0xFF433371),
        ),
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF433371),
        side: BorderSide(
          color: const Color(0xFF433371).withValues(alpha: 0.2),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    // Filtering dilakukan di sisi server, jadi list ditampilkan apa adanya.
    final filteredPosts = _allCharacters;

    final screenWidth = MediaQuery.of(context).size.width;
    const int crossAxisCount = 1;

    return RefreshIndicator(
      onRefresh: () async => _loadCharacters(refresh: true),
      backgroundColor: Colors.white,
      color: const Color(0xFF433371),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF433371).withValues(alpha: 0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF433371,
                          ).withValues(alpha: 0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Color(0xFF7A7580)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF1C1C15),
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search multiverse...',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                color: const Color(
                                  0xFF7A7580,
                                ).withValues(alpha: 0.7),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(8)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          label: 'Alive',
                          selected: _statusFilter == 'alive',
                          onTap: () => _onStatusSelected('alive'),
                        ),
                        _buildFilterChip(
                          label: 'Dead',
                          selected: _statusFilter == 'dead',
                          onTap: () => _onStatusSelected('dead'),
                        ),
                        _buildFilterChip(
                          label: 'Unknown',
                          selected: _statusFilter == 'unknown',
                          onTap: () => _onStatusSelected('unknown'),
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: const Color(0x1A433371),
                        ),
                        _buildFilterChip(
                          label: 'Male',
                          selected: _genderFilter == 'male',
                          onTap: () => _onGenderSelected('male'),
                        ),
                        _buildFilterChip(
                          label: 'Female',
                          selected: _genderFilter == 'female',
                          onTap: () => _onGenderSelected('female'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Discover Characters',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: screenWidth < 600 ? 28 : 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF433371),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (filteredPosts.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search_off,
                        size: 64,
                        color: Color(0xFF7A7580),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Characters Found',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1C1C15),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No specimens match your search query in this dimension.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: crossAxisCount == 1 ? 1.15 : 0.82,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final post = filteredPosts[index];
                final statusColor = _getStatusColor(post.status);
                final statusText = post.status?.name ?? "Unknown";

                // Subtitle formatting
                String subtitle = post.species ?? "";
                if (post.type != null && post.type!.isNotEmpty) {
                  subtitle += " • ${post.type}";
                }

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF433371).withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(post: post),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card Image + Absolute Status Badge
                          Expanded(
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: CachedNetworkImage(
                                    imageUrl: post.image ?? "",
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: const Color(0xFFF7F3E8),
                                      child: const Center(
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Color(0xFF433371),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          color: const Color(0xFFF7F3E8),
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            color: Color(0xFF7A7580),
                                          ),
                                        ),
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 8,
                                        sigmaY: 8,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: statusColor.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: statusColor.withValues(
                                              alpha: 0.2,
                                            ),
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
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: statusColor,
                                                    fontSize: 10,
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
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  child: GestureDetector(
                                    onTap: () => _toggleFavorite(post.id!),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        _favorites.contains(post.id)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: _favorites.contains(post.id)
                                            ? Colors.red
                                            : const Color(0xFF7A7580),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Card Info
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.name ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1C1C15),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  subtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    color: const Color(0xFF666666),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Color(0xFF433371),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        post.location?.name ?? "Unknown",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF433371),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }, childCount: filteredPosts.length),
            ),
          if (_isLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF433371)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Scaffold(
        backgroundColor: const Color(0xFFFDF9EE),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Color(0xFF7A7580)),
              const SizedBox(height: 16),
              Text(
                'Failed to load characters',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1C1C15),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _loadCharacters(refresh: true),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_allCharacters.isEmpty && _isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFDF9EE),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF433371)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF9EE),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 64 + MediaQuery.of(context).padding.top,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 24,
                right: 24,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF9EE).withValues(alpha: 0.8),
                border: const Border(
                  bottom: BorderSide(color: Color(0x1A433371), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Rick & Morty Explorer',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF433371),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Episodes',
                    icon: const Icon(Icons.live_tv, color: Color(0xFF433371)),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EpisodesScreen(),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Locations',
                    icon: const Icon(Icons.public, color: Color(0xFF433371)),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LocationsScreen(),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Favorites',
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoritesScreen(),
                        ),
                      );
                      _loadFavorites();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _buildMainContent(),
        ),
      ),
    );
  }
}
