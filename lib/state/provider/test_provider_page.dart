import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counter_model.dart';
import 'provider_page.dart';

class TestProviderPage extends StatelessWidget {
  final counter = CounterModel();
  final textSize = 48;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: textSize),
        ChangeNotifierProvider.value(value: counter),
      ],
      child: ProviderPage(),
    );
    /*Provider<int>.value(
      value: 48,
      child: ChangeNotifierProvider.value(
        value: counter,
        child: ProviderPage(),
      ),
    );*/
  }
}
