import 'package:demo_project/infra/factory/service_factory.dart';
import 'package:demo_project/main.dart';
import 'package:demo_project/presentation/provider/account_provider.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/views/home.dart';
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

  bool _isLoading = false;

  @override
  void dispose() {
    _nameFocus.dispose();
    _aliasFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.read<AccountProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de aviário"),
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
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            " Insira o nome do aviário presente nas notas no campo Nome e como deseja que seja aparente na página principal no campo Apelido.",
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
                              "Nome",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          TextFormField(
                            enabled: _isLoading ? false : true,
                            controller: _nameController,
                            cursorColor: Colors.black,
                            focusNode: _nameFocus,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              Focus.of(context).requestFocus(_aliasFocus);
                            },
                            style: TextStyle(
                              fontSize: 16, // Change font size
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: "Ex: INTEGRADO CLIMATIZADO",
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
                                  color: const Color.fromARGB(255, 128, 126, 126), // Change color when focused
                                  width: 3.0, // Make border thicker when focused
                                )
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 194, 189, 189)
                                )
                              ),
                              prefixIcon: Icon(Icons.person_outline, color: DefaultColors.subTitleGray())
                            ),
                          ),
                          SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Apelido",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          TextFormField(
                            enabled: _isLoading ? false : true,
                            controller: _aliasController,
                            cursorColor: Colors.black,
                            focusNode: _aliasFocus,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              Focus.of(context).unfocus();
                            },
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: "Ex: AV 01",
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
                                  color: const Color.fromARGB(255, 128, 126, 126), // Change color when focused
                                  width: 3.0, // Make border thicker when focused
                                )
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 194, 189, 189)
                                )
                              ),
                              prefixIcon: Icon(Icons.label_outline, color: DefaultColors.subTitleGray())
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
                            onPressed: _isLoading ? null
                            : () async {
                              FocusScope.of(context).unfocus();
                              _isLoading = true;

                              await accountProvider.registerAviary(
                                _nameController.text.toUpperCase(), 
                                _aliasController.text
                              );

                              if (!context.mounted) return;
                              _isLoading = false;
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage(syncService: getIt<ServiceFactory>().getSyncService())),
                                (route) => false 
                              );
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
                              "Salvar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            )
                          ),
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