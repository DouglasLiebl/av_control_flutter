import 'package:demo_project/components/water_table_rows.dart';
import 'package:demo_project/components/weight_register_cards.dart';
import 'package:demo_project/context/allotment_provider.dart';
import 'package:demo_project/views/details_views/weight_register.dart';
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
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final allotmentProvider = context.read<AllotmentProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WeightRegisterCards.startRegister(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeightRegister(id: widget.id, onRefresh: _refreshData))
                );
              }),
              SizedBox(height: 16),
              // Registers
              WaterTableRows.getWaterTopRow(),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: allotmentProvider.getWeightHistory().length,
                itemBuilder: (context, index) {

                  final history = allotmentProvider.getWaterHistory()[index];


                  if (index == 0 && allotmentProvider.getWaterHistory().length == 1) {
                    return WaterTableRows.getWaterBottomStartPointRow(history);
                  } else if (index == 0) {
                    return WaterTableRows.getWaterStartPointRow(history);
                  }
                  
                  if (!((allotmentProvider.getWaterHistory().length - 1) == index)) {
                    return WaterTableRows.getWaterMiddleRow(history);
                  } else {
                    return WaterTableRows.getWaterBottomRow(history);
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