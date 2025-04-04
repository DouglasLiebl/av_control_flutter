import 'package:demo_project/presentation/provider/data_provider.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/views/login.dart';
import 'package:demo_project/presentation/views/register_aviary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: DefaultColors.bgGray(),
          appBar: AppBar(
            backgroundColor: DefaultColors.bgGray(),
            title: Text("Opções")
          ),
          body: Column(
            children: [
              Card(
                color: DefaultColors.bgGray(),
                elevation: 0,
                child: ListTile(
                  leading: Icon(Icons.add_outlined),
                  title: Text("Adicionar aviário"),
                  subtitle: Text("Registrar um novo aviário à conta"),
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => RegisterAviary()),
                    );
                  }
                )
              ),
              Card(
                color: DefaultColors.bgGray(),
                elevation: 0,
                child: ListTile(
                  leading: Icon(Icons.logout_outlined),
                  title: Text("Sair"),
                  subtitle: Text("Desconectar deste dispositivo"),
                  onTap: () {
                    provider.logout();
                    Navigator.pushAndRemoveUntil(
                      context, 
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false  
                    );
                  }
                )
              )
            ],
          )
        );
      }
    );
  }

}