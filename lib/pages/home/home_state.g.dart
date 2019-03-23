// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HomeList extends HomeList {
  @override
  final BuiltList<Repo> repos;
  @override
  final bool isLoading;
  @override
  final Object error;

  factory _$HomeList([void updates(HomeListBuilder b)]) =>
      (new HomeListBuilder()..update(updates)).build();

  _$HomeList._({this.repos, this.isLoading, this.error}) : super._() {
    if (repos == null) {
      throw new BuiltValueNullFieldError('HomeList', 'repos');
    }
    if (isLoading == null) {
      throw new BuiltValueNullFieldError('HomeList', 'isLoading');
    }
  }

  @override
  HomeList rebuild(void updates(HomeListBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  HomeListBuilder toBuilder() => new HomeListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HomeList &&
        repos == other.repos &&
        isLoading == other.isLoading &&
        error == other.error;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, repos.hashCode), isLoading.hashCode), error.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('HomeList')
          ..add('repos', repos)
          ..add('isLoading', isLoading)
          ..add('error', error))
        .toString();
  }
}

class HomeListBuilder implements Builder<HomeList, HomeListBuilder> {
  _$HomeList _$v;

  ListBuilder<Repo> _repos;
  ListBuilder<Repo> get repos => _$this._repos ??= new ListBuilder<Repo>();
  set repos(ListBuilder<Repo> repos) => _$this._repos = repos;

  bool _isLoading;
  bool get isLoading => _$this._isLoading;
  set isLoading(bool isLoading) => _$this._isLoading = isLoading;

  Object _error;
  Object get error => _$this._error;
  set error(Object error) => _$this._error = error;

  HomeListBuilder();

  HomeListBuilder get _$this {
    if (_$v != null) {
      _repos = _$v.repos?.toBuilder();
      _isLoading = _$v.isLoading;
      _error = _$v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HomeList other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$HomeList;
  }

  @override
  void update(void updates(HomeListBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$HomeList build() {
    _$HomeList _$result;
    try {
      _$result = _$v ??
          new _$HomeList._(
              repos: repos.build(), isLoading: isLoading, error: error);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'repos';
        repos.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'HomeList', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
