import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../search/search_screen.dart';
import 'see_more_tours_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildExploreHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildSectionHeader('Finding a Guide', 'SEE MORE', () {
                  }),
                  _buildFindingGuideList(context),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Guides in Danang', 'SEE MORE', null),
                  _buildHorizontalGuideList(context),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Top Experiences', null, null),
                  _buildTopExperiencesList(context),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Featured Tours', 'SEE MORE', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SeeMoreToursScreen(),
                      ),
                    );
                  }),
                  _buildFeaturedToursList(context),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Travel News', 'SEE MORE', null),
                  _buildTravelNewsList(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreHeader(BuildContext context) {
    return Stack(
      children: [
        // Background Image with Gradient
        Container(
          height: 260,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppTheme.primaryColor,
            image: DecorationImage(
              image: AssetImage(
                'assets/images/2a4028cfda3cda6d2d71eef70a4cdc292c82b02c.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.4), Colors.transparent],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 24.0,
                ),
                child: SizedBox(
                  height: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Explore',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -2,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Da Nang',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Icon(
                                Icons.cloud_outlined,
                                color: Colors.white,
                                size: 44,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '26°C',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 48,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Overlapping Search Bar
        Padding(
          padding: const EdgeInsets.only(top: 234, left: 24, right: 24),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Hi, where do you want to guide?',
                  hintStyle: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppTheme.textSecondaryColor,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    String title,
    String? actionText,
    VoidCallback? onActionTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 4.0),
      child: Row(
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
          if (actionText != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFindingGuideList(BuildContext context) {
    return Column(
      children: [
        _buildFindingGuideItem(
          context,
          'Yoo Jin',
          'Seoul, Korea',
          'Jan 30, 2020',
          'Danang, Vietnam',
          'assets/images/yoojin.png',
        ),
        _buildFindingGuideItem(
          context,
          'Jon Mark',
          'Spain',
          'Jan 30, 2020',
          'Danang, Vietnam',
          'assets/images/jonmark.png',
        ),
        _buildFindingGuideItem(
          context,
          'Lynd Nguyen',
          'US',
          'Jan 30, 2020',
          'Danang, Vietnam',
          'assets/images/lynd nguyen.png',
        ),
        _buildFindingGuideItem(
          context,
          'Patrick',
          'Italy',
          'Jan 30, 2020',
          'Hochiminh, Vietnam',
          'assets/images/patrick.png',
        ),
      ],
    );
  }

  Widget _buildFindingGuideItem(
    BuildContext context,
    String name,
    String from,
    String date,
    String to,
    String imagePath,
  ) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to guide detail screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigate to $name details')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
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
              width: 120,
              height: 120,
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
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'from $from',
                        style: const TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Finding a guide',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: const TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        to,
                        style: const TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
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
    );
  }

  Widget _buildHorizontalGuideList(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildGuideCard(
            context,
            'Tuan Tran',
            'Danang, Vietnam',
            4,
            'assets/images/Tuan Tran 1.png',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildGuideCard(
            context,
            'Emmy',
            'Hanoi, Vietnam',
            5,
            'assets/images/Emmy 1.png',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildGuideCard(
            context,
            'Linh Hana',
            'Danang, Vietnam',
            5,
            'assets/images/Linh Hana.png',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildGuideCard(
            context,
            'Khai Ho',
            'HCM, Vietnam',
            5,
            'assets/images/Khai Ho.png',
          ),
        ),
      ],
    );
  }

  Widget _buildGuideCard(
    BuildContext context,
    String name,
    String location,
    int rating,
    String imagePath,
  ) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to guide detail screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigate to $name details')),
        );
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 12,
                  color: AppTheme.primaryColor,
                ),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopExperiencesList(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 260,
            child: _buildExperienceCard(
              context,
              '2 Hour Bicycle Tour exploring Hoian',
              'Hoian, Vietnam',
              'Tuan Tran',
              'assets/images/hoian 1.png',
              'assets/images/Tuan Tran 1.png',
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 260,
            child: _buildExperienceCard(
              context,
              '1 day at Bana Hill',
              'Bana, Vietnam',
              'Linh Hana',
              'assets/images/hoian 2.png',
              'assets/images/Linh Hana.png',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceCard(
    BuildContext context,
    String title,
    String location,
    String guideName,
    String backgroundImagePath,
    String avatarImagePath,
  ) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to experience detail screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigate to: $title')),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 175,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(backgroundImagePath, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 36,
                        backgroundImage: AssetImage(avatarImagePath),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          guideName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 14,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedToursList(BuildContext context) {
    return Column(
      children: [
        _buildTourItem(
          context,
          'Danang - Ba Na - Hoi An',
          '3 days',
          '\$400.00',
          'assets/images/sunrise.png',
        ),
        _buildTourItem(
          context,
          'Melbourne - Sydney',
          '3 days',
          '\$600.00',
          'assets/images/sydney.png',
        ),
        _buildTourItem(
          context,
          'Hanoi - Ha Long Bay',
          '3 days',
          '\$300.00',
          'assets/images/halongbay.png',
        ),
      ],
    );
  }

  Widget _buildTourItem(
    BuildContext context,
    String title,
    String duration,
    String price,
    String imagePath,
  ) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to tour detail screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigate to tour: $title')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
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
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(
                        Icons.favorite_border,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: AppTheme.textSecondaryColor,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Jan 30, 2020',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppTheme.textSecondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            duration,
                            style: const TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
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
    );
  }

  Widget _buildTravelNewsList() {
    return Column(
      children: [
        _buildNewsItem(
          'New destination in Danang City',
          'Feb 5, 2020',
          'assets/images/cungvanhoathieunhi-danang-vntrip 1.png',
        ),
        _buildNewsItem(
          'Visit Korea For This Holiday',
          'Jan 28, 2020',
          'assets/images/korean.png',
        ),
        _buildNewsItem(
          '\$1 Flight Ticket',
          'Feb 5, 2020',
          'assets/images/afternoon-plane.png',
        ),
      ],
    );
  }

  Widget _buildNewsItem(String title, String date, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            date,
            style: const TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}