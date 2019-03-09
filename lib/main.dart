import 'package:change_theme_language_bloc/data/api.dart';
import 'package:change_theme_language_bloc/data/local_data_source_impl.dart';
import 'package:change_theme_language_bloc/data/setting_constants.dart';
import 'package:change_theme_language_bloc/generated/i18n.dart';
import 'package:change_theme_language_bloc/pages/home/home_bloc.dart';
import 'package:change_theme_language_bloc/pages/home/home_page.dart';
import 'package:change_theme_language_bloc/pages/settings/setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';

void main() {
  final api = Api(MockClient());
  final settingConstants = SettingConstants();
  final localDataSource = LocalDataSourceImpl(settingConstants);
  final settingBloc = SettingBloc(localDataSource);

  runApp(
    BlocProvider<SettingConstants>(
      initBloc: () => settingConstants,
      child: BlocProvider<SettingBloc>(
        initBloc: () => settingBloc,
        child: BlocProvider<HomeBloc>(
          initBloc: () => HomeBloc(api)..fetchMyRepos(),
          child: MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var settingBloc = BlocProvider.of<SettingBloc>(context);

    return StreamBuilder<SettingModel>(
      stream: settingBloc.setting$,
      initialData: settingBloc.setting$.value,
      builder: (context, snapshot) {
        print('MyApp $snapshot');

        if (!snapshot.hasData) {
          return Container();
        }
        return MaterialApp(
          onGenerateTitle: (context) => S.of(context).app_title,
          supportedLocales: S.delegate.supportedLocales,
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: S.delegate.resolution(
            fallback: const Locale('en', ''),
          ),
          locale: snapshot.data.localeModel.locale,
          theme: snapshot.data.themeModel.themeData,
          home: const HomePage(),
        );
      },
    );
  }
}
