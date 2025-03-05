import 'package:demo_project/components/table_rows.dart';
import 'package:demo_project/context/allotment_provider.dart';
import 'package:demo_project/context/data_provider.dart';
import 'package:demo_project/models/aviary.dart';
import 'package:demo_project/utils/default_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MortalityDetails extends StatefulWidget {
  final Aviary aviary;
  final VoidCallback onRefresh;

  const MortalityDetails({
    super.key, 
    required this.aviary,
    required this.onRefresh,
  });

  @override
  State<MortalityDetails> createState() => _MortalityDetailsState();
}

class _MortalityDetailsState extends State<MortalityDetails> {
  final _deathsController = TextEditingController();
  final _eliminationsController = TextEditingController();

  void _refreshData() {
    setState(() {});
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final allotmentProvider = context.read<AllotmentProvider>();
    final provider = context.read<DataProvider>();

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
                                final deaths = _deathsController.text.isEmpty ? 
                                  0 : int.parse(_deathsController.text);
                                final eliminations = _eliminationsController.text.isEmpty ? 
                                  0 : int.parse(_eliminationsController.text);

                                await allotmentProvider.updateMortality(
                                  provider.getAuth(),
                                  deaths,
                                  eliminations
                                );
                                _deathsController.clear();
                                _eliminationsController.clear();
                                _refreshData();
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
              TableRows.getMortalityTopRow(),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: allotmentProvider.getMortalityHistory().length,
                itemBuilder: (context, index) {
                  
                  final history = allotmentProvider.getMortalityHistory()[index];

                  if (!((allotmentProvider.getMortalityHistory().length - 1) == index)) {
                    return TableRows.getMortalityMiddleRow(history);
                  } else {
                    return TableRows.getMortalityBottomRow(history);
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