// Custom dropdown widget for app bar
import 'package:flutter/material.dart';

class SectionDropdown extends StatelessWidget {
  final String selectedSection;
  final Function(String) onSectionChanged;

  const SectionDropdown({
    Key? key,
    required this.selectedSection,
    required this.onSectionChanged,
  }) : super(key: key);

  final List<String> sections = const ['Default', 'Wishlist', 'Shopping', 'Work'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: PopupMenuButton<String>(
        onSelected: onSectionChanged,
        offset: Offset(0, 45), // Fixed offset to open below the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getSectionIcon(selectedSection),
              color: Colors.white,
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              selectedSection,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
        itemBuilder: (BuildContext context) => sections.map((String section) {
          return PopupMenuItem<String>(
            value: section,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                color: selectedSection == section
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _getSectionColor(section).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      _getSectionIcon(section),
                      color: _getSectionColor(section),
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    section,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selectedSection == section
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: selectedSection == section
                          ? Colors.blue[700]
                          : Colors.grey[700],
                    ),
                  ),
                  Spacer(),
                  if (selectedSection == section)
                    Icon(
                      Icons.check,
                      color: Colors.blue[600],
                      size: 18,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getSectionIcon(String section) {
    switch (section) {
      case 'Default':
        return Icons.checklist;
      case 'Wishlist':
        return Icons.favorite_outline;
      case 'Shopping':
        return Icons.shopping_cart_outlined;
      case 'Work':
        return Icons.work_outline;
      default:
        return Icons.checklist;
    }
  }

  Color _getSectionColor(String section) {
    switch (section) {
      case 'Default':
        return Colors.blue;
      case 'Wishlist':
        return Colors.pink;
      case 'Shopping':
        return Colors.orange;
      case 'Work':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
}

// Usage in your AppBar:
/*
AppBar(
  title: Text('Checklist'),
  actions: [
    SectionDropdown(
      selectedSection: selectedSection, // Your current selected section
      onSectionChanged: (String newSection) {
        // Handle section change logic here
        // setState(() {
        //   selectedSection = newSection;
        // });
      },
    ),
    SizedBox(width: 16),
  ],
),
*/