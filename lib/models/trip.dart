class Trip {
  final int id;
  final String title;
  final String? duration;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviewsCount;
  final String? providerName;
  final String? itinerary;
  final String? departureDate;
  final String? departurePlace;
  final String? location;
  final List<String> imageUrls;
  final Map<String, List<ScheduleItem>> schedules;
  final List<TripPriceTier> prices;

  Trip({
    required this.id,
    required this.title,
    this.duration,
    required this.price,
    this.oldPrice,
    this.rating = 5.0,
    this.reviewsCount = 0,
    this.providerName,
    this.itinerary,
    this.departureDate,
    this.departurePlace,
    this.location,
    required this.imageUrls,
    required this.schedules,
    required this.prices,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    // Parse schedules
    Map<String, List<ScheduleItem>> schedulesMap = {};
    if (json['schedules'] != null) {
      (json['schedules'] as Map<String, dynamic>).forEach((key, value) {
        schedulesMap[key] = (value as List)
            .map((item) => ScheduleItem.fromJson(item))
            .toList();
      });
    }

    // Parse prices
    List<TripPriceTier> pricesList = [];
    if (json['prices'] != null) {
      pricesList = (json['prices'] as List)
          .map((item) => TripPriceTier.fromJson(item))
          .toList();
    }

    // Parse images
    List<String> images = [];
    if (json['image_urls'] != null) {
      images = json['image_urls'].toString().split(',');
    }

    return Trip(
      id: json['id'],
      title: json['title'],
      duration: json['duration'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      oldPrice: json['old_price'] != null
          ? double.tryParse(json['old_price'].toString())
          : null,
      rating: double.tryParse(json['rating'].toString()) ?? 5.0,
      reviewsCount: json['reviews_count'] ?? 0,
      providerName: json['provider_name'],
      itinerary: json['itinerary'],
      departureDate: json['departure_date'],
      departurePlace: json['departure_place'],
      location: json['location'],
      imageUrls: images,
      schedules: schedulesMap,
      prices: pricesList,
    );
  }
}

class ScheduleItem {
  final String time;
  final String description;

  ScheduleItem({required this.time, required this.description});

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      time: json['time'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class TripPriceTier {
  final String category;
  final String price;

  TripPriceTier({required this.category, required this.price});

  factory TripPriceTier.fromJson(Map<String, dynamic> json) {
    return TripPriceTier(
      category: json['category'] ?? '',
      price: json['price'] ?? '',
    );
  }
}
