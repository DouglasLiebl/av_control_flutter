import 'package:demo_project/presentation/widgets/register_cards/weight_register_form.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
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
                      "Nova Pesagem",
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
                      "Clique em iniciar registro para iniciar um novo registro de pesos.",
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
    TextEditingController tareController,
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
        child: WeightRegisterForm(
          weightController: weightController, 
          unitController: unitController, 
          boxController: boxController, 
          tareController: tareController, 
          onPress: onPress
        )
      ) 
    );
  }

}

