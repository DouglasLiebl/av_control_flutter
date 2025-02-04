import 'package:demo_project/context/data_provider.dart';
import 'package:demo_project/utils/default_colors.dart';
import 'package:demo_project/views/home.dart';
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


  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, provider, child) {
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
                                controller: _nameController,
                                cursorColor: Colors.black,
                                style: TextStyle(
                                  fontSize: 16, // Change font size
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
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
                                controller: _aliasController,
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
                                onPressed: () async {
                                  try {
                                    await provider.registerAviary(
                                      _nameController.text, 
                                      _aliasController.text
                                    );

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const HomePage())  
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString()))
                                    );
                                  }
                                }, 
                                child: Text(
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
    );
  }
}