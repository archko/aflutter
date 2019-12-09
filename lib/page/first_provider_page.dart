import 'package:AFlutter/state/test_provider_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class FirstProviderPage extends StatefulWidget {
  FirstProviderPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new FirstProviderPageState();
  }
}

class FirstProviderPageState extends State<FirstProviderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test provider"),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(builder: (_) => CounterProvider()),
          ChangeNotifierProvider(builder: (_) => ValProvider()),
        ],
        child: Column(
          children: <Widget>[
            Consumer<CounterProvider>(
              builder: (context, counterProvider, _) {
                print('Text1重绘了。。。。。。');
                return Column(
                  children: <Widget>[
                    Text(
                      'Text1 : ${counterProvider.value}',
                      style: TextStyle(fontSize: 20),
                    ),
                    RaisedButton(
                      onPressed: () {
                        counterProvider.increment();
                      },
                      child: Text('Button1'),
                    ),
                  ],
                );
              },
            ),
            Consumer<ValProvider>(
              builder: (context, valProvider, _) {
                print('Text2重绘了。。。。。。');
                return Column(
                  children: <Widget>[
                    Text(
                      'Text1 : ${valProvider.value}',
                      style: TextStyle(fontSize: 20),
                    ),
                    RaisedButton(
                      onPressed: () {
                        valProvider.increment();
                      },
                      child: Text('Button2'),
                    ),
                  ],
                );
              },
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                  new MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return TestProviderPage();
                    },
                  ),
                );
              },
              child: Text('test provider list'),
            ),
          ],
        ),
      ),
    );
  }
}

class CounterProvider with ChangeNotifier {
  int _count = 0;

  int get value => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

class ValProvider with ChangeNotifier {
  int _count = 0;

  int get value => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}
