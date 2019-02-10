import 'dart:io';

import 'package:change_theme_language_bloc/data/api.dart';
import 'package:change_theme_language_bloc/pages/home/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {}

Future<String> fixture(String file) => File(file).readAsString();

main() {
  group('Test home bloc', () async {
    http.Client client;
    Api api;
    HomeBloc bloc;

    setUp(() {
      client = MockClient();
      api = Api(client);
      bloc = HomeBloc(api);
    });

    test(
      'Home bloc: emit loading first, then list repos when complete successfully',
      () {
        when(client.get(Api.kGithubUrl)).thenAnswer((_) {
          return fixture('fixtures/response_success.json').then((json) {
            return http.Response(
              json,
              HttpStatus.ok,
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              },
            );
          });
        });
        bloc.fetchMyRepos();
        expectLater(bloc.state$, emits(null));
      },
    );

    tearDown(() {
      bloc.dispose();
      client.close();
    });
  });
}
