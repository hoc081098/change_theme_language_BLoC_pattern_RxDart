import 'dart:convert';
import 'dart:io';

import 'package:change_theme_language_bloc/data/models/repo.dart';
import 'package:http/http.dart' as http;

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
      throw HttpException('Error while getting data');
    }
    final decoded = json.decode(response.body) as Iterable;
    return decoded.map((repo) => Repo.fromJson(repo)).toList();
  }
}
