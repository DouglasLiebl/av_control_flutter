import 'package:demo_project/components/loading.dart';
import 'package:demo_project/utils/default_colors.dart';
import 'package:flutter/material.dart';

class WaterRegisterCards {

  static Card firstRegisterCard(
    BuildContext context,
    TextEditingController multiplierController, 
    TextEditingController measureController,
    Function onPress
  ) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: DefaultColors.borderGray(),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Novo Registro de Água",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 12,),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Parece que este é o primeiro registro deste aviário, será necessário registrar o multiplicador do seu hidrômetro pela primeira esta vez. \nExemplo: cada giro são do hidrometro valem 1000 litros. Multiplicador = 1000",
                      style: TextStyle(
                        color: DefaultColors.subTitleGray(),
                        fontSize: 15
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Multiplicador",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: multiplierController, 
                              cursorColor: DefaultColors.valueGray(),
                              style: TextStyle(
                                fontSize: 16,
                                color: DefaultColors.valueGray(),
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
                                prefixIcon: Icon(Icons.calculate_outlined, size: 28, color: DefaultColors.subTitleGray(),)
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Valor do Hidrômetro",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: measureController,
                              cursorColor: DefaultColors.valueGray(),
                              style: TextStyle(
                                fontSize: 16,
                                color: DefaultColors.valueGray(),
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
                                prefixIcon: Icon(Icons.pin_outlined, size: 28, color: DefaultColors.subTitleGray(),)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(DefaultColors.valueGray()),
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

                      Loading.getLoading(context);

                      await onPress();

                      if (!context.mounted) return;
                      Navigator.pop(context);
                    }, 
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white,),
                        SizedBox(width: 16),
                        Text(
                          "Adicionar Registro",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        )
                      ],
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ) 
    );
  }

  static Card registerCard(
    BuildContext context,
    TextEditingController measureController,
    bool isFistAllotmentRegister,
    Function onPress
  ) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: DefaultColors.borderGray(),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Novo Registro de Água",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  isFistAllotmentRegister
                  ? Column(
                      children: [
                        SizedBox(height: 12),
                        Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Insira o ponto de partida do seu hidrômetro",
                          style: TextStyle(
                            color: DefaultColors.subTitleGray(),
                            fontSize: 15
                          ),
                          textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 12),
                      ],
                    )
                  : SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Valor do Hidrômetro",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: measureController,
                        cursorColor: DefaultColors.valueGray(),
                        style: TextStyle(
                          fontSize: 16,
                          color: DefaultColors.valueGray(),
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
                          prefixIcon: Icon(Icons.pin_outlined, size: 28, color: DefaultColors.subTitleGray(),)
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(DefaultColors.valueGray()),
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
                      
                      Loading.getLoading(context);

                      await onPress();

                      if (!context.mounted) return;
                      Navigator.pop(context);
                    }, 
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white,),
                        SizedBox(width: 16),
                        Text(
                          "Adicionar Registro",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        )
                      ],
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ) 
    );
  }

}

