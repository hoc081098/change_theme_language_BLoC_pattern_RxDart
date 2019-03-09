import 'dart:convert';
import 'dart:io';

import 'package:change_theme_language_bloc/data/models/repo.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {
  static int _count = 0;

  @override
  Future<http.Response> get(url, {Map<String, String> headers}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (url == Api.kGithubUrl) {
      ++_count;
      if (_count % 2 == 0) {
        print('[API] count=$_count [1]');
        return http.Response(
          '{ "message": "Random error" }',
          HttpStatus.notImplemented,
        );
      } else {
        print('[API] count=$_count [2]');
        final body = await rootBundle.loadString('assets/json/repos.json');
        return http.Response(
          body,
          HttpStatus.ok,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
          },
        );
      }
    }
    return http.Response('', HttpStatus.notImplemented);
  }
}

class Api {
  static const kGithubUrl =
      'https://api.github.com/users/hoc081098/repos?sort=updated&direction=desc';

  final http.Client _client;

  const Api(this._client);

  Future<List<Repo>> myRepos() async {
    final response = await _client.get(
      kGithubUrl,
      headers: const <String, String>{
        HttpHeaders.acceptHeader: 'application/vnd.github.v3+json',
      },
    );
    final statusCode = response.statusCode;

    if (statusCode != HttpStatus.ok) {
      var msg = 'Error while getting data';
      if (response.body != null) {
        final errorMsg = json.decode(response.body)['message'];
        if (errorMsg != null) {
          msg = '$msg: $errorMsg';
        }
      }
      throw HttpException(msg);
    }
    final decoded = json.decode(response.body) as Iterable;
    return decoded.map((repo) => Repo.fromJson(repo)).toList();
  }
}
