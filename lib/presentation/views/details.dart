import 'package:demo_project/presentation/provider/allotment_provider.dart';
import 'package:demo_project/domain/entity/aviary.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/views/details_views/empty_allotment.dart';
import 'package:demo_project/presentation/views/details_views/feed_details.dart';
import 'package:demo_project/presentation/views/details_views/general_details.dart';
import 'package:demo_project/presentation/views/details_views/mortality_details.dart';
import 'package:demo_project/presentation/views/details_views/water_details.dart';
import 'package:demo_project/presentation/views/details_views/weight_details.dart';
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

  void _onSelect(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      GeneralDetails(aviary: widget.aviary),
      MortalityDetails(aviary: widget.aviary, onRefresh: refreshPage),
      WaterDetails(id: widget.aviary.id, onRefresh: refreshPage),
      WeightDetails(id: widget.aviary.id, onRefresh: refreshPage),
      FeedDetails(id: widget.aviary.activeAllotmentId ?? "", onRefresh: refreshPage)
    ];
  }

  void refreshPage() {
    setState(() {});
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
      body: allotmentProvider.getAllotment.id == "" 
      ? EmptyAllotment(
          aviary: widget.aviary,
          onRefresh: refreshPage,
        ) 
      : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.feed_outlined),
            label: 'Geral'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.heart_broken_outlined),
            label: "Mortos"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.water_outlined),
            label: "Água"
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.balance_outlined),
            label: "Pesos"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank_outlined),
            label: "Ração"
          )
        ],
        currentIndex: _selectedIndex,
        backgroundColor: DefaultColors.bgGray(),
        selectedItemColor: DefaultColors.iconBlue(),
        unselectedItemColor: DefaultColors.textGray(),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: _onSelect
      ),
      
    );
  }
}