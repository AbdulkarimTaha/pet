import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String? icon;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
          BoxShadow(
            color: const Color(0xff99DDCC).withOpacity(1),
            offset: const Offset(0, 0),
            blurRadius: 20,
          ),
        ],
        borderRadius: BorderRadius.circular(size.width * 0.1),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff99DDCC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.width * 0.1),
          ),
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.02,
            horizontal: size.width * 0.08,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              SvgPicture.asset(
                icon!,
                width: size.width * 0.05,
                height: size.width * 0.05,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: size.width * 0.02),
            ],
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width * 0.04,
                fontFamily: 'poppins1',
                fontWeight: FontWeight.w400,
                letterSpacing: size.width * 0.005,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
