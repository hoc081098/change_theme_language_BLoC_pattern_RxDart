import 'dart:async';

import 'package:change_theme_language_bloc/generated/i18n.dart';
import 'package:change_theme_language_bloc/pages/home/home_bloc.dart';
import 'package:change_theme_language_bloc/pages/home/home_state.dart';
import 'package:change_theme_language_bloc/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_subscription == null) {
      _subscription = BlocProvider.of<HomeBloc>(context).error$.listen((e) {
        print('[HOMEPAGE] error=$e');
        _scaffoldKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final homeBloc = BlocProvider.of<HomeBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(s.home_page_title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: s.settings_page_title,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(),
          child: StreamBuilder<HomeList>(
            stream: homeBloc.state$,
            initialData: homeBloc.state$.value,
            builder: (context, snapshot) {
              final children = <Widget>[const MyReposList()];
              if (snapshot.data.isLoading) {
                children.add(
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Stack(children: children);
            },
          ),
        ),
      ),
    );
  }
}

class MyReposList extends StatelessWidget {
  const MyReposList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);

    return Positioned.fill(
      child: StreamBuilder<HomeList>(
        stream: homeBloc.state$,
        initialData: homeBloc.state$.value,
        builder: (context, snapshot) {
          return RefreshIndicator(
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                final repo = snapshot.data.repos[index];
                return ListTile(
                  onTap: () async {
                    if (await canLaunch(repo.url)) {
                      await launch(
                        repo.url,
                        enableJavaScript: true,
                      );
                    }
                  },
                  title: Text(repo.name),
                  subtitle: Column(
                    children: <Widget>[
                      Text(repo.description),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.update,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${S.of(context).updated_at}${repo.updatedAt}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Theme.of(context).accentColor,
                          ),
                          Text('${repo.stargazersCount}'),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.share,
                            color: Theme.of(context).accentColor,
                          ),
                          Text('${repo.forksCount}'),
                        ],
                      )
                    ],
                  ),
                );
              },
              itemCount: snapshot.data.repos.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
            onRefresh: homeBloc.fetchMyRepos,
          );
        },
      ),
    );
  }
}
