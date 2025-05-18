import 'package:demo_project/infra/third_party/local_storage/secure_storage.dart';
import 'package:demo_project/main.dart';
import 'package:demo_project/presentation/widgets/buttons/finish_button.dart';
import 'package:demo_project/presentation/widgets/register_cards/weight_register_cards.dart';
import 'package:demo_project/presentation/widgets/table_rows/weight_table_rows.dart';
import 'package:demo_project/presentation/provider/allotment_provider.dart';
import 'package:demo_project/domain/entity/weight_box.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeightRegister extends StatefulWidget {
  final String id;
  final VoidCallback onRefresh;

  const WeightRegister({
    super.key, 
    required this.id,
    required this.onRefresh,
  });

  @override
  State<WeightRegister> createState() => _WaterDetailsState();
}

class _WaterDetailsState extends State<WeightRegister> {
  final _unitsController = TextEditingController();
  final _weightController = TextEditingController();
  final _boxController = TextEditingController();
  final _tareController = TextEditingController();
  final _weightFocus = FocusNode();
  final _unitsFocus = FocusNode();
  final _tareFocus = FocusNode();

  bool _isLoading = false;

  void _refreshData() {
    setState(() {
      _isLoading = false;
    });
    widget.onRefresh();
  }

  
  List<WeightBox> weights = [];

  @override
  Widget build(BuildContext context) {
    final allotmentProvider = context.watch<AllotmentProvider>();
    final storage = getIt<SecureStorage>();

    void registerWeight() async {
      final weight = _weightController.text.isEmpty ? 
        0.0 : double.parse(_weightController.text);

      final unit = _unitsController.text.isEmpty ?
        0 : int.parse(_unitsController.text);

      final box = _boxController.text.isEmpty ?
        0 : int.parse(_boxController.text);

      weights.add(WeightBox(
        id: null,
        weightId: null,
        weight: weight,
        units: unit,
        number: box
        )
      );
  
      _weightController.clear();
      _unitsController.clear();

      _refreshData();
    }

    void removeWeight(int index) {
      setState(() {
        weights.removeAt(index);
      });
      _refreshData();
    }

    Future<void> finishRegister() async {
      setState(() {
        _isLoading = true;
      });
      final tareString = await storage.getItem("Tare");
      final tare = tareString != null ? double.parse(tareString) : 0.0;
      
      int totalUnits = weights.fold(0, (total, element) => total + element.units);

      await allotmentProvider.updateWeight(totalUnits, tare, weights);
      _refreshData();
    }

    Future<bool> closePopUp() async {
      if (weights.isEmpty) {
        return true;
      }

      return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: DefaultColors.borderGray(),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8)
            ),
            backgroundColor: DefaultColors.bgGray(),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, size: 25, color: DefaultColors.iconAmber()),
                SizedBox(width: 10),
                Text(
                  "Confirmar Saída",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            content: Text(
              "Tem certeza que deseja sair sem salvar seus dados?",
              style: TextStyle(
                fontSize: 16,
                color: DefaultColors.textGray()
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'Não',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Sim',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    }

    return WillPopScope(
      onWillPop: closePopUp,
      child: Scaffold(
        backgroundColor: DefaultColors.bgGray(),
        appBar: AppBar(
          title: Text(
            "Pesagem",
            style: TextStyle(
              fontFamily: "JetBrains Mono"
            )
          ),
          backgroundColor: DefaultColors.bgGray(),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
              onPressed: () async {
                final shouldPop = await closePopUp();
                if (shouldPop) {
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                }
              },
            ),
          actions: [
            weights.isNotEmpty
            ? FinishButton(value: "Concluir", isLoading: _isLoading, onPress: finishRegister)
            : SizedBox.shrink()
          ]
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  WeightRegisterCards.registerCard(
                    _weightController, 
                    _unitsController, 
                    _boxController, 
                    _tareController, 
                    registerWeight,
                    _weightFocus,
                    _unitsFocus,
                    _tareFocus,
                    _isLoading
                  ),
                  SizedBox(height: 16),
                  if (weights.isNotEmpty)
                    WeightTableRows.getWeightTopRow("Pesos Adicionados"),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: weights.length,
                    itemBuilder: (context, index) {

                      final history = weights[index];
                      
                      if (!((weights.length - 1) == index)) {
                        return WeightTableRows.getWeightBoxMiddleRow(history, () => removeWeight(index));
                      } else {
                        return WeightTableRows.getWeightBoxBottomRow(history, () => removeWeight(index));
                      }

                    }
                  )
                ],
              ),
            ),
          )
        )
      )
    );
  }
}