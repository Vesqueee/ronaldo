import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TripCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String personName;
  final String location;
  final String? badgeText; // e.g. "Mark Finished", "New Request", "Bidding"
  final List<String> actions; // e.g. ["Detail", "Chat", "Start"]
  final String imageUrl;
  final Function(String actionTitle)? onActionTap;
  final String imagePath;
  final String profileImagePath;

  const TripCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.personName,
    required this.location,
    this.badgeText,
    this.actions = const [],
    this.imageUrl =
        'https://images.unsplash.com/photo-1542640244-7e672d6cb461?auto=format&fit=crop&q=80',
    this.onActionTap,
    required this.imagePath,
    required this.profileImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  imagePath,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Image.network(
                        imageUrl,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                ),
              ),
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              if (badgeText != null)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeText == 'New Request'
                          ? Colors.blueGrey.withOpacity(0.8)
                          : badgeText == 'Bidding'
                          ? Colors.orange.withOpacity(0.8)
                          : Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (badgeText == 'Mark Finished')
                          const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        if (badgeText == 'Mark Finished')
                          const SizedBox(width: 4),
                        Text(
                          badgeText!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                bottom: 12,
                left: 16,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Positioned(
                top: 12,
                right: 12,
                child: Icon(Icons.more_horiz, color: Colors.white),
              ),
            ],
          ),
          // Info Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildIconRow(Icons.calendar_today_outlined, date),
                    const SizedBox(height: 6),
                    _buildIconRow(Icons.access_time, time),
                    const SizedBox(height: 6),
                    _buildIconRow(Icons.person_outline, personName),
                    if (actions.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: actions
                            .map(
                              (act) => GestureDetector(
                                onTap: () {
                                  if (onActionTap != null) onActionTap!(act);
                                },
                                child: _buildActionButton(act),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.asset(
                        profileImagePath,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Image.network(
                              'https://i.pravatar.cc/150?img=43',
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
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

  Widget _buildIconRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondaryColor),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String title) {
    IconData iconData = Icons.info_outline;
    if (title == 'Chat') iconData = Icons.chat_bubble_outline;
    if (title == 'Start') iconData = Icons.flag_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.primaryColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, color: AppTheme.primaryColor, size: 16),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
