// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SettingsState extends SettingsState {
  @override
  final ThemeModel themeModel;
  @override
  final LocaleModel localeModel;

  factory _$SettingsState([void updates(SettingsStateBuilder b)]) =>
      (new SettingsStateBuilder()..update(updates)).build();

  _$SettingsState._({this.themeModel, this.localeModel}) : super._() {
    if (themeModel == null) {
      throw new BuiltValueNullFieldError('SettingsState', 'themeModel');
    }
    if (localeModel == null) {
      throw new BuiltValueNullFieldError('SettingsState', 'localeModel');
    }
  }

  @override
  SettingsState rebuild(void updates(SettingsStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  SettingsStateBuilder toBuilder() => new SettingsStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettingsState &&
        themeModel == other.themeModel &&
        localeModel == other.localeModel;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, themeModel.hashCode), localeModel.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SettingsState')
          ..add('themeModel', themeModel)
          ..add('localeModel', localeModel))
        .toString();
  }
}

class SettingsStateBuilder
    implements Builder<SettingsState, SettingsStateBuilder> {
  _$SettingsState _$v;

  ThemeModel _themeModel;
  ThemeModel get themeModel => _$this._themeModel;
  set themeModel(ThemeModel themeModel) => _$this._themeModel = themeModel;

  LocaleModel _localeModel;
  LocaleModel get localeModel => _$this._localeModel;
  set localeModel(LocaleModel localeModel) => _$this._localeModel = localeModel;

  SettingsStateBuilder();

  SettingsStateBuilder get _$this {
    if (_$v != null) {
      _themeModel = _$v.themeModel;
      _localeModel = _$v.localeModel;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettingsState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SettingsState;
  }

  @override
  void update(void updates(SettingsStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$SettingsState build() {
    final _$result = _$v ??
        new _$SettingsState._(themeModel: themeModel, localeModel: localeModel);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
