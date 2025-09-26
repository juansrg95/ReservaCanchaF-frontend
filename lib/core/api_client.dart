import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/env.dart';
import 'session.dart';

class ApiClient {
  ApiClient();

  final http.Client _http = http.Client();
  final String _base = Env.apiBase; // p.ej: http://75.101.224.153:8080

  Uri _uri(String path, [Map<String, String>? query]) {
    final base = Uri.parse(_base);

    String joinPath(String a, String b) {
      if (a.endsWith('/')) a = a.substring(0, a.length - 1);
      if (b.startsWith('/')) b = b.substring(1);
      return '$a/$b';
    }

    return Uri(
      scheme: base.scheme,
      host: base.host,
      port: base.port,
      path: joinPath(base.path.isEmpty ? '/' : base.path, path),
      queryParameters: (query == null || query.isEmpty) ? null : query,
    );
  }

  Map<String, String> _headers({bool withAuth = true, Map<String, String>? extra}) => {
        'Content-Type': 'application/json',
        if (withAuth && Session.authHeader != null) 'Authorization': Session.authHeader!,
        ...?extra,
      };

  Future<http.Response> get(
    String path, {
    Map<String, String>? query,
    Map<String, String>? headers,
    bool withAuth = true,
  }) {
    return _http.get(_uri(path, query), headers: _headers(withAuth: withAuth, extra: headers));
  }

  Future<http.Response> post(
    String path, {
    String? body,
    Map<String, String>? query,
    Map<String, String>? headers,
    bool withAuth = true,
  }) {
    return _http.post(_uri(path, query), headers: _headers(withAuth: withAuth, extra: headers), body: body);
  }

  Future<http.Response> put(
    String path, {
    String? body,
    Map<String, String>? query,
    Map<String, String>? headers,
    bool withAuth = true,
  }) {
    return _http.put(_uri(path, query), headers: _headers(withAuth: withAuth, extra: headers), body: body);
  }

  Future<http.Response> delete(
    String path, {
    Map<String, String>? query,
    Map<String, String>? headers,
    bool withAuth = true,
  }) {
    return _http.delete(_uri(path, query), headers: _headers(withAuth: withAuth, extra: headers));
  }
}










