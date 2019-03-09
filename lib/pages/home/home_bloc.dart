import 'dart:async';

import 'package:change_theme_language_bloc/data/api.dart';
import 'package:change_theme_language_bloc/data/models/repo.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';

//ignore_for_file: close_sinks

class HomeList {
  final List<Repo> repos;
  final bool isLoading;
  final Object error;

  const HomeList({
    @required this.repos,
    @required this.isLoading,
    @required this.error,
  });

  factory HomeList.initialState() =>
      const HomeList(repos: [], isLoading: true, error: null);

  @override
  String toString() =>
      'HomeList{repos.length: ${repos.length}, isLoading: $isLoading, error: $error}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeList &&
          runtimeType == other.runtimeType &&
          const ListEquality<Repo>().equals(repos, other.repos) &&
          isLoading == other.isLoading &&
          error == other.error;

  @override
  int get hashCode =>
      const ListEquality<Repo>().hash(repos) ^
      isLoading.hashCode ^
      error.hashCode;
}

abstract class PartialChange {}

class Data implements PartialChange {
  final List<Repo> repos;

  Data(this.repos);

  @override
  String toString() => 'Data{repos: $repos}';
}

class Loading implements PartialChange {
  const Loading();
}

class Error implements PartialChange {
  final Object error;

  Error(this.error);

  @override
  String toString() => 'Error{error: $error}';
}

///
///
///
class HomeBloc implements BaseBloc {
  final Future<void> Function() fetchMyRepos;

  final ValueObservable<HomeList> state$;
  final Stream<Object> error$;

  final void Function() _dispose;

  HomeBloc._(
    this.fetchMyRepos,
    this.state$,
    this._dispose,
    this.error$,
  );

  factory HomeBloc(Api api) {
    final fetchMyReposController = PublishSubject<void>();
    final errorController = PublishSubject<Object>();

    Completer<void> completer;

    final homeListState$ = fetchMyReposController.exhaustMap((_) {
      return Observable.fromFuture(api.myRepos())
          .doOnError((e, s) => errorController.add(e))
          .doOnEach((_) {
            _completeCompleter(completer);
            completer = null;
          })
          .map<PartialChange>((repos) => Data(repos))
          .startWith(const Loading())
          .onErrorReturnWith((e) => Error(e));
    }).scan(reducer, HomeList.initialState());

    final state$ = DistinctValueConnectableObservable(
      homeListState$,
      seedValue: HomeList.initialState(),
    );

    final subscriptions = <StreamSubscription>[
      state$.listen(
        (data) => print('[HOMEBLOC] state=$data'),
        onError: (e) => print('[HOMEBLOC] error=$e'),
      ),
      state$.connect(),
    ];

    return HomeBloc._(
      () {
        _completeCompleter(completer);
        completer = null;

        completer = Completer<void>();
        fetchMyReposController.add(null);

        return completer.future;
      },
      state$,
      () async {
        await Future.wait(subscriptions.map((s) => s.cancel()));
        await Future.wait([
          fetchMyReposController,
          errorController,
        ].map((c) => c.close()));
      },
      errorController.stream,
    );
  }

  @override
  void dispose() => _dispose();

  static HomeList reducer(HomeList state, PartialChange change, int _) {
    if (change is Loading) {
      return HomeList(
        repos: state.repos,
        isLoading: true,
        error: null,
      );
    }
    if (change is Error) {
      return HomeList(
        repos: state.repos,
        isLoading: false,
        error: change.error,
      );
    }
    if (change is Data) {
      return HomeList(
        repos: change.repos,
        isLoading: false,
        error: null,
      );
    }
    return state;
  }
}

_completeCompleter(Completer completer) {
  if (completer == null || completer.isCompleted) return;
  try {
    completer.complete();
  } catch (e) {
    print(e);
  }
}
