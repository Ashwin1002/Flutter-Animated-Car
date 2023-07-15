import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constanins.dart';

class TempBtn extends StatelessWidget {
  const TempBtn({
    super.key,
    required this.svgSrc,
    required this.title,
    this.isActive = false,
    required this.press,
    this.activeColor = primaryColor,
  });

  final String svgSrc, title;
  final bool isActive;
  final VoidCallback press;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          AnimatedContainer(
            height: isActive ? 76 : 50,
            width: isActive ? 76 : 50,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: SvgPicture.asset(
              svgSrc,
              color: isActive ? activeColor : Colors.white38,
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 16.0,
              color: isActive ? activeColor : Colors.white38,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            child: Text(
              title.toUpperCase(),
            ),
          )
        ],
      ),
    );
  }
}
