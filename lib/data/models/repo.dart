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
}
