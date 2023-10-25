import 'dart:convert';
import 'package:chunked_uploader/chunked_uploader.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '/views/utils/helpers.dart';

class ApiService {
  static final http.Client _client = http.Client();

  ApiService() {
    dd('ApiService Init');
  }

  static Future<http.Response> get(
    String url, {
    Map<String, String> headers = const {},
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      Uri uri = Uri.parse(url);

      headers['Content-Type'] = 'application/json; charset=UTF-8';
      var response = await _client.get(
        uri,
        headers: headers,
      );
      return response;
    } else {
      throw Exception('No internet connection please try again!');
    }
  }

  static Future<http.Response> post(
    String url, {
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      Uri uri = Uri.parse(url);

      headers['Content-Type'] = 'application/json; charset=UTF-8';
      var response = await _client.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      return response;
    } else {
      throw Exception('No internet connection please try again!');
    }
  }

  static Future<http.Response> file(
    String url,
    String path, {
    String field = 'file',
    Map<String, String> headers = const {},
    Map<String, String> body = const {},
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      Uri uri = Uri.parse(url);

      headers['Content-Type'] = 'application/json; charset=UTF-8';

      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);
      request.fields.addAll(body);
      request.files.add(
        await http.MultipartFile.fromPath(
          field,
          path,
        ),
      );
      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      return response;
    } else {
      throw Exception('No internet connection please try again!');
    }
  }

  static Future<Response> chunkFile(
    String url,
    String path, {
    String field = 'file',
    Map<String, String> headers = const {},
    Map<String, String> body = const {},
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      String fileName = path.split('/').last;
      headers['Content-Type'] = 'multipart/form-data';
      headers['Connection'] = 'Keep-Alive';

      ChunkedUploader chunkedUploader = ChunkedUploader(
        Dio(
          BaseOptions(
            baseUrl: url,
            headers: headers,
          ),
        ),
      );
      Response? response = await chunkedUploader.uploadUsingFilePath(
        fileName: fileName,
        fileKey: field,
        method: "POST",
        filePath: path,
        maxChunkSize: 500000,
        path: url,
        data: body,
        onUploadProgress: (v) {
          dd(v);
        },
      );

      return response!;
    } else {
      throw Exception('No internet connection please try again!');
    }
  }
}
