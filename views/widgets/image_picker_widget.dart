import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '/utils/helpers.dart';
import '/consts/consts.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({
    super.key,
    required this.title,
    this.fieldName,
    this.isRequired = false,
    this.maxImages = 1,
    this.customValidator,
    this.onChanged,
    this.initialValue,
    this.decoration,
    this.availableImageSources = const [
      ImageSourceOption.camera,
      ImageSourceOption.gallery,
    ],
    this.bottomSheetPadding = const EdgeInsets.all(20),
    this.cameraIcon = const Icon(Icons.camera_enhance),
    this.galleryIcon = const Icon(Icons.image),
    this.cameraLabel,
    this.galleryLabel,
    this.preferredCameraDevice = CameraDevice.rear,
    this.maxWidth,
    this.maxHeight,
    this.imageQuality = 80,
  });

  final String title;
  final String? fieldName;
  final bool isRequired;
  final int maxImages;
  final String? Function(List<dynamic>?)? customValidator;
  final void Function(List<dynamic>?)? onChanged;
  final List<dynamic>? initialValue;
  final InputDecoration? decoration;
  final List<ImageSourceOption> availableImageSources;
  final EdgeInsets bottomSheetPadding;
  final Widget cameraIcon;
  final Widget galleryIcon;
  final Widget? cameraLabel;
  final Widget? galleryLabel;
  final CameraDevice preferredCameraDevice;
  final double? maxWidth;
  final double? maxHeight;
  final int imageQuality;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  String getFieldName(String title) {
    return title.toLowerCase().replaceAll(' ', '_');
  }

  @override
  Widget build(BuildContext context) {
    final fieldName = widget.fieldName ?? getFieldName(widget.title);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: lang(widget.title),
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
                  style: TextStyle(fontSize: 15.sp, color: Colors.grey[600]),
                ),
            ],
          ),
        ),
        10.verticalSpace,
        FormBuilderImagePicker(
          placeholderWidget: Center(
            child: SizedBox(
              height: 120.h,
              width: widget.maxImages != 1 ? 120.w : null,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.upload_outlined,
                      color: Colors.grey[400],
                      size: 40.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
          name: fieldName,
          initialValue: widget.initialValue,
          maxImages: widget.maxImages,
          transformImageWidget: (context, displayImage) => Center(
            child: Container(
              width: widget.maxImages != 1 ? 120.w : null,
              height: widget.maxImages != 1 ? 120.h : null,
              margin: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: displayImage,
              ),
            ),
          ),
          decoration:
              widget.decoration ??
              InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
                contentPadding: EdgeInsets.all(16.w),
                filled: true,
                fillColor: Colors.grey.shade50,
                hintText:
                    'Tap to ${widget.maxImages > 1 ? 'add images' : 'add image'}',
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
              ),
          availableImageSources: widget.availableImageSources,
          bottomSheetPadding: widget.bottomSheetPadding,
          cameraIcon: widget.cameraIcon,
          galleryIcon: widget.galleryIcon,
          cameraLabel: widget.cameraLabel ?? Text(lang('Camera')),
          galleryLabel: widget.galleryLabel ?? Text(lang('Gallery')),
          preferredCameraDevice: widget.preferredCameraDevice,
          maxWidth: widget.maxWidth,
          maxHeight: widget.maxHeight,
          imageQuality: widget.imageQuality,
          validator: FormBuilderValidators.compose([
            if (widget.isRequired)
              FormBuilderValidators.required(
                errorText:
                    'Please select ${widget.maxImages > 1 ? 'at least one image' : 'an image'}',
              ),
            if (widget.customValidator != null) widget.customValidator!,
          ]),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
