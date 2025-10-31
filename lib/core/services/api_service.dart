import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';

import 'log_service.dart';

class ApiService {
  final String _baseUrl;

  ApiService() : _baseUrl = _resolveBaseUrl();

  static String _resolveBaseUrl() {
    final config = GlobalConfiguration();
    final env = config.getValue<String>('environment');
    final apiConfig = config.getValue<Map<String, dynamic>>('api');

    if (env == 'development') {
      return apiConfig['base_url_dev'] ?? '';
    } else {
      return apiConfig['base_url_prod'] ?? '';
    }
  }


  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    LogService.d('GET $url');

    try {
      final response = await http.get(url, headers: headers);
      return _handleResponse(response);
    } catch (e, s) {
      LogService.e('GET error: $e', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, String>? headers, dynamic body}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    LogService.d('POST $url\nBODY: $body');

    try {
      final response = await http.post(
        url,
        headers: _mergeHeaders(headers),
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e, s) {
      LogService.e('POST error: $e', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, {Map<String, String>? headers, dynamic body}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    LogService.d('PUT $url\nBODY: $body');

    try {
      final response = await http.put(
        url,
        headers: _mergeHeaders(headers),
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e, s) {
      LogService.e('PUT error: $e', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    LogService.d('DELETE $url');

    try {
      final response = await http.delete(url, headers: headers);
      return _handleResponse(response);
    } catch (e, s) {
      LogService.e('DELETE error: $e', error: e, stackTrace: s);
      rethrow;
    }
  }

  Map<String, String> _mergeHeaders(Map<String, String>? customHeaders) {
    return {
      'Content-Type': 'application/json',
      ...?customHeaders,
    };
  }

  dynamic _handleResponse(http.Response response) {
    LogService.i('Response [${response.statusCode}]: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return json.decode(response.body);
      } catch (e) {
        LogService.w('Response decode failed', error: e);
        return response.body;
      }
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException [$statusCode]: $message';
}
