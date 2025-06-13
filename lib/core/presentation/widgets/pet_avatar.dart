import 'package:flutter/material.dart';

class PetAvatar extends StatelessWidget {
  final String name;
  final String imageUrl;
  final bool isSelected;

  const PetAvatar({
    super.key,
    required this.name,
    required this.imageUrl,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if (imageUrl.startsWith('http')) {
      imageProvider = NetworkImage(imageUrl);
    } else {
      imageProvider = AssetImage(imageUrl);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Color(0xff99DDCC), width: 2)
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Color(0xff000000).withOpacity(0.25),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundImage: imageProvider,
              backgroundColor: const Color(0xffE1ECE9),
            ),
          ),
          SizedBox(height: 6),
          Text(
            name,
            style: TextStyle(
              color: const Color(0xFF333333),
              fontSize: 10,
              fontFamily: 'poppins1',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.60,
            ),
          ),
        ],
      ),
    );
  }
}
