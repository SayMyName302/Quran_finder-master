import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/settings/pages/app_colors/app_colors_provider.dart';

class CircleButton extends StatelessWidget {
  final double height;
  final double width;
  final Widget icon;

  const CircleButton({
    Key? key,
    required this.height,
    required this.width,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Consumer<AppColorsProvider>(
        builder: (context, value, child) {
          return CircleAvatar(
            backgroundColor: value.mainBrandingColor,
            child: icon,
          );
        },
      ),
    );
  }
}
