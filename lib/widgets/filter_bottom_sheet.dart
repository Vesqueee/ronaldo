import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'custom_button.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int _selectedType = 0; // 0: Finding a Guide, 1: Tours
  final List<String> _languages = [
    'Vietnamese',
    'English',
    'Korean',
    'Spanish',
    'French',
  ];
  final List<String> _selectedLanguages = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.close,
                    color: AppTheme.textSecondaryColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(width: 24), // Balance the title
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedType = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedType == 0
                            ? AppTheme.primaryColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedType == 0
                              ? AppTheme.primaryColor
                              : AppTheme.borderLightColor,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Finding a Guide',
                          style: TextStyle(
                            color: _selectedType == 0
                                ? Colors.white
                                : AppTheme.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedType = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedType == 1
                            ? AppTheme.primaryColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedType == 1
                              ? AppTheme.primaryColor
                              : AppTheme.borderLightColor,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Tours',
                          style: TextStyle(
                            color: _selectedType == 1
                                ? Colors.white
                                : AppTheme.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Date',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                hintText: 'mm/dd/yy',
                hintStyle: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: AppTheme.textSecondaryColor,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.borderLightColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Time',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                hintText: '00:00 AM',
                hintStyle: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.access_time,
                  size: 20,
                  color: AppTheme.textSecondaryColor,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.borderLightColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Guide\'s Language',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: _languages.map((lang) {
                final isSelected = _selectedLanguages.contains(lang);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedLanguages.remove(lang);
                      } else {
                        _selectedLanguages.add(lang);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.borderLightColor,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      lang,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : AppTheme.textPrimaryColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            const Text(
              'Fee',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.textSecondaryColor),
                  ),
                  child: const Icon(
                    Icons.attach_money,
                    size: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Fee',
                      hintStyle: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                      suffixText: '(\$/hour)',
                      suffixStyle: TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontSize: 13,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTheme.borderLightColor,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            CustomButton(
              text: 'APPLY FILTERS',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
