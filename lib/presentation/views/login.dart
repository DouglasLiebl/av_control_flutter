import 'package:demo_project/infra/factory/service_factory.dart';
import 'package:demo_project/main.dart';
import 'package:demo_project/presentation/provider/account_provider.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/style/default_typography.dart';
import 'package:demo_project/presentation/views/home.dart';
import 'package:demo_project/presentation/widgets/buttons/custom_button.dart';
import 'package:demo_project/presentation/widgets/inputs/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final bool _isLoading = false;

  Future<void> login() async {
    final accountProvider = context.read<AccountProvider>();
    FocusScope.of(context).unfocus();

    try {
      await accountProvider.login(
        _emailController.text, 
        _passwordController.text
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(syncService: getIt<ServiceFactory>().getSyncService()))  
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()))
      );
    }
  }

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
                          SvgPicture.asset(
                            "assets/svg/icon.svg",
                            height: 160,
                            width: 160,
                          ),
                          Text(
                            "Bem-vindo de volta",
                            style: DefaultTypography.loginTitle()
                          ),
                          Text(
                            "Insira seu email abaixo para acessar sua conta",
                            style: DefaultTypography.loginDescription(),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          CustomInputField(
                            label: "Email",
                            hintText: "email@email.com",
                            keyboardType: TextInputType.emailAddress, 
                            controller: _emailController, 
                            isLoading: _isLoading, 
                            focusNode: _emailFocus,
                            onSubmit: () => Focus.of(context).requestFocus(_passwordFocus),
                            prefixIcon: Icon(Icons.email_outlined, color: DefaultColors.subTitleGray()),
                          ),
                          SizedBox(height: 6),
                          CustomInputField(
                            label: "Senha",
                            keyboardType: TextInputType.text, 
                            controller: _passwordController, 
                            isLoading: _isLoading, 
                            isPassword: true,
                            focusNode: _passwordFocus,
                            onSubmit: () => Focus.of(context).unfocus(),
                            prefixIcon: Icon(Icons.key_outlined, color: DefaultColors.subTitleGray()),
                          ),
                          SizedBox(height: 16),
                          CustomButton(
                            description: "Entrar",
                            isLoading: accountProvider.isLoading,
                            onPress:  () async => await login(),
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