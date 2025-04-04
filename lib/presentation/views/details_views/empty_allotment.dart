import 'package:demo_project/presentation/provider/account_provider.dart';
import 'package:demo_project/presentation/provider/allotment_provider.dart';
import 'package:demo_project/domain/entity/aviary.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmptyAllotment extends StatelessWidget {
  final Aviary aviary;
  final VoidCallback onRefresh;

  EmptyAllotment({
    super.key, 
    required this.aviary,
    required this.onRefresh,
  });

  final _initialBirdsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final allotmentProvider = context.read<AllotmentProvider>();
    final provider = context.read<AccountProvider>();

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
                              Text(
                                "Novo Lote",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Parece que este aviário não possui um lote ativo. \n Insira o total de aves recebidas abaixo e de inicio à um novo lote.",
                                style: TextStyle(
                                  color: DefaultColors.subTitleGray(),
                                  fontSize: 15
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Total de Aves",
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
                                  prefixIcon: Icon(Icons.numbers_outlined, color: DefaultColors.subTitleGray())
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
                                  await allotmentProvider.registerAllotment(
                                    aviary.id,
                                    int.parse(_initialBirdsController.text)
                                  );

                                  provider.updateActiveAllotmentId(
                                    aviary.id, allotmentProvider.getId()
                                  );

                                  onRefresh();
                                }, 
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, color: Colors.white,),
                                    SizedBox(width: 16),
                                    Text(
                                      "Registar Novo Lote",
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
            ],
          ),
        ),
      )
    );
  }
}