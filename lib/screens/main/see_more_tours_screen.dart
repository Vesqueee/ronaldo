import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_cards.dart';

class SeeMoreToursScreen extends StatelessWidget {
  const SeeMoreToursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Image and Search Bar overlapping
            SizedBox(
              height: 244, // 220 + 24 for half the search bar (height 48)
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 220,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/670301139 1.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                        padding: const EdgeInsets.only(
                          bottom: 40,
                          left: 24,
                          right: 24,
                        ),
                        alignment: Alignment.bottomLeft,
                        child: const Text(
                          'Plenty of amazing tours are waiting for you',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 24,
                    right: 24,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Hi, where do you want to explore?',
                          hintStyle: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppTheme.textSecondaryColor,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body List
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  if (index == 4) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(
                        child: Icon(
                          Icons.more_horiz,
                          color: AppTheme.borderLightColor,
                          size: 40,
                        ),
                      ),
                    );
                  }
                  final tours = [
                    {
                      'title': 'Da Nang - Ba Na  - Hoi An',
                      'price': '\$400.00',
                      'image': 'assets/images/dragon-bridge-03.png',
                    },
                    {
                      'title': 'Melbourne - Sydney',
                      'price': '\$600.00',
                      'image': 'assets/images/sydney.png',
                    },
                    {
                      'title': 'Hanoi - Ha Long Bay',
                      'price': '\$300.00',
                      'image': 'assets/images/halongbay.png',
                    },
                    {
                      'title': 'Phu Quoc Island',
                      'price': '\$500.00',
                      'image': 'assets/images/199641361 1.png',
                    },
                  ];
                  return SharedCards.buildTourItem(
                    tours[index]['title']!,
                    '3 days',
                    tours[index]['price']!,
                    tours[index]['image']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
