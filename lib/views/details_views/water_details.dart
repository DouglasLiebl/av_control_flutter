import 'package:demo_project/components/table_rows.dart';
import 'package:demo_project/components/water_register_cards.dart';
import 'package:demo_project/components/water_table_rows.dart';
import 'package:demo_project/context/allotment_provider.dart';
import 'package:demo_project/context/data_provider.dart';
import 'package:demo_project/models/aviary.dart';
import 'package:demo_project/utils/default_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaterDetails extends StatefulWidget {
  final Aviary aviary;
  final VoidCallback onRefresh;

  const WaterDetails({
    super.key, 
    required this.aviary,
    required this.onRefresh,
  });

  @override
  State<WaterDetails> createState() => _MortalityDetailsState();
}

class _MortalityDetailsState extends State<WaterDetails> {
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

    return SafeArea(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.aviary.currentWaterMultiplier == null
              ? WaterRegisterCards.registerCard(
                _measureController,
                true
              )
              : WaterRegisterCards.firstRegisterCard(
                _multiplierController,
                _measureController
              ),
              SizedBox(height: 16),
              // Registers
              WaterTableRows.getWaterTopRow(),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:1 ,
                itemBuilder: (context, index) {

                  return WaterTableRows.getWaterBottomStartPointRow();
                }
              )
            ],
          ),
        ),
      )
    );
  }
}