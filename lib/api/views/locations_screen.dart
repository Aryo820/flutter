import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppkd_b6/api/models/location_models.dart';
import 'package:ppkd_b6/api/service/api_services.dart';
import 'package:ppkd_b6/api/service/dio_client_2.dart';
import 'package:ppkd_b6/api/views/location_detail_screen.dart';

class LocationsScreen extends StatefulWidget {
  static const routeName = '/locations';
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  late final ApiService _apiService;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<LocationFull> _locations = [];
  String _searchQuery = "";
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _hasError = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(createDioClient());
    _load(refresh: true);

    _searchController.addListener(() {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 400), () {
        final query = _searchController.text.trim();
        if (query == _searchQuery) return;
        _searchQuery = query;
        _load(refresh: true);
      });
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load({bool refresh = false}) async {
    if (_isLoading) return;
    if (refresh) {
      _currentPage = 1;
      _totalPages = 1;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
      if (refresh) _locations = [];
    });

    try {
      final response = await _apiService.getLocations(
        page: _currentPage,
        name: _searchQuery.isEmpty ? null : _searchQuery,
      );
      setState(() {
        if (refresh) {
          _locations = response.results;
        } else {
          _locations.addAll(response.results);
        }
        _totalPages = response.info.pages;
        _isLoading = false;
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        setState(() {
          if (refresh) _locations = [];
          _totalPages = _currentPage;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (_) {
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
      _load();
    }
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
          'Locations',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF433371),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF433371).withValues(alpha: 0.1),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Color(0xFF7A7580)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: GoogleFonts.plusJakartaSans(fontSize: 16),
                        decoration: const InputDecoration(
                          hintText: 'Search locations...',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    if (_hasError && _locations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Color(0xFF7A7580)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _load(refresh: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_locations.isEmpty && _isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF433371)),
        ),
      );
    }

    if (_locations.isEmpty) {
      return Center(
        child: Text(
          'No locations found.',
          style: GoogleFonts.plusJakartaSans(color: const Color(0xFF666666)),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _load(refresh: true),
      backgroundColor: Colors.white,
      color: const Color(0xFF433371),
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _locations.length + (_isLoading ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= _locations.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF433371)),
                ),
              ),
            );
          }
          final loc = _locations[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF433371).withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationDetailScreen(location: loc),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFC8A40).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.public,
                          color: Color(0xFFFC8A40),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1C1C15),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${loc.type ?? "Unknown"} • ${loc.dimension ?? "Unknown"}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: const Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Color(0xFF7A7580)),
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
}
