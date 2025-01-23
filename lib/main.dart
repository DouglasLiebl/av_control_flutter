import 'package:demo_project/data/database_helper.dart';
import 'package:demo_project/data/server_service.dart';
import 'package:demo_project/models/account.dart';
import 'package:demo_project/models/auth.dart';
import 'package:demo_project/views/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Counter with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ServerService _serverService = ServerService();
  Account _account = Account(
        id: '',
        firstName: '',
        lastName: '',
        email: '',
        aviaries: [],
        authData: Auth(
          accountId: '',
          accessToken: '',
          tokenType: '',
          refreshToken: '',
          accessTokenExpiration: '',
        ),
      );
  
  Counter() {
    _loadContext();
  }

  Account get getAccount => _account;  

  Future<void> _loadContext() async {
    _account = _dbHelper.getContext() as Account;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      // Get account from server
      Account response = await _serverService.login(email, password);
      
      // Save to SQLite
      await _dbHelper.registerAccountData(response);
      
      // Update local state
      _account = response;
      
      // Notify listeners
      notifyListeners();
    } catch (e) {
      throw Exception('Login failed: $e');
    }
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
      home: Consumer<Counter>(
        builder: (context, counter, child) {
          return FutureBuilder<Account>(
            future: counter._dbHelper.getContext(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              
              if (snapshot.hasData && snapshot.data?.id != '') {
                return HomePage();
              } else {
                print("Here ${snapshot.data}");
                return LoginPage();
              }
            },
          );
        }
      ),
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
            return Text('Contador: ${counter.getAccount}');
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