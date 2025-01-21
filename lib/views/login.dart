import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  // Define the custom colors from the palette
  final Color bgGray = Color(0xFFF3F4F6);
  final Color subTitleGray = Color.fromARGB(255, 107, 104, 104);

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: bgGray
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
                              color: subTitleGray,
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
                              prefixIcon: Icon(Icons.email_outlined, color: subTitleGray)
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
                            obscureText: true,
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
                              prefixIcon: Icon(Icons.key_outlined, color: subTitleGray)
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
                            onPressed: () {}, 
                            child: Text(
                              "Entrar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            )
                          ),
                          SizedBox(height: 2),
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
                                  color: subTitleGray,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "OU ENTÃO",
                                  style: TextStyle(
                                    color: subTitleGray,
                                    fontSize: 15
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: subTitleGray,
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