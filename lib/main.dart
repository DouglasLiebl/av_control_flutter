import 'package:demo_project/data/database_helper.dart';
import 'package:demo_project/second.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Counter with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  int _count = 0;
  
  Counter() {
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    _count = await _dbHelper.getCount();
    notifyListeners();
  }

  int get count => _count;

  Future<void> increment() async {
    _count++;
    await _dbHelper.updateCount(_count);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exemplo de Provider"),
              
      ),
      body: Center(
        child: Consumer<Counter>(
          builder: (context, counter, child) {
            return Text('Contador: ${counter.count}');
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.navigate_next),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondPage()),
          );
        },
      ),
    );
  }
}