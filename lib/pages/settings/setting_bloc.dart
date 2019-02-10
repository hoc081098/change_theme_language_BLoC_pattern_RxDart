import 'dart:async';

import 'package:change_theme_language_bloc/data/local_data_source.dart';
import 'package:change_theme_language_bloc/data/models/theme_locale_model.dart';
import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

//ignore_for_file: close_sinks

class SettingModel {
  final ThemeModel themeModel;
  final LocaleModel localeModel;

  const SettingModel(this.themeModel, this.localeModel);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingModel &&
          runtimeType == other.runtimeType &&
          themeModel == other.themeModel &&
          localeModel == other.localeModel;

  @override
  int get hashCode => themeModel.hashCode ^ localeModel.hashCode;

  @override
  String toString() =>
      'SettingModel{themeModel: $themeModel, localeModel: $localeModel}';
}

class SettingBloc implements BaseBloc {
  ///
  final void Function(ThemeModel) changeTheme;
  final void Function(LocaleModel) changeLocale;

  ///
  final ValueObservable<SettingModel> setting$;

  ///
  final void Function() _dispose;

  SettingBloc._(
    this.changeTheme,
    this.changeLocale,
    this.setting$,
    this._dispose,
  );

  factory SettingBloc(LocalDataSource local) {
    var themeController = PublishSubject<ThemeModel>();
    var localeController = PublishSubject<LocaleModel>();

    var theme$ = themeController
        .distinct()
        .switchMap((theme) => Observable.fromFuture(local.saveTheme(theme)))
        .where((success) => success)
        .startWith(null)
        .switchMap((_) => Observable.fromFuture(local.getTheme()))
        .doOnData(print);

    var locale$ = localeController
        .distinct()
        .switchMap((locale) => Observable.fromFuture(local.saveLocale(locale)))
        .where((success) => success)
        .startWith(null)
        .switchMap((_) => Observable.fromFuture(local.getLocale()))
        .doOnData(print);

    final setting$ = DistinctValueConnectableObservable(
      Observable.combineLatest2(
        theme$,
        locale$,
        (theme, locale) => SettingModel(theme, locale),
      ),
    );

    final subscriptions = <StreamSubscription>[
      setting$.listen(print),
      setting$.connect(),
    ];

    return SettingBloc._(
      themeController.add,
      localeController.add,
      setting$,
      () async {
        await Future.wait(subscriptions.map((s) => s.cancel()));
        await Future.wait([
          themeController,
          localeController,
        ].map((c) => c.close()));
      },
    );
  }

  @override
  void dispose() => _dispose();
}
