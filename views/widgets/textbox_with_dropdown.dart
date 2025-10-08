import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:findatable_restaurant/utils/helpers.dart';
import '/consts/consts.dart';

class DropdownOption {
  final String value;
  final String label;

  const DropdownOption({required this.value, required this.label});

  @override
  String toString() => label;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownOption &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class TextboxWidgetDropdown extends StatefulWidget {
  const TextboxWidgetDropdown({
    super.key,
    this.controller,
    this.lableText,
    this.title,
    this.items,
    this.options,
    this.fieldName,
    this.isRequired = true,
    this.onChange,
    this.onChangeIndex,
    this.enableTranslate = true,
    this.showClearButton = false,
    this.customValidator,
    this.initialValue,
    this.isMultiSelect = false,
    this.initialValues,
    this.onMultiChange,
  }) : assert(
         items != null || options != null,
         'Either items or options must be provided',
       );

  final TextEditingController? controller;
  final String? lableText;
  final String? title;
  final List? items; // For backward compatibility - simple string list
  final List<DropdownOption>? options; // For key-value pairs
  final String? fieldName;
  final bool isRequired;
  final Null Function(dynamic value)? onChange;
  final Null Function(int value)? onChangeIndex;
  final bool enableTranslate;
  final bool showClearButton;
  final String? Function(String?)? customValidator;
  final String? initialValue; // Initial value for the dropdown
  final bool isMultiSelect; // Enable multi-select mode
  final List<String>? initialValues; // Initial values for multi-select
  final Function(List<String> values)?
  onMultiChange; // Callback for multi-select changes

  @override
  State<TextboxWidgetDropdown> createState() => _TextboxWidgetDropdownState();
}

class _TextboxWidgetDropdownState extends State<TextboxWidgetDropdown> {
  List<DropdownOption> get dropdownOptions {
    if (widget.options != null) {
      return widget.options!;
    } else if (widget.items != null) {
      // Convert simple items to DropdownOption for backward compatibility
      return widget.items!
          .map(
            (item) =>
                DropdownOption(value: item.toString(), label: item.toString()),
          )
          .toList();
    }
    return [];
  }

  @override
  void initState() {
    super.initState();

    // Set initial value if provided and controller is not set
    if (widget.initialValue != null &&
        (widget.controller == null || widget.controller!.text.isEmpty)) {
      widget.controller?.text = widget.initialValue!;
    }

    if (widget.controller != null &&
        widget.controller!.text.isNotEmpty &&
        dropdownOptions.isNotEmpty) {
      final selectedOption = dropdownOptions.firstWhere(
        (option) => option.value == widget.controller!.text,
        orElse: () => dropdownOptions.first,
      );

      if (widget.onChange != null) {
        widget.onChange!(selectedOption.value);
      }

      if (widget.onChangeIndex != null) {
        int index = dropdownOptions.indexOf(selectedOption);
        widget.onChangeIndex!(index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = dropdownOptions;
    var selectedItem = (widget.controller == null && widget.lableText == null)
        ? widget.initialValue
        : widget.controller?.text ?? widget.lableText ?? widget.initialValue;

    final fieldName =
        widget.fieldName ??
        (widget.lableText ?? '').toLowerCase().replaceAll(' ', '_');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: lang(widget.title ?? ''),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: AppColors.black,
                ),
              ),
              if (widget.isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(fontSize: 15.sp, color: Colors.red),
                )
              else
                TextSpan(
                  text: ' (optional)',
                  style: TextStyle(fontSize: 15.sp, color: Colors.red),
                ),
            ],
          ),
        ),
        10.spaceY,
        widget.isMultiSelect
            ? _buildMultiSelectField(fieldName, options)
            : _buildSingleSelectField(fieldName, options, selectedItem),
      ],
    );
  }

  Widget _buildSingleSelectField(
    String fieldName,
    List<DropdownOption> options,
    String? selectedItem,
  ) {
    return FormBuilderField<String>(
      name: fieldName,
      initialValue: widget.initialValue,
      validator: FormBuilderValidators.compose([
        if (widget.isRequired)
          FormBuilderValidators.required(
            errorText: lang('This field is required'),
          ),
        if (widget.customValidator != null) widget.customValidator!,
      ]),
      builder: (FormFieldState<String?> field) {
        // Find the selected option based on the current value
        DropdownOption? currentSelectedOption;
        if (selectedItem != null) {
          try {
            currentSelectedOption = options.firstWhere(
              (option) =>
                  option.value == selectedItem || option.label == selectedItem,
            );
          } catch (e) {
            currentSelectedOption = null;
          }
        }

        return DropdownSearch<DropdownOption>(
          dropdownBuilder: (context, selectedOption) {
            return Text(
              selectedOption?.label ?? '',
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
              ),
            );
          },
          showClearButton: widget.showClearButton,
          clearButtonBuilder: (context) {
            return Icon(Icons.clear, color: AppColors.black, size: 14);
          },
          popupItemBuilder: (context, item, isSelected) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border, width: 0.5),
                ),
                color: item == currentSelectedOption
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: item == currentSelectedOption
                            ? FontWeight.w500
                            : FontWeight.w400,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                  if (item == currentSelectedOption)
                    Icon(Icons.check, color: AppColors.primary, size: 18),
                ],
              ),
            );
          },
          dropdownButtonBuilder: (context) =>
              Icon(Icons.expand_more, color: AppColors.primary),
          dropdownSearchDecoration:
              AppStyles.textInputDecoration(
                hintText: widget.lableText ?? '',
                suffix: null,
                prefix: null,
              ).copyWith(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                border: InputBorder.none,
              ),
          searchFieldProps: TextFieldProps(
            style: TextStyle(color: AppColors.black, fontSize: 15.sp),
            decoration: InputDecoration(
              isDense: true,
              hintText: lang('Search'),
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.black.withValues(alpha: 0.6),
                size: 20,
              ),
              hintStyle: TextStyle(
                color: AppColors.black.withValues(alpha: 0.6),
                fontSize: 15.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.border, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.border, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primary, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red, width: 0.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
            ),
          ),
          mode: Mode.MENU,
          showSearchBox: true,
          items: options,
          onChanged: (DropdownOption? selectedOption) {
            if (selectedOption != null) {
              field.didChange(selectedOption.value);
              widget.controller?.text = selectedOption.value;
              if (widget.onChange != null) {
                widget.onChange!(selectedOption.value);
              }

              if (widget.onChangeIndex != null) {
                int index = options.indexOf(selectedOption);
                widget.onChangeIndex!(index);
              }
            }
          },
          selectedItem: currentSelectedOption,
        );
      },
    );
  }

  Widget _buildMultiSelectField(
    String fieldName,
    List<DropdownOption> options,
  ) {
    return FormBuilderField<List<String>>(
      name: fieldName,
      initialValue: widget.initialValues ?? [],
      validator: FormBuilderValidators.compose([
        if (widget.isRequired)
          (List<String>? values) {
            if (values == null || values.isEmpty) {
              return lang('This field is required');
            }
            return null;
          },
      ]),
      builder: (FormFieldState<List<String>?> field) {
        // Find selected options based on current values
        List<DropdownOption> currentSelectedOptions = [];
        if (field.value != null && field.value!.isNotEmpty) {
          currentSelectedOptions = options
              .where((option) => field.value!.contains(option.value))
              .toList();
        }

        return DropdownSearch<DropdownOption>.multiSelection(
          items: options,
          selectedItems: currentSelectedOptions,
          showSearchBox: true,
          showClearButton: widget.showClearButton,
          clearButtonBuilder: (context) {
            return Icon(Icons.clear, color: AppColors.black, size: 14);
          },
          dropdownButtonBuilder: (context) =>
              Icon(Icons.expand_more, color: AppColors.primary),
          popupItemBuilder: (context, item, isSelected) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border, width: 0.5),
                ),
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? Icon(Icons.check, color: Colors.white, size: 14)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.w400,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          searchFieldProps: TextFieldProps(
            style: TextStyle(color: AppColors.black, fontSize: 15.sp),
            decoration: InputDecoration(
              isDense: true,
              hintText: lang('Search'),
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.black.withValues(alpha: 0.6),
                size: 20,
              ),
              hintStyle: TextStyle(
                color: AppColors.black.withValues(alpha: 0.6),
                fontSize: 15.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.border, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.border, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primary, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red, width: 0.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
            ),
          ),
          dropdownBuilder: (context, selectedItems) {
            if (selectedItems.isEmpty) {
              return Text(
                widget.lableText ?? 'Select options',
                style: TextStyle(
                  color: AppColors.black.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400,
                  fontSize: 15.sp,
                ),
              );
            }

            return Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                ...selectedItems.map((item) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.label,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            List<String> newValues = List.from(
                              field.value ?? [],
                            );
                            newValues.remove(item.value);
                            field.didChange(newValues);
                            if (widget.onMultiChange != null) {
                              widget.onMultiChange!(newValues);
                            }
                          },
                          child: Icon(
                            Icons.close,
                            color: AppColors.primary,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                // if (selectedItems.length > 2)
                //   Container(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 8,
                //       vertical: 4,
                //     ),
                //     decoration: BoxDecoration(
                //       color: Colors.grey.shade200,
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: Text(
                //       '+${selectedItems.length - 2} more',
                //       style: TextStyle(
                //         color: Colors.grey.shade600,
                //         fontSize: 12.sp,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ),
              ],
            );
          },
          dropdownSearchDecoration:
              AppStyles.textInputDecoration(
                hintText: widget.lableText ?? '',
                suffix: null,
                prefix: null,
              ).copyWith(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                border: InputBorder.none,
              ),
          onChanged: (List<DropdownOption> selectedOptions) {
            List<String> values = selectedOptions
                .map((option) => option.value)
                .toList();
            field.didChange(values);
            if (widget.onMultiChange != null) {
              widget.onMultiChange!(values);
            }
          },
        );
      },
    );
  }
}
