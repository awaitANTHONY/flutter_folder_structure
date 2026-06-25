import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '/consts/consts.dart';

class SwitchWidget extends StatefulWidget {
  const SwitchWidget({
    super.key,
    required this.title,
    this.fieldName,
    this.description,
    this.initialValue = false,
    this.isRequired = false,
    this.onChanged,
    this.enabled = true,
    this.activeColor,
    this.scale = 0.8,
    this.width = 40,
  });

  final String title;
  final String? fieldName;
  final String? description;
  final bool initialValue;
  final bool isRequired;
  final void Function(bool?)? onChanged;
  final bool enabled;
  final Color? activeColor;
  final double scale;
  final double width;

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  String getFieldName(String title) {
    return title.toLowerCase().replaceAll(' ', '_');
  }

  @override
  Widget build(BuildContext context) {
    final fieldName = widget.fieldName ?? getFieldName(widget.title);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: AppColors.black,
                ),
              ),
              if (widget.isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(fontSize: 14.sp, color: Colors.red),
                ),
            ],
          ),
        ),
        10.verticalSpace,
        Row(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: widget.width,
                height: 20.w,
                child: Transform.scale(
                  scale: widget.scale,
                  child: FormBuilderField<bool>(
                    name: fieldName,
                    initialValue: widget.initialValue,
                    enabled: widget.enabled,
                    builder: (FormFieldState<bool> field) {
                      return Switch(
                        value: field.value ?? false,
                        onChanged: widget.enabled
                            ? (bool value) {
                                field.didChange(value);
                                if (widget.onChanged != null) {
                                  widget.onChanged!(value);
                                }
                              }
                            : null,
                        thumbColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.disabled)) {
                            return AppColors.blackLess;
                          }
                          if (states.contains(WidgetState.selected)) {
                            return widget.activeColor ?? AppColors.white;
                          }
                          return AppColors.primary;
                        }),

                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    },
                  ),
                ),
              ),
            ),
            if (widget.description != null) ...[
              10.horizontalSpace,
              Expanded(
                child: Text(
                  widget.description!,
                  style: AppStyles.small.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.blackLess,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
