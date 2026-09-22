import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '/utils/helpers.dart';
import '/consts/consts.dart';

class TextboxWidgetDropdown extends StatefulWidget {
  const TextboxWidgetDropdown({
    super.key,
    this.controller,
    this.labelText,
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
    this.isReadOnly = false,
    this.popupMaxHeight,
    this.showSearchInPopup = true,
  }) : assert(
         items != null || options != null,
         'Either items or options must be provided',
       );

  final TextEditingController? controller;
  final String? labelText;
  final String? title;
  final List? items; // For backward compatibility - simple string list
  final List<DropdownOption>? options; // For key-value pairs
  final String? fieldName;
  final bool isRequired;
  final void Function(dynamic value)? onChange;
  final void Function(int value)? onChangeIndex;
  final bool enableTranslate;
  final bool showClearButton;
  final String? Function(String?)? customValidator;
  final String? initialValue; // Initial value for the dropdown
  final bool isMultiSelect; // Enable multi-select mode
  final List<String>? initialValues; // Initial values for multi-select
  final Function(List<String> values)?
  onMultiChange; // Callback for multi-select changes
  final bool isReadOnly; // Disable interaction when true
  final double? popupMaxHeight;
  final bool showSearchInPopup;

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

    if (widget.initialValue != null &&
        (widget.controller == null || widget.controller!.text.isEmpty)) {
      widget.controller?.text = widget.initialValue!;
    }

    widget.controller?.addListener(_onControllerChanged);

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

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(TextboxWidgetDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final options = dropdownOptions;
    var selectedItem = (widget.controller == null && widget.labelText == null)
        ? widget.initialValue
        : widget.controller?.text ?? widget.labelText ?? widget.initialValue;

    final fieldName =
        widget.fieldName ??
        (widget.labelText ?? '').toLowerCase().replaceAll(' ', '_');

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
                ),
              // else
              //   TextSpan(
              //     text: ' (optional)',
              //     style: TextStyle(fontSize: 15.sp, color: Colors.red),
              //   ),
            ],
          ),
        ),
        10.verticalSpace,
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
          items: (filter, _) => options,
          selectedItem: currentSelectedOption,
          compareFn: (a, b) => a == b,
          enabled: !widget.isReadOnly,
          dropdownBuilder: (context, selectedOption) {
            final hasValue = selectedOption != null;
            return Text(
              hasValue ? selectedOption.label : (widget.labelText ?? ''),
              style: TextStyle(
                color: hasValue ? AppColors.black : Colors.grey[400],
                fontWeight: hasValue ? FontWeight.w500 : FontWeight.w400,
                fontSize: 15.sp,
              ),
            );
          },
          decoratorProps: DropDownDecoratorProps(
            decoration:
                AppStyles.textInputDecoration(
                  hintText: widget.labelText ?? '',
                  suffix: null,
                  prefix: null,
                ).copyWith(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  border: InputBorder.none,
                  filled: widget.isReadOnly,
                  fillColor: widget.isReadOnly ? Colors.grey.shade100 : null,
                ),
          ),
          suffixProps: DropdownSuffixProps(
            clearButtonProps: ClearButtonProps(
              isVisible: widget.showClearButton,
              icon: Icon(Icons.clear, color: AppColors.black, size: 14),
            ),
            dropdownButtonProps: DropdownButtonProps(
              iconClosed: Icon(Icons.expand_more, color: AppColors.primary),
            ),
          ),
          popupProps: PopupProps.menu(
            constraints: widget.popupMaxHeight != null
                ? BoxConstraints(maxHeight: widget.popupMaxHeight!)
                : const BoxConstraints(maxHeight: 300),
            showSearchBox: widget.showSearchInPopup,
            searchFieldProps: TextFieldProps(
              style: TextStyle(color: AppColors.black, fontSize: 15.sp),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search',
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
            itemBuilder: (context, item, isDisabled, isSelected) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.border, width: 0.5),
                  ),
                  color: item == currentSelectedOption
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.white,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
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
          ),
          onSelected: (DropdownOption? selectedOption) {
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
        List<DropdownOption> currentSelectedOptions = [];
        if (field.value != null && field.value!.isNotEmpty) {
          currentSelectedOptions = options
              .where((option) => field.value!.contains(option.value))
              .toList();
        }

        return DropdownSearch<DropdownOption>.multiSelection(
          items: (filter, _) => options,
          selectedItems: currentSelectedOptions,
          compareFn: (a, b) => a == b,
          enabled: !widget.isReadOnly,
          dropdownBuilder: (context, selectedItems) {
            if (selectedItems.isEmpty) {
              return Text(
                widget.labelText ?? 'Select options',
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
              ],
            );
          },
          decoratorProps: DropDownDecoratorProps(
            decoration:
                AppStyles.textInputDecoration(
                  hintText: widget.labelText ?? '',
                  suffix: null,
                  prefix: null,
                ).copyWith(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  border: InputBorder.none,
                  filled: widget.isReadOnly,
                  fillColor: widget.isReadOnly ? Colors.grey.shade100 : null,
                ),
          ),
          suffixProps: DropdownSuffixProps(
            clearButtonProps: ClearButtonProps(
              isVisible: widget.showClearButton,
              icon: Icon(Icons.clear, color: AppColors.black, size: 14),
            ),
            dropdownButtonProps: DropdownButtonProps(
              iconClosed: Icon(Icons.expand_more, color: AppColors.primary),
            ),
          ),
          popupProps: MultiSelectionPopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              style: TextStyle(color: AppColors.black, fontSize: 15.sp),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search',
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
            itemBuilder: (context, item, isDisabled, isSelected) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.border, width: 0.5),
                  ),
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.white,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
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
          ),
          onSelected: (List<DropdownOption> selectedOptions) {
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
