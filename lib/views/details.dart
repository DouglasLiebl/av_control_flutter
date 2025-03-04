import 'package:demo_project/context/allotment_provider.dart';
import 'package:demo_project/context/data_provider.dart';
import 'package:demo_project/models/aviary.dart';
import 'package:demo_project/utils/default_colors.dart';
import 'package:demo_project/views/details_views/general_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  final Aviary aviary;
  
  const DetailsPage({super.key, required this.aviary});
  
  @override
  State<StatefulWidget> createState() => _DetailsPage();

}

class _DetailsPage extends State<DetailsPage> {
  int _selectedIndex = 0;
  final _initialBirdsController = TextEditingController();

  
  List<Widget> _pages(BuildContext context) => [
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Este aviário não possui um lote ativo no momento."),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: DefaultColors.bgGray(),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Registro de lote",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        "Insira o total de aves abaixo",
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
                          "Total de aves",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _initialBirdsController,
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
                          prefixIcon: Icon(Icons.numbers_outlined, color: DefaultColors.subTitleGray())
                        ),
                      )
                    ],
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                              minimumSize: MaterialStateProperty.all(Size(150, 50)),
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
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Cancelar",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            )
                          ),
                        ),
                        SizedBox(width: 16), // Add spacing between buttons
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.black),
                              minimumSize: MaterialStateProperty.all(Size(150, 50)),
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
                              final allotmentProvider = context.read<AllotmentProvider>();
                              final provider = context.read<DataProvider>();
                              
                              await allotmentProvider.registerAllotment(
                                provider.getAccount.authData,
                                widget.aviary.id,
                                int.parse(_initialBirdsController.text)
                              );
                            
                              provider.updateActiveAllotmentId(widget.aviary.id, allotmentProvider.getAllotment.id);
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Confirmar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            )
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            );
          } , 
          child: Text("Iniciar lote")
        )
      ],
    )
  
  ];

  void _onSelect(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    final allotmentProvider = context.read<AllotmentProvider>();

    return Scaffold(
      backgroundColor: DefaultColors.bgGray(),
      appBar: AppBar(
        backgroundColor: DefaultColors.bgGray(),
        title: Text("Detalhes do Lote"),
      ),
      body: allotmentProvider.getAllotment.id == "" ?  _pages(context).elementAt(0) : GeneralDetails(aviary: widget.aviary),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: "Bussiness"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: "School"
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        onTap: _onSelect
      ),
    );
  }
}