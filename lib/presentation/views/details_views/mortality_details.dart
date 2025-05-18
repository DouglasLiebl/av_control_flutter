import 'package:demo_project/presentation/widgets/table_rows/mortality_table_rows.dart';
import 'package:demo_project/presentation/provider/allotment_provider.dart';
import 'package:demo_project/domain/entity/aviary.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
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
  final _deathsFocus = FocusNode();
  final _eliminationsFocus = FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    _deathsFocus.dispose();
    _eliminationsFocus.dispose(); 
    super.dispose();
  }

  void _refreshData() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allotmentProvider = context.read<AllotmentProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
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
                                "Novo Registro de Mortalidade",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(height: 12),
                                Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Insira os valores abaixo e pressione Adicionar Registro para salvar. Caso um campo não seja inserido o valor padrão zero será utilizado",
                                  style: TextStyle(
                                    color: DefaultColors.subTitleGray(),
                                    fontSize: 15
                                  ),
                                  textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(height: 12),
                              ],
                            ),
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
                                        enabled: _isLoading ? false : true,
                                        keyboardType: TextInputType.number,
                                        controller: _deathsController,
                                        cursorColor: DefaultColors.valueGray(),
                                        focusNode: _deathsFocus,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) {
                                          FocusScope.of(context).requestFocus(_eliminationsFocus);
                                        },
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: DefaultColors.valueGray(),
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Ex: 00",
                                          hintStyle: TextStyle(
                                            color: DefaultColors.textGray(),
                                            fontSize: 14,
                                          ), 
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
                                          prefixIcon: Icon(Icons.monitor_heart_outlined, size: 28, color: DefaultColors.subTitleGray())
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
                                        enabled: _isLoading ? false : true,
                                        keyboardType: TextInputType.number,
                                        controller: _eliminationsController,
                                        cursorColor: DefaultColors.valueGray(),
                                        focusNode: _eliminationsFocus,
                                        textInputAction: TextInputAction.done,
                                        onFieldSubmitted: (_) {
                                          FocusScope.of(context).unfocus();
                                        },
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: DefaultColors.valueGray(),
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Ex: 00",
                                          hintStyle: TextStyle(
                                            color: DefaultColors.textGray(),
                                            fontSize: 14,
                                          ), 
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
                                          prefixIcon: Icon(Icons.sentiment_very_dissatisfied_outlined, size: 28, color: DefaultColors.subTitleGray())
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
                              onPressed: _isLoading ? null
                              : () async {
                                FocusScope.of(context).unfocus();
                                _isLoading = true;

                                final deaths = _deathsController.text.isEmpty ? 
                                  0 : int.parse(_deathsController.text);
                                final eliminations = _eliminationsController.text.isEmpty ? 
                                  0 : int.parse(_eliminationsController.text);

                                await allotmentProvider.updateMortality(
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
                                  _isLoading
                                  ? SizedBox(
                                    height: 22,
                                    width: 22, 
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                  : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add, color: Colors.white),
                                      SizedBox(width: 16),
                                      Text(
                                        "Adicionar Registro",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      )
                                    ],
                                  ),
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
              if (allotmentProvider.getMortalityHistory().isNotEmpty) 
                MortalityTableRows.getMortalityTopRow(),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: allotmentProvider.getMortalityHistory().length,
                itemBuilder: (context, index) {
                  
                  final history = allotmentProvider.getMortalityHistory()[index];

                  if (!((allotmentProvider.getMortalityHistory().length - 1) == index)) {
                    return MortalityTableRows.getMortalityMiddleRow(history);
                  } else {
                    return MortalityTableRows.getMortalityBottomRow(history);
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