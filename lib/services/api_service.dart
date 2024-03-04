import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class APIService {
  static const String _baseUrl = Constants.agentUrl;
  static const _headers = {
    "content-type": "application/json; charset=UTF-8",
    "apikey": Constants.agentKey
  };
  static const _encoding = "utf-8";

  static Future get(String api,
      {Map<String, String>? optHeaders = const {}}) async {
    final url = '$_baseUrl/$api';
    final headers = {..._headers, ...optHeaders!};

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final data = utf8.decode(response.bodyBytes);
      return json.decode(data);
      //return utf8.decode(response.bodyBytes);
      //return response.body;
    } else {
      throw Exception(
          "Failed to GET api data, returned with error (status: ${response.statusCode}).");
    }
  }

  static Future post(String api, Object body,
      {Map<String, String>? optHeaders = const {}}) async {
    final url = '$_baseUrl/$api';
    final headers = {..._headers, ...optHeaders!};
    final response = await http.post(Uri.parse(url),
        body: body, headers: headers, encoding: Encoding.getByName(_encoding));

    if (kDebugMode) {
      print(response);
    }

    if (response.statusCode == 200) {
      final data = utf8.decode(response.bodyBytes);
      return json.decode(data);
    } else {
      throw Exception(
          "Failed to POST api data, returned with error. (status: ${response.statusCode})");
    }
  }

  static Future put(String api, String body,
      {Map<String, String>? optHeaders = const {}}) async {
    final url = '$_baseUrl/$api';
    final headers = {..._headers, ...optHeaders!};
    final response = await http.put(Uri.parse(url),
        body: body, headers: headers, encoding: Encoding.getByName(_encoding));

    if (response.statusCode == 200) {
      final data = utf8.decode(response.bodyBytes);
      return json.decode(data);
    } else {
      throw Exception(
          "Failed to PUT api data, returned with error. (status: ${response.statusCode})");
    }
  }

  static Future delete(String api,
      {Map<String, String>? optHeaders = const {}}) async {
    final url = '$_baseUrl/$api';

    print("------------- url = $url");
    final headers = {..._headers, ...optHeaders!};
    //final response = await http.delete(Uri.parse(url),
    //    headers: headers, encoding: Encoding.getByName(_encoding));
    final response = await http.delete(Uri.parse(url));

    print(
        "---------------- response code = ${response.statusCode} --------------");
    print("---------------- response body = ${response.body} --------------");

    if (response.statusCode == 200) {
      print("---------------- DELETED --------------");
      final data = utf8.decode(response.bodyBytes);
      return json.decode(data);
    } else {
      throw Exception(
          "Failed to DELETE api data, returned with error (status: ${response.statusCode}).");
    }
  }
}
