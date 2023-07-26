import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/utills/app_colors.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Text(label),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 30,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.grey5),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.grey5),
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
