import 'package:flutter/material.dart';

class GenderSelectorButton extends StatelessWidget {
  final String gender;
  final String selectedGender;
  final IconData icon;
  final VoidCallback onTap;

  const GenderSelectorButton({
    super.key,
    required this.gender,
    required this.selectedGender,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Color(0xff99DDCC) : const Color(0xffEDEDED),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child:
                  Icon(icon, color: isSelected ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
