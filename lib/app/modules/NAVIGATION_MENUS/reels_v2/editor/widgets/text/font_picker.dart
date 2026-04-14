import 'package:flutter/material.dart';

/// Font picker with 15+ font options.
/// Displays each font name rendered in its own typeface for preview.
class FontPicker extends StatelessWidget {
  final String selectedFont;
  final ValueChanged<String> onFontSelected;

  const FontPicker({
    super.key,
    required this.selectedFont,
    required this.onFontSelected,
  });

  static const List<_FontItem> fonts = [
    _FontItem('Roboto', 'Roboto'),
    _FontItem('Open Sans', 'Open Sans'),
    _FontItem('Lato', 'Lato'),
    _FontItem('Montserrat', 'Montserrat'),
    _FontItem('Oswald', 'Oswald'),
    _FontItem('Poppins', 'Poppins'),
    _FontItem('Raleway', 'Raleway'),
    _FontItem('Playfair Display', 'Playfair Display'),
    _FontItem('Merriweather', 'Merriweather'),
    _FontItem('Lobster', 'Lobster'),
    _FontItem('Pacifico', 'Pacifico'),
    _FontItem('Dancing Script', 'Dancing Script'),
    _FontItem('Satisfy', 'Satisfy'),
    _FontItem('Permanent Marker', 'Permanent Marker'),
    _FontItem('Bebas Neue', 'Bebas Neue'),
    _FontItem('Anton', 'Anton'),
    _FontItem('Abril Fatface', 'Abril Fatface'),
    _FontItem('Comfortaa', 'Comfortaa'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text(
            'Fonts',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: fonts.length,
            itemBuilder: (context, index) {
              final font = fonts[index];
              final isSelected = selectedFont == font.family;

              return InkWell(
                onTap: () => onFontSelected(font.family),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blueAccent.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          font.displayName,
                          style: TextStyle(
                            fontFamily: font.family,
                            fontSize: 18,
                            color: isSelected ? Colors.blueAccent : Colors.white,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.blueAccent,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FontItem {
  final String family;
  final String displayName;
  const _FontItem(this.family, this.displayName);
}
