import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_cards.dart';
import '../../services/api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearched = false;
  bool _loading = false;
  List<dynamic> _guides = [];
  List<dynamic> _trips = [];

  @override
  void initState() {
    super.initState();
    _searchController.text = 'Danang, Vietnam';
    _hasSearched = true;
    _performSearch('Danang, Vietnam');
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _hasSearched = true;
      _loading = true;
    });
    FocusScope.of(context).unfocus();

    try {
      final guidesResult = await ApiService.searchGuides(location: query);
      final tripsResult = await ApiService.searchTrips(location: query);

      if (mounted) {
        setState(() {
          _guides = guidesResult['data'] ?? [];
          _trips = tripsResult['data'] ?? [];
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Tìm kiếm lỗi: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.textPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderLightColor),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: _performSearch,
                            textInputAction: TextInputAction.search,
                            decoration: const InputDecoration(
                              hintText: 'Where you want to guide',
                              hintStyle: TextStyle(
                                color: AppTheme.textSecondaryColor,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              isDense: true,
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.cancel,
                              color: AppTheme.textSecondaryColor,
                              size: 18,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _hasSearched = false;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _hasSearched
                ? (_loading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildSearchResults())
                : _buildPopularDestinations(),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularDestinations() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular destinations',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildLocationTag('Danang, Vietnam'),
              _buildLocationTag('Ho Chi Minh, Vietnam'),
              _buildLocationTag('Venice, Italy'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTag(String title) {
    return GestureDetector(
      onTap: () {
        _searchController.text = title;
        _performSearch(title);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.borderLightColor),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimaryColor,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_guides.isNotEmpty) ...[
              _buildSectionHeader(
                'Finding a Guide (${_guides.length})',
                'SEE MORE',
              ),
              const SizedBox(height: 12),
              ..._guides.map(
                (guide) => GestureDetector(
                  onTap: () {
                    // TODO: Navigate to guide detail screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Navigate to guide: ${guide['first_name']}'),
                      ),
                    );
                  },
                  child: SharedCards.buildFindingGuideItem(
                    guide['first_name'] ?? 'Guide',
                    guide['last_name'] ?? '',
                    'Available',
                    _searchController.text,
                    'assets/images/yoojin.png',
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
            if (_trips.isNotEmpty) ...[
              _buildSectionHeader('Tours (${_trips.length})', 'SEE MORE'),
              const SizedBox(height: 12),
              ..._trips.map(
                (trip) => GestureDetector(
                  onTap: () {
                    // TODO: Navigate to tour detail screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Navigate to tour: ${trip['title']}'),
                      ),
                    );
                  },
                  child: SharedCards.buildTourItem(
                    trip['title'] ?? 'Tour',
                    trip['duration'] ?? '',
                    '\$${trip['price'] ?? 0}',
                    trip['image_url'] ?? 'assets/images/sunrise.png',
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
            if (_guides.isEmpty && _trips.isEmpty)
              Center(
                child: Text(
                  'Không tìm thấy kết quả cho "${_searchController.text}"',
                  style: const TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        Text(
          actionText,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}