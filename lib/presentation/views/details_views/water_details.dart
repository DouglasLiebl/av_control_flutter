import 'package:demo_project/presentation/widgets/register_cards/water_register_cards.dart';
import 'package:demo_project/presentation/widgets/table_rows/water_table_rows.dart';
import 'package:demo_project/presentation/provider/allotment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaterDetails extends StatefulWidget {
  final String id;
  final VoidCallback onRefresh;

  const WaterDetails({
    super.key, 
    required this.id,
    required this.onRefresh,
  });

  @override
  State<WaterDetails> createState() => _WaterDetailsState();
}

class _WaterDetailsState extends State<WaterDetails> {
  final _multiplierController = TextEditingController();
  final _measureController = TextEditingController();
  final _multiplierFocus = FocusNode();
  final _measureFocus = FocusNode();

  bool _isLoading = false;

  void _refreshData() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _multiplierFocus.dispose();
    _measureFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allotmentProvider = context.read<AllotmentProvider>();

    Future<void> registerWaterMeasure() async {
      FocusScope.of(context).unfocus();
      _isLoading = true;

      final measure = _measureController.text.isEmpty ? 
        0 : int.parse(_measureController.text);

      final multiplier = _multiplierController.text.isEmpty ?
        allotmentProvider.getWaterMultiplier() : int.parse(_multiplierController.text);

      await allotmentProvider.updateWaterHistory(
        multiplier, 
        measure
      );
      
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
              allotmentProvider.getWaterMultiplier() != 0
              ? WaterRegisterCards.registerCard(
                context,
                _measureController,
                allotmentProvider.getWaterHistory().isEmpty,
                registerWaterMeasure,
                _isLoading,
                _measureFocus
              )
              : WaterRegisterCards.firstRegisterCard(
                context,
                _multiplierController,
                _measureController,
                registerWaterMeasure,
                _isLoading,
                _multiplierFocus,
                _measureFocus
              ),
              SizedBox(height: 16),
              if (allotmentProvider.getWaterHistory().isNotEmpty)
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