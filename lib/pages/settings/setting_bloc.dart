import 'dart:async';

import 'package:change_theme_language_bloc/data/local_data_source.dart';
import 'package:change_theme_language_bloc/data/models/locale_model.dart';
import 'package:change_theme_language_bloc/data/models/theme_model.dart';
import 'package:change_theme_language_bloc/pages/settings/setting_state.dart';
import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

//ignore_for_file: close_sinks

///
/// Business logic component BLoC for settings
///
class SettingBloc implements BaseBloc {
  ///
  /// Input [Function]s
  ///
  final void Function(ThemeModel) changeTheme;
  final void Function(LocaleModel) changeLocale;

  ///
  /// Output [Stream]s
  ///
  final ValueObservable<SettingsState> setting$;

  ///
  /// Clean up resource
  ///
  final void Function() _dispose;

  SettingBloc._(
    this.changeTheme,
    this.changeLocale,
    this.setting$,
    this._dispose,
  );

  factory SettingBloc(final LocalDataSource local) {
    ///
    /// Stream controllers
    ///
    final changeThemeController = PublishSubject<ThemeModel>();
    final changeLocaleController = PublishSubject<LocaleModel>();

    ///
    /// Transform stream of change theme actions to stream of [ThemeModel]s
    ///
    final theme$ = changeThemeController
        .distinct()
        .switchMap((theme) => Observable.fromFuture(local.saveTheme(theme)))
        .where((success) => success)
        .startWith(null) // get theme initial
        .switchMap((_) => Observable.fromFuture(local.getTheme()))
        .doOnData(print);

    ///
    /// Transform stream of change locale actions to stream of [LocaleModel]s
    ///
    final locale$ = changeLocaleController
        .distinct()
        .switchMap((locale) => Observable.fromFuture(local.saveLocale(locale)))
        .where((success) => success)
        .startWith(null) // get locale initial
        .switchMap((_) => Observable.fromFuture(local.getLocale()))
        .doOnData(print);

    ///
    /// Final setting state stream
    ///
    final settingsState$ = DistinctValueConnectableObservable(
      Observable.combineLatest2(
        theme$,
        locale$,
        (theme, locale) => SettingsState((b) => b
          ..themeModel = theme
          ..localeModel = locale),
      ),
    );

    final subscriptions = <StreamSubscription>[
      settingsState$.listen(print),
      settingsState$.connect(),
    ];

    return SettingBloc._(
      changeThemeController.add,
      changeLocaleController.add,
      settingsState$,
      () async {
        ///
        /// Cancel stream subscriptions
        ///
        await Future.wait(subscriptions.map((s) => s.cancel()));

        ///
        /// And then, close stream controllers
        ///
        await Future.wait([
          changeThemeController,
          changeLocaleController,
        ].map((c) => c.close()));
      },
    );
  }

  @override
  void dispose() => _dispose();
}
