import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SharedCards {
  static Widget buildFindingGuideItem(String name, String from, String date, String to, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(width: 4),
                    Text('from $from', style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Finding a Guide', style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.grid_view, size: 14, color: AppTheme.primaryColor),
                    const SizedBox(width: 8),
                    Text(date, style: const TextStyle(color: AppTheme.textPrimaryColor, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.primaryColor),
                    const SizedBox(width: 8),
                    Text(to, style: const TextStyle(color: AppTheme.textPrimaryColor, fontSize: 12)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  static Widget buildTourItem(String title, String duration, String price, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: const Icon(Icons.bookmark_outline, color: Colors.white, size: 24),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Row(
                  children: List.generate(5, (index) => Icon(
                    Icons.star,
                    color: index < 5 ? Colors.orange : Colors.grey[300],
                    size: 16,
                  ))..add(const SizedBox(width: 8))..add(
                    const Text('1247 likes', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const Icon(Icons.favorite_border, color: AppTheme.primaryColor, size: 22),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.calendar_today_outlined, size: 14, color: AppTheme.textSecondaryColor),
                            SizedBox(width: 8),
                            Text('Jan 30, 2020', style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14, color: AppTheme.textSecondaryColor),
                            const SizedBox(width: 8),
                            Text(duration, style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
