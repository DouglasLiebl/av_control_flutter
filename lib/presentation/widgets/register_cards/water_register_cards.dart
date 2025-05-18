import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/widgets/buttons/custom_button.dart';
import 'package:demo_project/presentation/widgets/inputs/custom_input_field.dart';
import 'package:demo_project/presentation/widgets/text/card_description.dart';
import 'package:demo_project/presentation/widgets/text/card_title.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WaterRegisterCards {

  static Card firstRegisterCard(
    BuildContext context,
    TextEditingController multiplierController, 
    TextEditingController measureController,
    AsyncCallback onPress,
    bool isLoading,
    FocusNode multiplierFocus,
    FocusNode measureFocus
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
                    text: "Novo Registro de Água"
                  ),
                  CardDescription(
                    text: "Parece que este é o primeiro registro deste aviário, será necessário registrar o multiplicador do seu hidrômetro pela primeira esta vez. \nExemplo: cada giro são do hidrometro valem 1000 litros. Multiplicador = 1000"
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CustomInputField(
                          label: "Multiplicador",
                          hintText: "Ex: 1000",
                          keyboardType: TextInputType.number,
                          controller: multiplierController,
                          isLoading: isLoading,
                          focusNode: multiplierFocus,
                          onSubmit: () => Focus.of(context).requestFocus(measureFocus),
                          prefixIcon: Icon(Icons.calculate_outlined, size: 28, color: DefaultColors.subTitleGray())
                        )
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: CustomInputField(
                          label: "Valor do Hidrômetro",
                          isLoading: isLoading,
                          hintText: "Ex: 25215",
                          controller: measureController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icon(Icons.pin_outlined, size: 28, color: DefaultColors.subTitleGray()),
                          focusNode: measureFocus,
                          onSubmit: () => Focus.of(context).unfocus(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  CustomButton(
                    description: "Adicionar Registro",
                    isLoading: isLoading,
                    onPress: onPress,
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
    BuildContext context,
    TextEditingController measureController,
    bool isFistAllotmentRegister,
    AsyncCallback onPress,
    bool isLoading,
    FocusNode measureFocus
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
                    text: "Novo Registro de Consumo"
                  ),
                  isFistAllotmentRegister
                  ? CardDescription(
                    text: "Insira o ponto de partida do seu hidrômetro"
                  )
                  : CardDescription(
                    text: "Insira o valor do seu hidrômetro abaixo e pressione Adicionar Registro para salvar"
                  ),
                  CustomInputField(
                    label: "Valor do Hidrômetro",
                    hintText: "Ex: 32535",
                    keyboardType: TextInputType.number,
                    controller: measureController,
                    isLoading: isLoading,
                    focusNode: measureFocus,
                    onSubmit: () => Focus.of(context).unfocus(),
                    prefixIcon: Icon(Icons.pin_outlined, size: 28, color: DefaultColors.subTitleGray()),
                  ),
                  SizedBox(height: 16),
                  CustomButton(
                    description: "Adicionar Registro",
                    isLoading: isLoading,
                    onPress: onPress,                  
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

