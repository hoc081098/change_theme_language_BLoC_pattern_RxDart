import 'package:change_theme_language_bloc/generated/i18n.dart';
import 'package:change_theme_language_bloc/home_bloc.dart';
import 'package:change_theme_language_bloc/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var s = S.of(context);
    var homeBloc = BlocProvider.of<HomeBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.home_page_title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: s.settings_page_title,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
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
              print(snapshot);
              var data = snapshot.data;

              var children = <Widget>[const MyReposList()];
              if (data.isLoading) {
                children.add(const LoadingIndicator());
              }

              return Stack(children: children);
            },
          ),
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({Key key}) : super(key: key);

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      ),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class MyReposList extends StatelessWidget {
  const MyReposList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var homeBloc = BlocProvider.of<HomeBloc>(context);

    return Positioned.fill(
      child: StreamBuilder<HomeList>(
        stream: homeBloc.state$,
        initialData: homeBloc.state$.value,
        builder: (context, snapshot) {
          return RefreshIndicator(
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                var repo = snapshot.data.repos[index];
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
