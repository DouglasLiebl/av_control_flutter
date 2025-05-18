import 'package:demo_project/presentation/widgets/buttons/custom_button.dart';
import 'package:demo_project/presentation/widgets/register_cards/weight_register_form.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/widgets/text/card_description.dart';
import 'package:demo_project/presentation/widgets/text/card_title.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WeightRegisterCards {

  static Card startRegister(
    AsyncCallback onPress
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
                  CardTitle(
                    text: "Nova Pesagem"
                  ),
                  CardDescription(
                    text: "Clique em iniciar registro para iniciar um novo registro de pesos."
                  ),
                  SizedBox(height: 16),
                  CustomButton(
                    description: "Iniciar Registro", 
                    isLoading: false, 
                    onPress: onPress
                  )
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
    Function onPress,
    FocusNode weightFocus,
    FocusNode unitsFocus,
    FocusNode tareFocus,
    bool isLoading
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
          onPress: onPress,
          weightFocus: weightFocus,
          unitsFocus: unitsFocus,
          tareFocus: tareFocus,
          isLoading: isLoading
        )
      ) 
    );
  }

}

