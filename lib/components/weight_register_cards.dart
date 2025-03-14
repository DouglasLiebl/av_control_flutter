import 'package:demo_project/utils/default_colors.dart';
import 'package:flutter/material.dart';

class WeightRegisterCards {

  static Card startRegister(
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
                      "Novo Registro de Peso",
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
                      "Clique em adicionar registro para iniciar um novo registro de pesos.",
                      style: TextStyle(
                        color: DefaultColors.subTitleGray(),
                        fontSize: 15
                      ),
                      textAlign: TextAlign.left,
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
                      await onPress();
                    }, 
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white,),
                        SizedBox(width: 16),
                        Text(
                          "Iniciar Registro",
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
    TextEditingController weightController,
    TextEditingController unitController,
    TextEditingController boxController,
    Function onPress
  ) {

    boxController.text = "1";
    
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
                      "Novo Registro de Peso",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
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
                              "Peso",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: weightController, 
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
                                prefixIcon: Icon(Icons.balance_outlined, size: 28, color: DefaultColors.subTitleGray())
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
                              "Quantidade",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: unitController, 
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
                                prefixIcon: Icon(Icons.format_list_numbered_outlined, size: 28, color: DefaultColors.subTitleGray())
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selecione o Box",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField( 
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
                              prefixIcon: Icon(
                                Icons.inventory_2_outlined,  // Icon for box selection
                                size: 28,
                                color: DefaultColors.subTitleGray()
                              ),
                            ),
                            onChanged: (String? value) {
                              if (value != null) {
                                boxController.text = value;
                              }
                            },
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            dropdownColor: Colors.white,
                            isExpanded: true,
                            value: "1",
                            items: [
                              DropdownMenuItem(
                                value: "1",
                                child: Text("Box 1", style: TextStyle(fontSize: 16)),
                              ),
                              DropdownMenuItem(
                                value: "2",
                                child: Text("Box 2", style: TextStyle(fontSize: 16)),
                              ),
                              DropdownMenuItem(
                                value: "3",
                                child: Text("Box 3", style: TextStyle(fontSize: 16)),
                              ),
                              DropdownMenuItem(
                                value: "4",
                                child: Text("Box 4", style: TextStyle(fontSize: 16)),
                              ),
                            ],
                          )
                        ) 
                      ),
                    ],
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
                      await onPress();
                    }, 
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white,),
                        SizedBox(width: 16),
                        Text(
                          "Adicionar",
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

