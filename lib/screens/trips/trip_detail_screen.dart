import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/trip.dart';
import '../../services/api_service.dart';

class TripDetailScreen extends StatefulWidget {
  final int tripId;

  const TripDetailScreen({
    super.key,
    this.tripId = 1, // Default to 1 for demonstration
  });

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  Trip? _trip;
  bool _isLoading = true;
  String? _error;
  int _currentImageIndex = 0;
  String _selectedDay = 'Day 1';

  @override
  void initState() {
    super.initState();
    _fetchTripDetail();
  }

  Future<void> _fetchTripDetail() async {
    try {
      final data = await ApiService.getTripDetail(widget.tripId);
      setState(() {
        _trip = Trip.fromJson(data);
        _isLoading = false;
        if (_trip!.schedules.isNotEmpty) {
          _selectedDay = _trip!.schedules.keys.first;
        }
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _trip == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: ${_error ?? "Trip not found"}')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCarousel(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTourHeader(),
                      const SizedBox(height: 20),
                      _buildProviderInfo(),
                      const SizedBox(height: 24),
                      _buildSummaryCard(),
                      const SizedBox(height: 32),
                      _buildScheduleSection(),
                      const SizedBox(height: 32),
                      _buildPriceSection(),
                      const SizedBox(height: 100), // Spacing for bottom button
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildTopButtons(),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return Stack(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            itemCount: _trip!.imageUrls.length,
            onPageChanged: (index) {
              setState(() => _currentImageIndex = index);
            },
            itemBuilder: (context, index) {
              return Image.network(
                _trip!.imageUrls[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _trip!.imageUrls.asMap().entries.map((entry) {
              return Container(
                width: entry.key == _currentImageIndex ? 24 : 8,
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: entry.key == _currentImageIndex
                      ? AppTheme.primaryColor
                      : Colors.white.withOpacity(0.5),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTopButtons() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            Row(
              children: [
                _buildCircularButton(Icons.share_outlined),
                _buildCircularButton(Icons.favorite_border),
                _buildCircularButton(Icons.bookmark_border),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularButton(IconData icon) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildTourHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _trip!.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        Icons.star,
                        size: 16,
                        color: index < _trip!.rating.floor()
                            ? Colors.orange
                            : Colors.grey[300],
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_trip!.reviewsCount} Reviews',
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${_trip!.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            if (_trip!.oldPrice != null)
              Text(
                '\$${_trip!.oldPrice!.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                  decoration: TextDecoration.lineThrough,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildProviderInfo() {
    return Row(
      children: [
        const Text(
          'Provider',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(width: 12),
        Text(
          _trip!.providerName ?? '',
          style: const TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryItem('Itinerary', _trip!.itinerary ?? ''),
          _buildSummaryItem('Duration', _trip!.duration ?? ''),
          _buildSummaryItem('Departure Date', _trip!.departureDate ?? ''),
          _buildSummaryItem('Departure Place', _trip!.departurePlace ?? ''),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection() {
    final days = _trip!.schedules.keys.toList();
    if (days.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.menu_book, color: AppTheme.textPrimaryColor),
            const SizedBox(width: 8),
            const Text(
              'Schedule',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: days.map((day) {
              final isSelected = _selectedDay == day;
              return GestureDetector(
                onTap: () => setState(() => _selectedDay = day),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : Colors.grey[200]!,
                    ),
                  ),
                  child: Text(
                    day,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _trip!.itinerary ?? '',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        ...(_trip!.schedules[_selectedDay] ?? []).map((item) => _buildTimelineItem(item)),
      ],
    );
  }

  Widget _buildTimelineItem(ScheduleItem item) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: AppTheme.primaryColor.withOpacity(0.3),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.time,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.monetization_on_outlined, color: AppTheme.textPrimaryColor),
            const SizedBox(width: 8),
            const Text(
              'Price',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: _trip!.prices.map((p) {
              final isLast = _trip!.prices.indexOf(p) == _trip!.prices.length - 1;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        p.category,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ),
                    Container(width: 1, height: 20, color: Colors.grey[200]),
                    Expanded(
                      flex: 1,
                      child: Text(
                        p.price,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: const Text(
          'BOOK THIS TOUR',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
