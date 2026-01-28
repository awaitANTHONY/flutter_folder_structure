import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:chunked_uploader/chunked_uploader.dart';
import '/utils/helpers.dart';
import '/consts/consts.dart';

export 'package:dio/dio.dart' show Response, DioException;

enum Method { get, post, put, patch, delete }

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 300),
      receiveTimeout: const Duration(seconds: 300),
      sendTimeout: const Duration(seconds: 300),
      receiveDataWhenStatusError: true,
    ),
  );

  ApiService() {
    dd('ApiService Init (Dio)');
  }

  static Future<Response> request(
    String url, {
    Map<String, dynamic> parameters = const {},
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
    Method method = Method.get,
    List<String>? filePaths,
    List<String>? fileFieldNames,
    void Function(dynamic percent)? progress,
    bool isChunked = false,
    bool showingErrors = true,
  }) async {
    await _checkConnectivity();
    headers = await _buildHeaders(headers);

    if (filePaths != null && filePaths.isNotEmpty) {
      if (isChunked) {
        return _chunkFile(
          url,
          queryParameters: parameters,
          filePaths.first,
          field: fileFieldNames?.first ?? 'file',
          headers: headers,
          body: body.map((key, value) => MapEntry(key, value.toString())),
          method: method,
          progress: progress,
        );
      } else {
        return _file(
          url,
          queryParameters: parameters,
          paths: filePaths,
          fields: fileFieldNames,
          headers: headers,
          body: body,
          method: method,
          progress: progress,
        );
      }
    }

    try {
      return await _dio.request(
        url,
        options: Options(headers: headers, method: method.name.toUpperCase()),
        queryParameters: parameters,
        data: method != Method.get ? body : null,
      );
    } on DioException catch (e) {
      if (showingErrors) {
        _handleDioError(e);
      }
      rethrow;
    }
  }

  static Future<Response> _file(
    String url, {
    Map<String, dynamic> queryParameters = const {},
    List<String>? paths,
    List<String>? fields,
    Method method = Method.get,
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
    void Function(dynamic percent)? progress,
  }) async {
    await _checkConnectivity();
    headers = await _buildMultipartHeaders(headers);

    List<MultipartFile> files = [];
    for (final path in (paths ?? [])) {
      final mimeType = lookupMimeType(path)?.split('/');
      if (mimeType != null && mimeType.length == 2) {
        files.add(
          await MultipartFile.fromFile(
            path,
            filename: path.split('/').last,
            contentType: MediaType(mimeType[0], mimeType[1]),
          ),
        );
      }
    }

    List<MapEntry<String, MultipartFile>> fileEntries = [];
    for (int i = 0; i < files.length; i++) {
      final fieldName = (fields != null && fields.length > i)
          ? fields[i]
          : (fields != null && fields.isNotEmpty)
          ? fields.first
          : 'file';
      fileEntries.add(MapEntry(fieldName, files[i]));
    }

    final formData = FormData.fromMap({
      ...body,
      ...Map.fromEntries(fileEntries),
    });

    try {
      final response = await _dio.request(
        url,
        queryParameters: queryParameters,
        data: formData,
        options: Options(
          method: method.name.toUpperCase(),
          headers: headers,
          contentType: 'multipart/form-data',
        ),
        onSendProgress: (sent, total) {
          final progressPercent = (sent / total * 100).toStringAsFixed(0);
          dd('Upload Progress: $progressPercent%');
          progress?.call(progressPercent);
        },
      );

      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  static Future<Response> _chunkFile(
    String url,
    String path, {
    Map<String, dynamic> queryParameters = const {},
    String field = 'file',
    Map<String, String> headers = const {},
    Map<String, String> body = const {},
    Method method = Method.post,
    void Function(dynamic percent)? progress,
  }) async {
    await _checkConnectivity();

    final fileName = path.split('/').last;
    headers = {
      ...headers,
      'Content-Type': 'multipart/form-data',
      'Connection': 'Keep-Alive',
      'User-Agent': await generateUserAgent(),
    };

    if (AppConsts.apiKey.isNotEmpty) {
      headers['X-API-KEY'] = AppConsts.apiKey;
    }

    final chunkedUploader = ChunkedUploader(
      Dio(
        BaseOptions(
          baseUrl: url,
          headers: headers,
          method: method.name.toUpperCase(),
          queryParameters: queryParameters,
        ),
      ),
    );

    final response = await chunkedUploader.uploadUsingFilePath(
      fileName: fileName,
      fileKey: field,
      method: Method.post.name.toUpperCase(),
      filePath: path,
      maxChunkSize: 500000,
      path: url,
      data: body,
      onUploadProgress: (progressPercent) {
        dd("Chunk Upload Progress: $progressPercent%");
        progress?.call(progressPercent);
      },
    );

    return response!;
  }

  static Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      showToast(
        'No internet connection. Please try again.',
        type: ToastType.error,
      );
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        message: 'No internet connection.',
      );
    }
  }

  static Future<Map<String, String>> _buildHeaders(
    Map<String, String> customHeaders,
  ) async {
    final headers = {
      ...customHeaders,
      'Content-Type': 'application/json; charset=UTF-8',
      'User-Agent': await generateUserAgent(),
    };
    if (AppConsts.apiKey.isNotEmpty) {
      headers['X-API-KEY'] = AppConsts.apiKey;
    }
    return headers;
  }

  static Future<Map<String, String>> _buildMultipartHeaders(
    Map<String, String> customHeaders,
  ) async {
    final headers = {
      ...customHeaders,
      'User-Agent': await generateUserAgent(),
      'Content-Type': 'multipart/form-data',
    };
    if (AppConsts.apiKey.isNotEmpty) {
      headers['X-API-KEY'] = AppConsts.apiKey;
    }
    return headers;
  }

  static Future<String> generateUserAgent() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      return 'Mozilla/5.0 (iPhone; CPU iPhone OS ${iosInfo.systemVersion.replaceAll('.', '_')} like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Mobile/15E148 Safari/604.1';
    } else if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      return 'Mozilla/5.0 (Linux; Android ${androidInfo.version.release}; ${androidInfo.model}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Mobile Safari/537.36';
    } else {
      return 'Unknown User Agent';
    }
  }

  static void _handleDioError(DioException e) {
    // return;
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      showToast(
        'Connection timed out. Please try again.',
        type: ToastType.error,
      );
    } else if (e.type == DioExceptionType.connectionError) {
      showToast(
        'Failed to connect to server. Check your internet.',
        type: ToastType.error,
      );
    } else if (e.response != null) {
      final data = e.response?.data;

      // dd('error response : $data', isShowLog: true, doCopy: true);

      if (data is Map<String, dynamic>) {
        showErrors(data);
      } else {
        showToast(
          'Server error: ${e.response?.statusCode}',
          type: ToastType.error,
        );
      }
    } else {
      // dd('${e.type.toString()} ${e.message}', isShowLog: true);
      showToast(
        'Unexpected error occurred. ${e.message}',
        type: ToastType.error,
      );
    }
  }
}

void showErrors(dynamic responseModel, {bool showMessageOnly = true}) {
  if (responseModel == null) {
    showToast('Unknown error occurred.', type: ToastType.error);
    return;
  }

  final generalMessage =
      responseModel['message'] ??
      responseModel['errors'] ??
      'Something went wrong.';

  if (responseModel.containsKey('errors') &&
      responseModel['errors'] is Map<String, dynamic> &&
      responseModel['errors'].isNotEmpty) {
    final Map<String, dynamic> errorsMap = Map<String, dynamic>.from(
      responseModel['errors'],
    );

    final field = errorsMap.keys.first;
    final messages = errorsMap[field];

    if (messages is List) {
      final msg = messages.first;
      if (msg is Map) {
        msg.forEach((key, value) {
          final msg = value is String ? value : value[0].toString();
          showToast("$key: $msg", type: ToastType.error);
        });
      } else {
        showToast("$field: $msg", type: ToastType.error);
      }
    } else if (messages is Map) {
      messages.forEach((subField, subMessages) {
        if (subMessages is List) {
          final List msg = subMessages.first;
          showToast("$subField: $msg", type: ToastType.error);
        } else {
          showToast("$subField: $subMessages", type: ToastType.error);
        }
      });
    } else {
      showToast(
        generalMessage == '' ? "$field: $messages" : generalMessage,
        type: ToastType.error,
      );
    }
  } else {
    showToast(generalMessage, type: ToastType.error);
  }
}
