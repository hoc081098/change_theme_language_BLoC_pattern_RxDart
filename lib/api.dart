import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class Repo {
  final String name;
  final String description;
  final String url;
  final DateTime updatedAt;
  final int stargazersCount;
  final int forksCount;

  Repo({
    @required this.name,
    @required this.description,
    @required this.url,
    @required this.updatedAt,
    @required this.stargazersCount,
    @required this.forksCount,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'],
      description: json['description'] ?? '',
      url: json['html_url'],
      updatedAt: DateTime.parse(json['updated_at']),
      stargazersCount: json['stargazers_count'],
      forksCount: json['forks_count'],
    );
  }

  @override
  String toString() =>
      'Repo{name: $name, description: $description, url: $url, updatedAt: $updatedAt, stargazersCount: $stargazersCount, forksCount: $forksCount}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Repo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          description == other.description &&
          url == other.url &&
          updatedAt == other.updatedAt &&
          stargazersCount == other.stargazersCount &&
          forksCount == other.forksCount;

  @override
  int get hashCode =>
      name.hashCode ^
      description.hashCode ^
      url.hashCode ^
      updatedAt.hashCode ^
      stargazersCount.hashCode ^
      forksCount.hashCode;
}

class Api {
  static const kGithubUrl =
      'https://api.github.com/users/hoc081098/repos?sort=updated&direction=desc';

  final Dio dio;

  Api()
      : dio = new Dio()
          ..options.connectTimeout = 5000
          ..options.receiveTimeout = 5000
          ..options.headers = {
            HttpHeaders.acceptHeader: 'application/vnd.github.v3+json'
          }
          ..interceptors.add(LogInterceptor(responseBody: true));

  Future<List<Repo>> myRepos() async {
    var response = await dio.get(kGithubUrl);
    var statusCode = response.statusCode;
    if (statusCode != HttpStatus.notModified) {
      throw HttpException('Error');
    }
    final decoded = json.decode(response.data) as Iterable;
    return decoded.map((repo) => Repo.fromJson(repo)).toList();
  }
}
