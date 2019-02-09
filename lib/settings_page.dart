import 'package:change_theme_language_bloc/generated/i18n.dart';
import 'package:change_theme_language_bloc/models.dart';
import 'package:change_theme_language_bloc/setting_bloc.dart';
import 'package:change_theme_language_bloc/setting_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.settings_page_title),
      ),
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: const <Widget>[
              ChangeThemeTile(),
              ChangeLanguageTile(),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeThemeTile extends StatelessWidget {
  const ChangeThemeTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingBloc = BlocProvider.of<SettingBloc>(context);
    var settingConstants = BlocProvider.of<SettingConstants>(context);
    var s = S.of(context);

    return StreamBuilder<SettingModel>(
      stream: settingBloc.setting$,
      initialData: settingBloc.setting$.value,
      builder: (context, snapshot) {
        return ListTile(
          title: Text(s.change_theme),
          subtitle: Text(snapshot.data.themeModel.name),
          trailing: Icon(Icons.color_lens),
          onTap: () async {
            final themeModel = await showDialog<ThemeModel>(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text(s.change_theme),
                  children: settingConstants.themes.map((theme) {
                    Text text = theme == snapshot.data.themeModel
                        ? Text(
                            theme.name,
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.5,
                            style: theme.themeData.textTheme.subhead.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : Text(
                            theme.name,
                            textAlign: TextAlign.center,
                            style: theme.themeData.textTheme.subhead,
                          );

                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            theme.themeData.primaryColorLight,
                            theme.themeData.primaryColor,
                            theme.themeData.primaryColorDark,
                          ],
                          begin: AlignmentDirectional.topStart,
                          end: AlignmentDirectional.bottomEnd,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.pop(context, theme),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 24.0,
                            ),
                            child: Center(
                              child: text,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            );
            if (themeModel != null) {
              settingBloc.changeTheme(themeModel);
            }
          },
        );
      },
    );
  }
}

class ChangeLanguageTile extends StatelessWidget {
  const ChangeLanguageTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingBloc = BlocProvider.of<SettingBloc>(context);
    var settingConstants = BlocProvider.of<SettingConstants>(context);
    var s = S.of(context);

    return StreamBuilder<SettingModel>(
      stream: settingBloc.setting$,
      initialData: settingBloc.setting$.value,
      builder: (context, snapshot) {
        return ListTile(
          title: Text(s.change_language),
          subtitle: Text(snapshot.data.localeModel.title),
          trailing: Icon(Icons.language),
          onTap: () async {
            final localeModel = await showDialog<LocaleModel>(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text(s.change_language),
                  children: settingConstants.locales.map((locale) {
                    return SimpleDialogOption(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.asset(
                            locale.icon,
                            scale: 1,
                            fit: BoxFit.cover,
                          ),
                        ),
                        selected: locale == snapshot.data.localeModel,
                        title: Text(locale.title),
                      ),
                      onPressed: () => Navigator.pop(context, locale),
                    );
                  }).toList(),
                );
              },
            );
            if (localeModel != null) {
              settingBloc.changeLocale(localeModel);
            }
          },
        );
      },
    );
  }
}
