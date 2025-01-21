import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demo_project/main.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SecondPage"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Here"),
            ElevatedButton(
              onPressed: () {
                // Access the Counter through Provider and increment
                Provider.of<Counter>(context, listen: false).increment();
              },
              child: Text('Increment Counter'),
            ),
          ],
        ),
      ),
    );
  }
}