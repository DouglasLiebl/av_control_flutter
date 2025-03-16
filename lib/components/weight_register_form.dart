import 'package:demo_project/data/secure_storage_service.dart';
import 'package:demo_project/utils/default_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WeightRegisterForm extends StatefulWidget {
  final TextEditingController weightController;
  final TextEditingController unitController;
  final TextEditingController boxController;
  final TextEditingController tareController;
  final Function onPress;

  const WeightRegisterForm({
    super.key,
    required this.weightController,
    required this.unitController,
    required this.boxController,
    required this.tareController,
    required this.onPress,
  });

  @override
  State<WeightRegisterForm> createState() => _WeightRegisterFormState();

}

class _WeightRegisterFormState extends State<WeightRegisterForm> {
  final storage = SecureStorageService(storage: FlutterSecureStorage());

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
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Novo Registro de Peso",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
                          "Peso (kg)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: widget.weightController, 
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
                          controller: widget.unitController, 
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
                      child: DropdownButtonFormField<String>( 
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
                            widget.boxController.text = value;
                          }
                        },
                        style: TextStyle(
                          fontSize: 16,
                          color: DefaultColors.valueGray(),
                        ),
                        hint: Text(
                          "Selecione um box", 
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                        dropdownColor: Colors.white,
                        isExpanded: true,
                        value: null,
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
                              fontWeight: FontWeight.bold
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
                          Text(
                          "Peso da Tara (kg)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: widget.tareController, 
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
                            ),
                          ),
                          Text(
                            "Peso da caixa vazia que será descontado do peso total.",
                            style: TextStyle(
                              color: DefaultColors.subTitleGray(),
                              fontSize: 12,
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
                              fontSize: 15
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ),
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
                  if (isTareEnabled) {
                    storage.setItem("Tare", widget.tareController.text);
                    setState(() {
                      isTareEnabled = false;
                    });
                  }


                  widget.onPress();
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
    );
  }
}