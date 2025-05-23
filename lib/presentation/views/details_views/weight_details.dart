import 'package:demo_project/presentation/widgets/register_cards/weight_register_cards.dart';
import 'package:demo_project/presentation/widgets/table_rows/weight_table_rows.dart';
import 'package:demo_project/presentation/provider/allotment_provider.dart';
import 'package:demo_project/presentation/views/details_views/weight_register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeightDetails extends StatefulWidget {
  final String id;
  final VoidCallback onRefresh;

  const WeightDetails({
    super.key, 
    required this.id,
    required this.onRefresh,
  });

  @override
  State<WeightDetails> createState() => _WeightDetailsState();
}

class _WeightDetailsState extends State<WeightDetails> {
  
  void _refreshData() {
    setState(() {});
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
              WeightRegisterCards.startRegister(() async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeightRegister(id: widget.id, onRefresh: _refreshData))
                );
              }),
              SizedBox(height: 16),

              if (allotmentProvider.getWeightHistory().isNotEmpty)
                WeightTableRows.getWeightTopRow("Registros de Pesos"),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: allotmentProvider.getWeightHistory().length,
                itemBuilder: (context, index) {
                  
                  final history = allotmentProvider.getWeightHistory()[index];

                  if (!((allotmentProvider.getWeightHistory().length - 1) == index)) {
                    return WeightTableRows.getWeightMiddleRow(history);
                  } else {
                    return WeightTableRows.getWeightBottomRow(history);
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