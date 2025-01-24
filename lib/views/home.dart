import 'package:demo_project/context/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exemplo de Provider"),
              
      ),
      body: Center(
        child: Consumer<DataProvider>(
          builder: (context, provider, child) {
            return Text('Contador: ${provider.getAccount.aviaries.length}');
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.navigate_next),
        onPressed: () {},
      ),
    );
  }
}