import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:change_theme_language_bloc/data/api.dart';
import 'package:change_theme_language_bloc/pages/home/home_state.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';

//ignore_for_file: close_sinks

///
/// Business logic component (BLoC) for home page
///
class HomeBloc implements BaseBloc {
  ///
  /// Input [Function]s
  ///
  final Future<void> Function() fetchMyRepos;

  ///
  /// Output [Stream]s
  ///
  final ValueObservable<HomeList> state$;
  final Stream<Object> error$;

  ///
  /// Clean up resource
  ///
  final void Function() _dispose;

  HomeBloc._(
    this.fetchMyRepos,
    this.state$,
    this._dispose,
    this.error$,
  );

  factory HomeBloc(final Api api) {
    ///
    /// Stream controllers
    ///
    final fetchMyReposController = PublishSubject<void>();
    final errorController = PublishSubject<Object>();

    ///
    /// A [Completer] that complete when loaded done
    ///
    Completer<void> completer;

    ///
    /// Transform fetch action stream to home list state stream
    ///
    final homeListState$ = fetchMyReposController.exhaustMap((_) {
      return Observable.fromFuture(api.myRepos())
          .doOnError((e, s) {
            // add error to [errorController] when error occurred
            errorController.add(e);
          })
          .doOnEach((_) {
            /// Complete [completer]
            _completeCompleter(completer);
            completer = null;
          })
          .map<PartialChange>((repos) => DataPartialChange(repos))
          .startWith(const LoadingPartialChange())
          .onErrorReturnWith((e) => ErrorPartialChange(e));
    }).scan(reducer, HomeList.initialState());

    ///
    /// Final Home state streams
    ///
    final homeListStateValueConnectableObservable$ =
        DistinctValueConnectableObservable.seeded(
      homeListState$,
      seedValue: HomeList.initialState(),
    );

    final subscriptions = <StreamSubscription>[
      homeListStateValueConnectableObservable$.listen(
        (data) => print('[HOMEBLOC] state=$data'),
        onError: (e) => print('[HOMEBLOC] error=$e'),
      ),
      homeListStateValueConnectableObservable$.connect(),
    ];

    return HomeBloc._(
      () {
        _completeCompleter(completer);
        completer = null;

        completer = Completer<void>();
        fetchMyReposController.add(null);

        return completer.future;
      },
      homeListStateValueConnectableObservable$,
      () async {
        ///
        /// Cancel stream subscriptions
        ///
        await Future.wait(subscriptions.map((s) => s.cancel()));

        ///
        /// And then, close stream controllers
        ///
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

  ///
  /// Pure function, produce new state from previous state [state] and a change [change]
  ///
  static HomeList reducer(HomeList state, PartialChange change, int _) {
    if (change is LoadingPartialChange) {
      return state.rebuild((b) => b
        ..isLoading = true
        ..error = null);
    }
    if (change is ErrorPartialChange) {
      return state.rebuild((b) => b
        ..isLoading = false
        ..error = change.error);
    }
    if (change is DataPartialChange) {
      return state.rebuild((b) => b
        ..repos = ListBuilder(change.repos)
        ..isLoading = false
        ..error = null);
    }
    return state;
  }
}

///
/// Complete [completer] if not yet
///
void _completeCompleter(Completer completer) {
  if (completer == null || completer.isCompleted) return;
  try {
    completer.complete();
  } catch (e) {
    print(e);
  }
}
