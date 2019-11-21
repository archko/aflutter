import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counter_model.dart';

class ProviderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
      appBar: AppBar(
        title: Text('FirstPage'),
      ),
      body: Center(
        child: Text(
          'Value: ${_counter.value}',
          style: TextStyle(fontSize: textSize),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SecondPage(_counter, textSize.toInt()))),
        child: Icon(Icons.navigate_next),
      ),
    );*/
    return Scaffold(
      appBar: AppBar(title: Text('Counter')),
      body: Consumer2<CounterModel, int>(
        builder: (context, CounterModel counter, int textSize, _) => Center(
          child: Text(
            'Value: ${counter.value}',
            style: TextStyle(
              fontSize: textSize.toDouble(),
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Consumer2<CounterModel, int>(
              builder: (context, CounterModel counter, int textSize, _) =>
                  FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  counter.increment();
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Consumer2<CounterModel, int>(
              builder: (context, CounterModel counter, int textSize, _) =>
                  FloatingActionButton(
                child: Icon(Icons.remove),
                onPressed: () {
                  counter.decrement();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
