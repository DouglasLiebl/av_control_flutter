import 'package:demo_project/context/data_provider.dart';
import 'package:demo_project/views/home.dart';
import 'package:demo_project/views/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DataProvider(),
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
      home: Consumer<DataProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<bool>(
            future: provider.dbHelper.hasLocalData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 4,
                      ),
                    )
                  )
                );
              }
              
              if (snapshot.hasData && snapshot.data == true) {
                return HomePage();
              } else {
                return LoginPage();
              }
            },
          );
        }
      ),
    );
  }
}
