import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_1/screen/home_page.dart';
import 'counter_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => CounterProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}
