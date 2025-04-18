import 'package:demo_project/infra/factory/service_factory.dart';
import 'package:demo_project/main.dart';
import 'package:demo_project/presentation/provider/account_provider.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/views/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _showPassword = false; 

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.read<AccountProvider>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: DefaultColors.bgGray()
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Bem-vindo de volta",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            "Insira seu email abaixo para acessar sua conta",
                            style: TextStyle(
                              color: DefaultColors.subTitleGray(),
                              fontSize: 15
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Email",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          TextFormField(
                            enabled: _isLoading ? false : true,
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            cursorColor: Colors.black,
                            style: TextStyle(
                              fontSize: 16, // Change font size
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: "exemplo@email.com",
                              hintStyle: TextStyle(
                                color: DefaultColors.textGray(),
                                fontSize: 14,
                              ), 
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 128, 126, 126),
                                  width: 3.0,
                                )
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 194, 189, 189)
                                )
                              ),
                              prefixIcon: Icon(Icons.email_outlined, color: DefaultColors.subTitleGray()),
                            ),
                          ),
                          SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Senha",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          TextFormField(
                            enabled: _isLoading ? false : true,
                            controller: _passwordController,
                            obscureText: !_showPassword,
                            cursorColor: Colors.black,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 128, 126, 126),
                                  width: 3.0, 
                                )
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 194, 189, 189)
                                )
                              ),
                              prefixIcon: Icon(Icons.key_outlined, color: DefaultColors.subTitleGray()),
                              suffixIcon: IconButton(  
                                icon: Icon(
                                  _showPassword ? Icons.visibility : Icons.visibility_off,
                                  color: DefaultColors.subTitleGray(),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.black),
                              minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                                ),
                              ),
                              elevation: MaterialStateProperty.all(5),
                              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.grey.withOpacity(0.2);
                                  }
                                  return null;
                                },
                              ),
                            ),
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              _isLoading = true;

                              try {
                                await accountProvider.login(
                                  _emailController.text, 
                                  _passwordController.text
                                );

                                if (!context.mounted) return;
                                _isLoading = false;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomePage(syncService: getIt<ServiceFactory>().getSyncService()))  
                                );
                              } catch (e) {
                                _isLoading = false;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString()))
                                );
                              }
                            }, 
                            child: _isLoading
                            ? SizedBox(
                              height: 22,
                              width: 22, 
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                            : Text(
                              "Entrar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(height: 2),
                          TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return const Color.fromARGB(255, 201, 177, 177).withOpacity(0.2);
                                  }
                                  return null;
                                },
                              ),
                            ),
                            child: Text(
                              "Esqueceu sua senha?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              )
                            ),
                          ),
                          SizedBox(height: 4,),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: DefaultColors.subTitleGray(),
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "OU ENTÃO",
                                  style: TextStyle(
                                    color: DefaultColors.subTitleGray(),
                                    fontSize: 15
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: DefaultColors.subTitleGray(),
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.grey.withOpacity(0.2);
                                  }
                                  return null;
                                },
                              ),
                            ),
                            child: Text(
                              "Registre-se",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              )
                            ),
                          )
                        ],
                      ),
                    ),
                  ]
                ),
              ),
            ),
          ),
        )
      )
    );
  }
}