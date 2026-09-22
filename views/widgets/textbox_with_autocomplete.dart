import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '/utils/helpers.dart';
import '/consts/consts.dart';

class TextboxWidgetAutocomplete<T> extends StatefulWidget {
  const TextboxWidgetAutocomplete({
    super.key,
    this.controller,
    this.initialValue,
    this.title,
    required this.suggestionsCallback,
    required this.itemBuilder,
    required this.onSelected,
    this.fieldName,
    this.isRequired = true,
    this.hintText = '',
    this.customValidator,
    this.minCharsForSuggestions = 1,
    this.suggestionsBoxMaxHeight = 200.0,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.hideOnEmpty = false,
    this.hideOnLoading = false,
    this.hideOnError = false,
    this.animationDuration = const Duration(milliseconds: 500),
    this.debounceDelay = const Duration(milliseconds: 300),
    this.displayStringForOption,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
  }) : assert(
         title != null || fieldName != null || controller != null,
         'When `title` is null, either `fieldName` or `controller` must be provided.',
       );

  final TextEditingController? controller;
  final String? initialValue;
  final String? title;
  final String? fieldName;
  final bool isRequired;
  final String hintText;
  final String? Function(String?)? customValidator;

  // TypeAhead specific properties
  final Future<List<T>> Function(String) suggestionsCallback;
  final Widget Function(BuildContext, T) itemBuilder;
  final void Function(T) onSelected;
  final int minCharsForSuggestions;
  final double suggestionsBoxMaxHeight;
  final Widget Function(BuildContext)? loadingBuilder;
  final Widget Function(BuildContext, Object?)? errorBuilder;
  final Widget Function(BuildContext)? emptyBuilder;
  final bool hideOnEmpty;
  final bool hideOnLoading;
  final bool hideOnError;
  final Duration animationDuration;
  final Duration debounceDelay;
  final String Function(T)? displayStringForOption;
  final void Function(String?)? onChanged;
  final bool enabled;
  final bool readOnly;

  @override
  State<TextboxWidgetAutocomplete<T>> createState() =>
      _TextboxWidgetAutocompleteState<T>();
}

class _TextboxWidgetAutocompleteState<T>
    extends State<TextboxWidgetAutocomplete<T>> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  String getFieldName(String title) {
    return title.toLowerCase().replaceAll(' ', '_');
  }

  @override
  Widget build(BuildContext context) {
    final fieldName =
        widget.fieldName ??
        (widget.title != null
            ? getFieldName(widget.title!)
            : 'autocomplete_field');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.title!,
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
        ],
        FormBuilderField<String>(
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TypeAheadField<T>(
                  controller: _controller,
                  focusNode: _focusNode,
                  builder: (context, controller, focusNode) {
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      enabled: widget.enabled,
                      readOnly: widget.readOnly,
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        height: 1,
                      ),
                      decoration: AppStyles.textInputDecoration(
                        hintText: widget.hintText,
                        isEnabled: widget.enabled,
                        errorText: field.errorText,
                      ),
                      onChanged: (value) {
                        field.didChange(value);
                        widget.onChanged?.call(value);
                      },
                    );
                  },
                  suggestionsCallback: widget.suggestionsCallback,
                  itemBuilder: widget.itemBuilder,
                  onSelected: (T selection) {
                    String displayText =
                        widget.displayStringForOption?.call(selection) ??
                        selection.toString();
                    _controller.text = displayText;
                    field.didChange(displayText);
                    widget.onSelected(selection);
                  },
                  constraints: BoxConstraints(
                    maxHeight: widget.suggestionsBoxMaxHeight,
                  ),
                  decorationBuilder: (context, child) {
                    return Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8.r),
                      child: child,
                    );
                  },
                  offset: Offset(0, 4),
                  animationDuration: widget.animationDuration,
                  hideOnEmpty: widget.hideOnEmpty,
                  hideOnLoading: widget.hideOnLoading,
                  hideOnError: widget.hideOnError,
                  errorBuilder:
                      widget.errorBuilder ??
                      (context, error) {
                        return Container(
                          padding: EdgeInsets.all(12.w),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 16.sp,
                              ),
                              8.horizontalSpace,
                              Expanded(
                                child: Text(
                                  lang('Error loading suggestions'),
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                  loadingBuilder:
                      widget.loadingBuilder ??
                      (context) {
                        return Container(
                          padding: EdgeInsets.all(12.w),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 16.w,
                                height: 16.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              ),
                              8.horizontalSpace,
                              Text(
                                lang('Loading...'),
                                style: TextStyle(
                                  color: AppColors.blackLess,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                  emptyBuilder:
                      widget.emptyBuilder ??
                      (context) {
                        return Container(
                          padding: EdgeInsets.all(12.w),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search_off,
                                color: AppColors.blackLess,
                                size: 16.sp,
                              ),
                              8.horizontalSpace,
                              Text(
                                'No results found',
                                style: TextStyle(
                                  color: AppColors.blackLess,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                ),
                if (field.hasError && field.errorText != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      field.errorText!,
                      style: TextStyle(color: Colors.red, fontSize: 12.sp),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// Helper classes for common use cases

/// Model class for simple string-based autocomplete options
class AutocompleteOption {
  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final Map<String, dynamic>? data;

  const AutocompleteOption({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    this.data,
  });

  factory AutocompleteOption.fromJson(Map<String, dynamic> json) {
    return AutocompleteOption(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? json['name']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      description: json['description']?.toString(),
      data: json,
    );
  }

  @override
  String toString() => title;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AutocompleteOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Pre-built widget for simple API autocomplete
class SimpleAutocompleteWidget extends StatelessWidget {
  const SimpleAutocompleteWidget({
    super.key,
    this.controller,
    this.initialValue,
    this.title,
    required this.apiCall,
    this.fieldName,
    this.isRequired = true,
    this.hintText = '',
    this.customValidator,
    this.onSelected,
    this.displayKey = 'title',
    this.searchKey = 'search',
    this.minCharsForSuggestions = 1,
    this.enabled = true,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? title;
  final String? fieldName;
  final bool isRequired;
  final String hintText;
  final String? Function(String?)? customValidator;
  final Future<List<Map<String, dynamic>>> Function(String query) apiCall;
  final void Function(AutocompleteOption)? onSelected;
  final String displayKey;
  final String searchKey;
  final int minCharsForSuggestions;
  final bool enabled;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextboxWidgetAutocomplete<AutocompleteOption>(
      controller: controller,
      initialValue: initialValue,
      title: title,
      fieldName: fieldName,
      isRequired: isRequired,
      hintText: hintText,
      customValidator: customValidator,
      enabled: enabled,
      readOnly: readOnly,
      minCharsForSuggestions: minCharsForSuggestions,
      suggestionsCallback: (query) async {
        if (query.length < minCharsForSuggestions) {
          return [];
        }
        try {
          final results = await apiCall(query);
          return results
              .map((json) => AutocompleteOption.fromJson(json))
              .toList();
        } catch (e) {
          return [];
        }
      },
      itemBuilder: (context, option) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.border, width: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                option.title,
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
              if (option.subtitle != null) ...[
                4.verticalSpace,
                Text(
                  option.subtitle!,
                  style: TextStyle(color: AppColors.blackLess, fontSize: 12.sp),
                ),
              ],
            ],
          ),
        );
      },
      onSelected: (option) {
        onSelected?.call(option);
      },
      displayStringForOption: (option) => option.title,
    );
  }
}
