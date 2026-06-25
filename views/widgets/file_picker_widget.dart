import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '/utils/helpers.dart';
import '/consts/consts.dart';

class FilePickerWidget extends StatefulWidget {
  const FilePickerWidget({
    super.key,
    required this.title,
    this.fieldName,
    this.isRequired = false,
    this.allowedExtensions,
    this.type = FileType.any,
    this.allowMultiple = false,
    this.customValidator,
    this.onFileSelected,
    this.initialValue,
    this.hintText,
    this.decoration,
  });

  final String title;
  final String? fieldName;
  final bool isRequired;
  final List<String>? allowedExtensions;
  final FileType type;
  final bool allowMultiple;
  final String? Function(List<PlatformFile>?)? customValidator;
  final void Function(List<PlatformFile>?)? onFileSelected;
  final List<PlatformFile>? initialValue;
  final String? hintText;
  final InputDecoration? decoration;

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  List<PlatformFile> _selectedFiles = [];
  String? _errorText;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _selectedFiles = List.from(widget.initialValue!);
    }
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: widget.allowedExtensions != null ? FileType.custom : widget.type,
        allowedExtensions: widget.allowedExtensions,
        allowMultiple: widget.allowMultiple,
      );

      if (result != null) {
        setState(() {
          if (widget.allowMultiple) {
            _selectedFiles.addAll(result.files);
          } else {
            _selectedFiles = result.files;
          }
          _errorText = null;
        });
        widget.onFileSelected?.call(_selectedFiles);
      }
    } catch (e) {
      showToast('Error picking file: $e');
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
    widget.onFileSelected?.call(_selectedFiles.isEmpty ? null : _selectedFiles);
  }

  String _getFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  IconData _getFileIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'mp3':
      case 'wav':
      case 'aac':
      case 'm4a':
        return Icons.audio_file;
      case 'mp4':
      case 'mov':
      case 'avi':
        return Icons.video_file;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }

  InputDecoration get _defaultDecoration => InputDecoration(
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
        widget.hintText ??
        'Tap to ${widget.allowMultiple ? 'add files' : 'add file'}',
    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
  );

  @override
  Widget build(BuildContext context) {
    final decoration = widget.decoration ?? _defaultDecoration;

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
        // Placeholder when no files selected
        if (_selectedFiles.isEmpty)
          GestureDetector(
            onTap: _pickFiles,
            child: InputDecorator(
              decoration: _errorText != null
                  ? decoration.copyWith(
                      errorText: _errorText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    )
                  : decoration,
              child: Center(
                child: SizedBox(
                  height: 120.h,
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
            ),
          )
        else
          // Selected files display
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _errorText != null ? Colors.red : Colors.grey.shade300,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.grey.shade50,
            ),
            child: Column(
              children: [
                // Files list
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _selectedFiles.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade200),
                  itemBuilder: (context, index) {
                    final file = _selectedFiles[index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              _getFileIcon(file.extension),
                              color: AppColors.primary,
                              size: 24.sp,
                            ),
                          ),
                          12.horizontalSpace,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  file.name,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                4.verticalSpace,
                                Text(
                                  _getFileSize(file.size),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _removeFile(index),
                            icon: Icon(
                              Icons.close,
                              color: Colors.red[400],
                              size: 20.sp,
                            ),
                            constraints: BoxConstraints(),
                            padding: EdgeInsets.all(4.w),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // Add more button for multiple files
                if (widget.allowMultiple)
                  InkWell(
                    onTap: _pickFiles,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                          8.horizontalSpace,
                          Text(
                            lang('Add more files'),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

        // Error text
        if (_errorText != null) ...[
          8.verticalSpace,
          Text(
            _errorText!,
            style: TextStyle(fontSize: 12.sp, color: Colors.red),
          ),
        ],
      ],
    );
  }

  /// Validate the selected files
  String? validate() {
    if (widget.isRequired && _selectedFiles.isEmpty) {
      setState(() {
        _errorText = lang('Please select a file');
      });
      return _errorText;
    }

    if (widget.customValidator != null) {
      final error = widget.customValidator!(_selectedFiles);
      if (error != null) {
        setState(() {
          _errorText = error;
        });
        return error;
      }
    }

    setState(() {
      _errorText = null;
    });
    return null;
  }

  /// Get the selected files
  List<PlatformFile> get selectedFiles => _selectedFiles;

  /// Get the first selected file (useful when allowMultiple is false)
  PlatformFile? get selectedFile =>
      _selectedFiles.isNotEmpty ? _selectedFiles.first : null;

  /// Get the file path of the first selected file
  String? get selectedFilePath => selectedFile?.path;

  /// Get all file paths
  List<String?> get selectedFilePaths =>
      _selectedFiles.map((f) => f.path).toList();
}
