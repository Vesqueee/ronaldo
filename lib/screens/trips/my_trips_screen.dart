import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/trip_card.dart';
import '../../widgets/shared_cards.dart';
import 'trip_detail_screen.dart';
import '../chat/chat_screen.dart';

void _navigateToTripDetail(
  BuildContext context,
  String action,
  int tripId,
) {
  if (action == 'Detail') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetailScreen(tripId: tripId),
      ),
    );
  } else if (action == 'Chat') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatScreen()),
    );
  }
}

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor:
            Colors.grey[50], // Slightly gray to make white cards pop
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: AppTheme.primaryColor,
                leading: null,
                automaticallyImplyLeading: false, // In bottom nav
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 24, bottom: 64),
                  title: const Text(
                    'My Trips',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/2a4028cfda3cda6d2d71eef70a4cdc292c82b02c.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(color: Colors.lightBlue[100]);
                        },
                      ),
                      Container(color: Colors.black.withOpacity(0.3)),
                      Positioned(
                        top: 56,
                        right: 24,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Container(
                    color: Colors.white,
                    child: const TabBar(
                      isScrollable: true,
                      labelColor: AppTheme.primaryColor,
                      unselectedLabelColor: AppTheme.textSecondaryColor,
                      indicatorColor: AppTheme.primaryColor,
                      indicatorWeight: 3,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      tabs: [
                        Tab(text: 'Current Trips'),
                        Tab(text: 'Next Trips'),
                        Tab(text: 'Past Trips'),
                        Tab(text: 'Wish List'),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [
              _CurrentTripsTab(),
              _NextTripsTab(),
              _PastTripsTab(),
              _WishListTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrentTripsTab extends StatelessWidget {
  const _CurrentTripsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        TripCard(
          title: 'Dragon Bridge Trip',
          date: 'Jan 30, 2020',
          time: '13:00 - 15:00',
          personName: 'Yoo Jin',
          location: 'Da Nang, Vietnam',
          badgeText: 'Mark Finished',
          actions: const ['Detail'],
          imagePath: 'assets/images/dragon-bridge-03.png',
          profileImagePath: 'assets/images/yoojin.png',
          onActionTap: (action) => _navigateToTripDetail(
            context,
            action,
            2,
          ),
        ),
      ],
    );
  }
}

class _NextTripsTab extends StatelessWidget {
  const _NextTripsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        TripCard(
          title: 'Ho Guom Trip',
          date: 'Feb 2, 2020',
          time: '8:00 - 10:00',
          personName: 'Jonathan P',
          location: 'Hanoi, Vietnam',
          actions: const ['Detail', 'Chat', 'Start'],
          imagePath: 'assets/images/hoguom.png',
          profileImagePath: 'assets/images/jonmark.png',
          onActionTap: (action) => _navigateToTripDetail(
            context,
            action,
            3,
          ),
        ),
        TripCard(
          title: 'Ho Chi Minh Mausoleum',
          date: 'Feb 2, 2020',
          time: '8:00 - 10:00',
          personName: 'Stephne',
          location: 'Hanoi, Vietnam',
          badgeText: 'New Request',
          actions: const ['Detail'],
          imagePath: 'assets/images/hochiminh.png',
          profileImagePath: 'assets/images/Emmy 1.png',
          onActionTap: (action) => _navigateToTripDetail(
            context,
            action,
            4,
          ),
        ),
        TripCard(
          title: 'Duc Ba Church',
          date: 'Feb 2, 2020',
          time: '8:00 - 10:00',
          personName: 'Myung Dae',
          location: 'Ho Chi Minh, Vietnam',
          badgeText: 'Bidding',
          actions: const ['Detail', 'Chat'],
          imagePath:
              'assets/images/20161021091303-nha-tho-duc-ba-gody (7) 1.png',
          profileImagePath: 'assets/images/patrick.png',
          onActionTap: (action) => _navigateToTripDetail(
            context,
            action,
            5,
          ),
        ),
      ],
    );
  }
}

class _PastTripsTab extends StatelessWidget {
  const _PastTripsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        TripCard(
          title: 'Quoc Tu Giam Temple',
          date: 'Feb 2, 2020',
          time: '8:00 - 10:00',
          personName: 'Stephne',
          location: 'Hanoi, Vietnam',
          actions: const ['Detail'],
          imagePath: 'assets/images/van-mieu-quoc-tu-giam 1.png',
          profileImagePath: 'assets/images/Emmy 1.png',
          onActionTap: (action) => _navigateToTripDetail(
            context,
            action,
            6,
          ),
        ),
        TripCard(
          title: 'Dinh Doc Lap',
          date: 'Feb 2, 2020',
          time: '8:00 - 10:00',
          personName: 'Myung Dae',
          location: 'Ho Chi Minh, Vietnam',
          actions: const ['Detail'],
          imagePath: 'assets/images/dinh-doc-lap 1.png',
          profileImagePath: 'assets/images/patrick.png',
          onActionTap: (action) => _navigateToTripDetail(
            context,
            action,
            7,
          ),
        ),
      ],
    );
  }
}

class _WishListTab extends StatelessWidget {
  const _WishListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        SharedCards.buildTourItem(
          'Melbourne - Sydney',
          '3 days',
          '\$600.00',
          'assets/images/sydney.png',
        ),
        SharedCards.buildTourItem(
          'Hanoi - Ha Long Bay',
          '3 days',
          '\$300.00',
          'assets/images/halongbay.png',
        ),
      ],
    );
  }
}
