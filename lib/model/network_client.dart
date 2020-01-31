import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:todo_list/model/todo.dart';

const Map<String, String> commonHeaders = {
  'Content-Type': 'application/json',
};
final String baseUrl =
    Platform.isAndroid ? 'http://10.0.2.2:8989' : 'http://localhost:8989';

class NetworkClient {
  NetworkClient._();

  static NetworkClient _client;

  factory NetworkClient.instance() {
    if (_client == null) {
      _client = NetworkClient._();
    }
    return _client;
  }

  Future<String> login(String email, String password) async {
    Map result;
    try {
      Response response = await post(
        '$baseUrl/login',
        body: JsonEncoder().convert({
          'email': email,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      result = JsonDecoder().convert(response.body);
    } catch (e) {
      result['error'] = '服务器请求失败，请检查网络连接';
    }
    return result['error'];
  }

  Future<String> uploadList(List<Todo> list, String email) async {
    Map result = {};
    try {
      Response response = await post(
        '$baseUrl/list',
        body: JsonEncoder().convert({
          'email': email,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'data': list.map((todo) => todo.toMap()).toList(),
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      result = JsonDecoder().convert(response.body);
    } catch (e) {
      result['error'] = '服务器请求失败，请检查网络连接';
    }
    return result['error'];
  }

  Future<FetchListResult> fetchList(String email) async {
    FetchListResult result;
    try {
      Response response = await get(
        '$baseUrl/list?email=$email',
        headers: commonHeaders,
      );
      result = FetchListResult.fromJson(JsonDecoder().convert(response.body));
    } catch (e) {
      result = FetchListResult(error: '服务器请求失败，请检查网络连接');
    }
    return result;;
  }
}

class FetchListResult {
  final List<Todo> data;
  final DateTime timestamp;
  final String error;

  FetchListResult({this.data, this.timestamp, this.error = ''});

  factory FetchListResult.fromJson(Map<String, dynamic> json) {
    return FetchListResult(
      data: json['data'].map((e) => Todo.fromMap(e)).toList(),
      timestamp: DateTime.fromMicrosecondsSinceEpoch(json['timestamp']),
    );
  }
}
