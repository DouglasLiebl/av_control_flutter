import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/widgets/dropdown/dropdown_item.dart';
import 'package:flutter/material.dart';

class Dropdown extends StatelessWidget {
  final TextEditingController controller;
  final List<DropdownItem> values;

  const Dropdown({
    super.key,
    required this.controller,
    required this.values
  });

    DropdownMenuItem<String> buildDropdownItem(DropdownItem item) {
    return DropdownMenuItem(
      value: item.value,
      child: Text(
        item.description,
        style: TextStyle(
          fontSize: 16,
          fontFamily: "JetBrains Mono",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<String>( 
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
            prefixIcon: Icon(
              Icons.inventory_2_outlined,
              size: 28,
              color: DefaultColors.subTitleGray()
            ),
          ),
          onChanged: (String? value) {
            if (value != null) {
              controller.text = value;
            }
          },
          style: TextStyle(
            fontSize: 16,
            color: DefaultColors.valueGray(),
          ),
          hint: Text(
            "Selecione um box", 
            style: TextStyle(
              fontFamily: "JetBrains Mono",
              fontWeight: FontWeight.bold
            )
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
          value: null,
          items: values.map((item) => buildDropdownItem(item)).toList(),
        )
      ) 
    );
  }

}