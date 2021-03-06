import 'package:AFlutter/redux/theme_reducer.dart';
import 'package:AFlutter/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ThemeReduxPage extends StatefulWidget {
  ThemeReduxPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ThemeReduxPageState();
  }

  @override
  String toStringShort() {
    return "Theme";
  }
}

class ThemeReduxPageState extends State<ThemeReduxPage> {
  @override
  void initState() {
    super.initState();
  }

  List<MaterialColor> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.cyan,
    Colors.purple
  ];
  int index = 0;

  @override
  void didUpdateWidget(ThemeReduxPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget:$this");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies:$this");
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ThemeModel>(
      converter: (store) {
        return ThemeModel(store.state.themeData);
      },
      builder: (BuildContext context, ThemeModel vm) {
        return Scaffold(
          appBar: AppBar(title: Text('Flutter redux')),
          body: Center(
            child: RaisedButton(
              onPressed: () {
                changeTheme();
              },
              child: Text("change theme"),
            ),
          ),
        );
      },
    );
  }

  void changeTheme() {
    if (index >= colors.length) {
      index = 0;
    }
    StoreProvider.of<AppState>(context).dispatch(RefreshThemeDataAction(
        ThemeData(
            primarySwatch: colors[index++], platform: TargetPlatform.android)));
  }
}

class ThemeModel {
  ThemeData themeData;

  ThemeModel(this.themeData);
}
