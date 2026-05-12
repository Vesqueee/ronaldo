import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class PhotoPickerScreen extends StatefulWidget {
  const PhotoPickerScreen({super.key});

  @override
  State<PhotoPickerScreen> createState() => _PhotoPickerScreenState();
}

class _PhotoPickerScreenState extends State<PhotoPickerScreen> {
  final List<String> _sampleImages = [
    'https://images.unsplash.com/photo-1528127269322-539801943592?w=400', // Pagoda
    'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400', // Forest
    'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=400', // Lake
    'https://images.unsplash.com/photo-1555412654-72a95a495858?w=400', // Hoi An
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400', // Food
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400', // Woman
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400', // Beach
    'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=400', // Mountains
  ];

  String? _selectedImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.textPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Photos',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              if (_selectedImageUrl != null) {
                Navigator.pop(context, _selectedImageUrl);
              }
            },
            child: Text(
              'DONE',
              style: TextStyle(
                color: _selectedImageUrl != null
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppTheme.borderLightColor, height: 1.0),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(2),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: _sampleImages.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildTakePhotoTile();
          }
          final imageUrl = _sampleImages[index - 1];
          final isSelected = _selectedImageUrl == imageUrl;

          return _buildPhotoTile(imageUrl, isSelected);
        },
      ),
    );
  }

  Widget _buildTakePhotoTile() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.camera_alt, color: AppTheme.primaryColor, size: 32),
          SizedBox(height: 8),
          Text(
            'Take Photo',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoTile(String imageUrl, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedImageUrl = imageUrl;
        });
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppTheme.primaryColor
                    : Colors.white.withOpacity(0.5),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                isSelected ? Icons.check : null,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
          if (isSelected)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.primaryColor, width: 3),
              ),
            ),
        ],
      ),
    );
  }
}
