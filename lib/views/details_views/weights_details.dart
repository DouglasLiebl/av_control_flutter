import 'package:demo_project/components/water_register_cards.dart';
import 'package:demo_project/components/water_table_rows.dart';
import 'package:demo_project/context/allotment_provider.dart';
import 'package:demo_project/context/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeightsDetails extends StatefulWidget {
  final String id;
  final VoidCallback onRefresh;

  const WeightsDetails({
    super.key, 
    required this.id,
    required this.onRefresh,
  });

  @override
  State<WeightsDetails> createState() => _WeightDetailsState();
}

class _WeightDetailsState extends State<WeightsDetails> {
  final _multiplierController = TextEditingController();
  final _measureController = TextEditingController();

  void _refreshData() {
    setState(() {});
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final allotmentProvider = context.read<AllotmentProvider>();
    final provider = context.read<DataProvider>();

    final aviary = provider.getAviaryById(widget.id);

    void registerWaterMeasure() async {

      final measure = _measureController.text.isEmpty ? 
        0 : int.parse(_measureController.text);

      final multiplier = _multiplierController.text.isEmpty ?
        0 : int.parse(_multiplierController.text);

      await allotmentProvider.updateWaterHistory(
        provider.getAuth(), 
        widget.id,
        multiplier, 
        measure
      );

      await provider.reloadContext();

      _measureController.clear();
      _multiplierController.clear();

      _refreshData();
    }

    return SafeArea(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              aviary.currentWaterMultiplier != null
              ? WaterRegisterCards.registerCard(
                _measureController,
                allotmentProvider.getWaterHistory().isEmpty,
                registerWaterMeasure
              )
              : WaterRegisterCards.firstRegisterCard(
                _multiplierController,
                _measureController,
                registerWaterMeasure
              ),
              SizedBox(height: 16),
              // Registers
              WaterTableRows.getWaterTopRow(),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: allotmentProvider.getWaterHistory().length,
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