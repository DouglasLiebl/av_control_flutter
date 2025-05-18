import 'package:demo_project/infra/third_party/local_storage/secure_storage.dart';
import 'package:demo_project/main.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/widgets/buttons/custom_button.dart';
import 'package:demo_project/presentation/widgets/dropdown/dropdown.dart';
import 'package:demo_project/presentation/widgets/dropdown/dropdown_item.dart';
import 'package:demo_project/presentation/widgets/inputs/custom_input_field.dart';
import 'package:demo_project/presentation/widgets/text/card_title.dart';
import 'package:flutter/material.dart';

class WeightRegisterForm extends StatefulWidget {
  final TextEditingController weightController;
  final TextEditingController unitController;
  final TextEditingController boxController;
  final TextEditingController tareController;
  final Function onPress;
  final FocusNode weightFocus;
  final FocusNode unitsFocus;
  final FocusNode tareFocus;
  final bool isLoading;

  const WeightRegisterForm({
    super.key,
    required this.weightController,
    required this.unitController,
    required this.boxController,
    required this.tareController,
    required this.onPress,
    required this.weightFocus,
    required this.unitsFocus,
    required this.tareFocus,
    required this.isLoading
  });

  @override
  State<WeightRegisterForm> createState() => _WeightRegisterFormState();

}

class _WeightRegisterFormState extends State<WeightRegisterForm> {
  final storage = getIt<SecureStorage>();

  bool isTareEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkTareStatus();
  }


  Future<void> _checkTareStatus() async {
    final tare = await storage.getItem("Tare");
    setState(() {
      isTareEnabled = tare == null || tare.isEmpty;
      if (tare != null && tare.isNotEmpty) {
        widget.tareController.text = tare;
      }
    });
  }

  Future<void> _finish() async {
    if (isTareEnabled) {
      storage.setItem("Tare", widget.tareController.text);
      setState(() {
        isTareEnabled = false;
      });
    }
    FocusScope.of(context).unfocus();
    await widget.onPress();
    if (!mounted) return;
    Navigator.of(context).pop();     
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white
          ),
          child: Column(
            children: [
              CardTitle(
                text: "Novo Registro de Peso"
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      label: "Peso (kg)",
                      hintText: "Ex: 12.020",
                      keyboardType: TextInputType.number, 
                      controller: widget.weightController, 
                      isLoading: widget.isLoading,
                      prefixIcon: Icon(Icons.balance_outlined, size: 28, color: DefaultColors.subTitleGray()),
                      focusNode: widget.weightFocus,
                      onSubmit: () => Focus.of(context).requestFocus(widget.unitsFocus),
                    )
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomInputField(
                      label: "Quantidade",
                      hintText: "Ex: 10",
                      keyboardType: TextInputType.number,
                      controller: widget.unitController,
                      isLoading: widget.isLoading,
                      focusNode: widget.unitsFocus,
                      onSubmit: () => Focus.of(context).unfocus(),
                      prefixIcon: Icon(Icons.format_list_numbered_outlined, size: 28, color: DefaultColors.subTitleGray()),
                    )
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
                      fontWeight: FontWeight.bold,
                      fontFamily: "JetBrains Mono"
                    ),
                  ),
                  SizedBox(height: 8),
                  Dropdown(
                    controller: widget.boxController, 
                    values: [
                      DropdownItem(value: "1", description: "Box 1"),
                      DropdownItem(value: "2", description: "Box 2"),
                      DropdownItem(value: "3", description: "Box 3"),
                      DropdownItem(value: "4", description: "Box 4")
                    ] 
                  )
                ],
              ),
              SizedBox(height: 16),
              Card(
                color: DefaultColors.subBox(),
                elevation: 0,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: DefaultColors.subBox(),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tara Personalizada",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "JetBrains Mono"
                            ),
                          ),
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: isTareEnabled,
                              activeColor: Colors.white,
                              activeTrackColor: DefaultColors.valueGray(),
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: DefaultColors.textGray(),
                              trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
                              onChanged: (bool value) {
                                setState(() {
                                  isTareEnabled = value;
                                });
                              },
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                                
                            ),
                          )
                        ],
                      ),
                      isTareEnabled
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomInputField(
                            label: "Valor da Tara (kg)", 
                            keyboardType: TextInputType.number, 
                            controller: widget.tareController, 
                            isLoading: widget.isLoading,
                            hintText: "Ex: 1.350",
                            focusNode: widget.tareFocus,
                            onSubmit: () => Focus.of(context).unfocus(),
                          ),
                          Text(
                            "Peso da caixa vazia que será descontado do peso total.",
                            style: TextStyle(
                              color: DefaultColors.subTitleGray(),
                              fontSize: 12,
                              fontFamily: "JetBrains Mono"
                            ),
                          )
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Usando a tara padrão: ${widget.tareController.text} kg",
                            style: TextStyle(
                              color: DefaultColors.textGray(),
                              fontSize: 15,
                              fontFamily: "JetBrains Mono"
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ),
              CustomButton(
                description: "Adicionar", 
                isLoading: widget.isLoading, 
                onPress: _finish
              )
            ],
          ),
        ),
      ],
    );
  }
}