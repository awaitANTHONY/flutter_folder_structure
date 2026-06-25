import '/consts/consts.dart';
import 'package:flutter/material.dart';

class ShapePickerWidget extends StatelessWidget {
  final String title;
  final String selectedShape;
  final Function(String) onShapeSelected;
  final bool isRequired;

  const ShapePickerWidget({
    super.key,
    required this.title,
    required this.selectedShape,
    required this.onShapeSelected,
    this.isRequired = false,
  });

  static final List<ShapeOption> shapeOptions = [
    ShapeOption(value: 'circle', label: 'Circle', icon: Icons.circle),
    ShapeOption(value: 'square', label: 'Square', icon: Icons.crop_square),
    ShapeOption(value: 'rounded', label: 'Rounded', icon: Icons.rounded_corner),
    ShapeOption(value: 'star', label: 'Star', icon: Icons.star),
    ShapeOption(value: 'heart', label: 'Heart', icon: Icons.favorite),
    ShapeOption(value: 'hexagon', label: 'Hexagon', icon: Icons.hexagon),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
          ],
        ),
        8.verticalSpace,
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: shapeOptions.map((shape) {
            final isSelected = selectedShape == shape.value;
            return InkWell(
              onTap: () => onShapeSelected(shape.value),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: 100.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      shape.icon,
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade600,
                      size: 32.sp,
                    ),
                    6.verticalSpace,
                    Text(
                      shape.label,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class ShapeOption {
  final String value;
  final String label;
  final IconData icon;

  ShapeOption({required this.value, required this.label, required this.icon});
}
