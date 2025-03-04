import 'package:demo_project/context/allotment_provider.dart';
import 'package:demo_project/context/data_provider.dart';
import 'package:demo_project/models/aviary.dart';
import 'package:demo_project/models/mortality.dart';
import 'package:demo_project/utils/date_formater.dart';
import 'package:demo_project/utils/default_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MortalityDetails extends StatelessWidget {
  final Aviary aviary;
  final VoidCallback onRefresh;

  MortalityDetails({
    super.key, 
    required this.aviary,
    required this.onRefresh,
  });

  final _deathsController = TextEditingController();
  final _eliminationsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final allotmentProvider = context.read<AllotmentProvider>();
    final provider = context.read<DataProvider>();

    final mock = [
      Mortality(
        id: "flskadfjsl", 
        allotmentId: "lfjkladjflks", 
        age: 1, 
        deaths: 222, 
        eliminations: 33, 
        createdAt: "23/02/2025"
      ),
      Mortality(
        id: "flskadfjsl", 
        allotmentId: "lfjkladjflks", 
        age: 1, 
        deaths: 2, 
        eliminations: 13, 
        createdAt: "23/02/2025"
      ),
      Mortality(
        id: "flskadfjsl", 
        allotmentId: "lfjkladjflks", 
        age: 1, 
        deaths: 2, 
        eliminations: 13, 
        createdAt: "23/02/2025"
      ),
      Mortality(
        id: "flskadfjsl", 
        allotmentId: "lfjkladjflks", 
        age: 1, 
        deaths: 2, 
        eliminations: 13, 
        createdAt: "23/02/2025"
      ),
      Mortality(
        id: "flskadfjsl", 
        allotmentId: "lfjkladjflks", 
        age: 1, 
        deaths: 2, 
        eliminations: 13, 
        createdAt: "23/02/2025"
      ),
      Mortality(
        id: "flskadfjsl", 
        allotmentId: "lfjkladjflks", 
        age: 1, 
        deaths: 2, 
        eliminations: 13, 
        createdAt: "23/02/2025"
      ),
      Mortality(
        id: "flskadfjsl", 
        allotmentId: "lfjkladjflks", 
        age: 1, 
        deaths: 2, 
        eliminations: 13, 
        createdAt: "23/02/2025"
      ),Mortality(
        id: "flskadfjsl", 
        allotmentId: "lfjkladjflks", 
        age: 1, 
        deaths: 2, 
        eliminations: 13, 
        createdAt: "23/02/2025"
      )
    ];

    return SafeArea(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
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
                                  "Novo Registro",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Mortes",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: _deathsController,  // Create a new controller for deaths
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
                                          "Eliminações",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: _eliminationsController,  // Create a new controller for eliminations
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
                                  onRefresh();
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
              ),
              SizedBox(height: 16),
              // Registers
              Card(
                color: Colors.white,
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: DefaultColors.borderGray(),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8)
                  )
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Registros de Mortalidade",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                        ),
                      ),
                    ],
                  ),
                ) 
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: mock.length,
                itemBuilder: (context, index) {
                  
                  final history = mock[index];

                  if (!((mock.length - 1) == index)) {
                    return Card(
                      color: Colors.white,
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        side: BorderSide.none, // No border for the whole shape
                        borderRadius: BorderRadius.zero,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: DefaultColors.borderGray(),
                              width: 1,
                            ),
                            left: BorderSide(
                              color: DefaultColors.borderGray(),
                              width: 1,
                            ),
                            right: BorderSide(
                              color: DefaultColors.borderGray(),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Data: ${history.createdAt}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "Idade: ${history.age}",
                                          style: TextStyle(
                                            color: DefaultColors.textGray(),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "Mortes: ${history.deaths}",
                                          style: TextStyle(
                                            color: DefaultColors.textGray(),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "Eliminações: ${history.eliminations}",
                                          style: TextStyle(
                                            color: DefaultColors.textGray(),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(Icons.edit_note_outlined)
                                  ],
                                ),

                              )
                            ],
                          )
                        ),
                      ),
                    );
                  } else {
                    return Card(
                      color: Colors.white,
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: DefaultColors.borderGray(),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8)
                        )
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Data: ${history.createdAt}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "Idade: ${history.age}",
                                          style: TextStyle(
                                            color: DefaultColors.textGray(),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "Mortes: ${history.deaths}",
                                          style: TextStyle(
                                            color: DefaultColors.textGray(),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "Eliminações: ${history.eliminations}",
                                          style: TextStyle(
                                            color: DefaultColors.textGray(),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(Icons.edit_note_outlined)
                                  ],
                                ),
                            ),
                          ],
                        )
                      ) 
                    );
                  }
                  
                }
    
              
              )

            ],
          ),
        ),
      )
    );
  }
}