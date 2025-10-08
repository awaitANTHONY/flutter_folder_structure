import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:chunked_uploader/chunked_uploader.dart';
import '/utils/helpers.dart';
import '/consts/consts.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      sendTimeout: Duration(seconds: 30),
    ),
  );

  ApiService() {
    dd('ApiService Init (Dio)');
  }

  static Future<Response> get(
    String url, {
    Map<String, String> headers = const {},
    Map<String, dynamic> queryParams = const {},
  }) async {
    await _checkConnectivity();
    headers = await _buildHeaders(headers);
    return await _dio.get(
      url,
      options: Options(headers: headers),
      queryParameters: queryParams,
    );
  }

  static Future<Response> post(
    String url, {
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
  }) async {
    await _checkConnectivity();
    headers = await _buildHeaders(headers);
    dd(headers);
    return await _dio.post(
      url,
      data: body,
      options: Options(headers: headers),
    );
  }

  static Future<Response> patch(
    String url, {
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
  }) async {
    await _checkConnectivity();
    headers = await _buildHeaders(headers);
    return await _dio.patch(
      url,
      data: body,
      options: Options(headers: headers),
    );
  }

  static Future<Response> put(
    String url, {
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
  }) async {
    await _checkConnectivity();
    headers = await _buildHeaders(headers);
    return await _dio.put(
      url,
      data: body,
      options: Options(headers: headers),
    );
  }

  static Future<Response> delete(
    String url, {
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
  }) async {
    await _checkConnectivity();
    headers = await _buildHeaders(headers);
    return await _dio.delete(
      url,
      data: body,
      options: Options(headers: headers),
    );
  }

  static Future<Response> file(
    String url,
    List<String>? paths, {
    String field = 'file',
    String method = "POST",
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
    void Function(dynamic percent)? progress,
  }) async {
    await _checkConnectivity();

    // if (paths == null || paths.isEmpty) {
    //   throw Exception('No file paths provided for upload!');
    // }

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

    final formData = FormData.fromMap({
      ...body,
      field: files.length == 1 ? files.first : files,
    });

    final response = await _dio.request(
      url,
      data: formData,
      options: Options(
        method: method,
        headers: headers,
        contentType: 'multipart/form-data',
      ),
      onSendProgress: (sent, total) {
        final progressPercent = (sent / total * 100).toStringAsFixed(0);
        dd('Upload Progress: $progressPercent%');
        if (progress != null) {
          progress(progressPercent);
        }
      },
    );

    return response;
  }

  static Future<Response> chunkFile(
    String url,
    String path, {
    String field = 'file',
    Map<String, String> headers = const {},
    Map<String, String> body = const {},
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
      Dio(BaseOptions(baseUrl: url, headers: headers)),
    );

    final response = await chunkedUploader.uploadUsingFilePath(
      fileName: fileName,
      fileKey: field,
      method: "POST",
      filePath: path,
      maxChunkSize: 500000,
      path: url,
      data: body,
      onUploadProgress: (progressPercent) {
        dd("Chunk Upload Progress: $progressPercent%");
        if (progress != null) {
          progress(progressPercent);
        }
      },
    );

    return response!;
  }

  static Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      throw Exception('No internet connection please try again!');
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
}
