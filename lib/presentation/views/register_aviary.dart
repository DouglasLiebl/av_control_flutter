import 'package:demo_project/infra/factory/service_factory.dart';
import 'package:demo_project/main.dart';
import 'package:demo_project/presentation/provider/account_provider.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/style/default_typography.dart';
import 'package:demo_project/presentation/views/home.dart';
import 'package:demo_project/presentation/widgets/buttons/custom_button.dart';
import 'package:demo_project/presentation/widgets/inputs/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterAviary extends StatefulWidget {
  const RegisterAviary({super.key});
  
  @override
  State<StatefulWidget> createState() => _RegisterAviary();
}

class _RegisterAviary extends State<RegisterAviary> {
  final _nameController = TextEditingController();
  final _aliasController = TextEditingController();
  final _nameFocus = FocusNode();
  final _aliasFocus = FocusNode();

  @override
  void dispose() {
    _nameFocus.dispose();
    _aliasFocus.dispose();
    super.dispose();
  }

  Future<void> register() async {
    final accountProvider = context.read<AccountProvider>();
    FocusScope.of(context).unfocus();

    await accountProvider.registerAviary(
      _nameController.text.toUpperCase(), 
      _aliasController.text
    );

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage(syncService: getIt<ServiceFactory>().getSyncService())),
      (route) => false 
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.read<AccountProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Registro de aviário",
          style: DefaultTypography.appBar()  
        ),
        backgroundColor: DefaultColors.bgGray(),
      ),
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
                            "Atenção",
                            style: DefaultTypography.loginTitle()
                          ),
                          Text(
                            " Insira o nome do aviário presente nas notas no campo Nome e como deseja que seja aparente na página principal no campo Apelido.",
                            style: DefaultTypography.loginDescription(),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          CustomInputField(
                            controller: _nameController,
                            label: "Nome",
                            keyboardType: TextInputType.text,
                            isLoading: accountProvider.isLoading,
                            prefixIcon: Icon(Icons.person_outlined, color: DefaultColors.subTitleGray()),
                            hintText: "Ex: INTEGRADO CLIMATIZADO",
                            focusNode: _nameFocus,
                            onSubmit: () {
                              Focus.of(context).requestFocus(_aliasFocus);
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 6),
                          CustomInputField(
                            controller: _aliasController,
                            label: "Apelido",
                            keyboardType: TextInputType.text,
                            isLoading: accountProvider.isLoading,
                            prefixIcon: Icon(Icons.label_outline, color: DefaultColors.subTitleGray()),
                            hintText: "Ex: AV 01",
                            focusNode: _aliasFocus,
                            onSubmit: () {
                              Focus.of(context).unfocus();
                            },
                            textInputAction: TextInputAction.done,
                          ),
                          SizedBox(height: 16),
                          CustomButton(
                            description: "Salvar",
                            isLoading: accountProvider.isLoading,
                            onPress: () async => await register(),
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