import 'package:demo_project/context/data_provider.dart';
import 'package:demo_project/models/aviary.dart';
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
  static final List<Widget> _pages = [
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Este aviário não possui um lote ativo no momento."),
        ElevatedButton(
          onPressed: () {} , 
          child: Text("Iniciar lote")
        )
      ],
    ),
  ];

  void _onSelect(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Detalhes do Lote"),
          ),
          body: Center(
            child: widget.aviary.activeAllotmentId == null ?  _pages.elementAt(0) : Text("")
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home'
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: "Bussiness"
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: "School"
              )
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber,
            onTap: _onSelect
          ),
        );
      }
    );
  }
}