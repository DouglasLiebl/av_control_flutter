import 'package:demo_project/presentation/provider/account_provider.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/style/default_typography.dart';
import 'package:demo_project/presentation/views/login.dart';
import 'package:demo_project/presentation/views/register_aviary.dart';
import 'package:demo_project/presentation/widgets/menu/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final accountProvider = context.read<AccountProvider>();

    return Scaffold(
      backgroundColor: DefaultColors.bgGray(),
      appBar: AppBar(
        backgroundColor: DefaultColors.bgGray(),
        title: Text(
          "Opções",
          style: DefaultTypography.appBar()
        )
      ),
      body: Column(
        children: [
          Item(
            title: "Adicionar aviário",
            subtitle: "Registrar um novo aviário à conta",
            onPress: () async => await Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => RegisterAviary()),
            ),
            icon: Icon(Icons.add_outlined)
          ),
          Item(
            title: "Sair",
            subtitle: "Desconectar deste dispositivo",
            onPress: () async {
              await accountProvider.logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false  
              );
            },
            icon: Icon(Icons.logout_outlined),
          )
        ],
      )
    );
  }
}