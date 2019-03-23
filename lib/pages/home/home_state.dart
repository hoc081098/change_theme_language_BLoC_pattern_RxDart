import 'package:change_theme_language_bloc/data/models/repo.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';

part 'home_state.g.dart';

abstract class HomeList implements Built<HomeList, HomeListBuilder> {
  BuiltList<Repo> get repos;
  bool get isLoading;
  @nullable
  Object get error;

  HomeList._();

  factory HomeList([updates(HomeListBuilder b)]) = _$HomeList;

  factory HomeList.initialState() => HomeList((b) => b
    ..isLoading = true
    ..repos = ListBuilder<Repo>()
    ..error = null);
}

@immutable
abstract class PartialChange {}

class DataPartialChange implements PartialChange {
  final List<Repo> repos;

  DataPartialChange(this.repos);

  @override
  String toString() => 'DataPartialChange{repos: $repos}';
}

class LoadingPartialChange implements PartialChange {
  const LoadingPartialChange();

  @override
  String toString() => 'LoadingPartialChange';
}

class ErrorPartialChange implements PartialChange {
  final Object error;

  ErrorPartialChange(this.error);

  @override
  String toString() => 'ErrorPartialChange{error: $error}';
}
