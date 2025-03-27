import 'package:demo_project/context/data_provider.dart';
import 'package:demo_project/models/aviary.dart';
import 'package:demo_project/utils/date_formater.dart';
import 'package:demo_project/utils/default_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';

class XmlReceiver extends StatelessWidget {
  final String xmlContent;
  final Function changeState;

  const XmlReceiver({super.key, required this.xmlContent, required this.changeState});

  String? findMatchingAviaryId(String xmlAviaryName, List<Aviary> aviaries) {
    final receivedName = xmlAviaryName.toLowerCase().trim();
    final matching = aviaries.firstWhere(
      (aviary) => aviary.name.toLowerCase().trim() == receivedName,
      orElse: () => Aviary(id: '', name: '', alias: '', accountId: '', activeAllotmentId: ''),
    );
    return matching.id.isNotEmpty ? matching.id : null;
  }

  @override
  Widget build(BuildContext context) {
    final data = XmlDocument.parse(xmlContent);
    final provider = context.read<DataProvider>();

    final xmlAviaryName = data.findAllElements("dest").first.findElements("xNome").first.text;
    final matchingAviaryId = findMatchingAviaryId(xmlAviaryName, provider.getAviaries());

    return WillPopScope(
      onWillPop: () async {
        changeState();
        return true;
      },
      child:Scaffold(
      backgroundColor: DefaultColors.bgGray(),
      appBar: AppBar(
        backgroundColor: DefaultColors.bgGray(),
        title: Text("Registro de Nota"),
        actions: [
          provider.getAccount.id != ""
          ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: DefaultColors.activeBgGreen(),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();                      
                  },
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return DefaultColors.activeGreen().withOpacity(0.1);
                      }
                      return null;
                    },
                  ),
                  borderRadius: BorderRadius.circular(9999),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_outlined, 
                          size: 20, 
                          color: DefaultColors.activeGreen()
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Salvar",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: DefaultColors.activeGreen()
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          : SizedBox.shrink()
        ]
      ),
      body: SafeArea(
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
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: DefaultColors.borderGray(),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)
                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Detalhes Gerais",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14
                          ),
                        ),
                      ],
                    ),
                  ) 
                ),
                Card(
                color: Colors.white,
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  side: BorderSide.none, // No border for the whole shape
                  borderRadius: BorderRadius.zero,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: DefaultColors.borderGray(),
                        width: 1,
                      ),
                      right: BorderSide(
                        color: DefaultColors.borderGray(),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tipo de Ração",
                          style: TextStyle(
                            color: DefaultColors.textGray(),
                            fontWeight: FontWeight.w500,
                            fontSize: 14
                          ),      
                        ),
                        Text(
                          data.findAllElements("xProd").first.text,
                          style: TextStyle(
                            color: DefaultColors.valueGray(),
                            fontSize: 14
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
                Card(
                  color: Colors.white,
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none, // No border for the whole shape
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: DefaultColors.borderGray(),
                          width: 1,
                        ),
                        right: BorderSide(
                          color: DefaultColors.borderGray(),
                          width: 1,
                        ),
                        top: BorderSide(
                          color: DefaultColors.borderGray(),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Peso",
                            style: TextStyle(
                              color: DefaultColors.textGray(),
                              fontWeight: FontWeight.w500,
                              fontSize: 14
                            ),      
                          ),
                          Text(
                           data.findAllElements("qTrib").first.text,
                            style: TextStyle(
                              color: DefaultColors.valueGray(),
                              fontSize: 14
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: DefaultColors.borderGray(),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8)
                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Aviário",
                          style: TextStyle(
                            color: DefaultColors.textGray(),
                            fontWeight: FontWeight.w500,
                            fontSize: 14
                          ),      
                        ),
                        Text(
                          data.findAllElements("dest").first.findAllElements("xNome").first.text,
                          style: TextStyle(
                            color: DefaultColors.valueGray(),
                            fontSize: 14
                          ),
                        ),
                      ],
                    ),
                  ) 
                ),

                // TIMELINE
                SizedBox(height: 16.0),
                Card(
                  color: Colors.white,
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: DefaultColors.borderGray(),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)
                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Linha do Tempo",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14
                          ),
                        ),
                      ],
                    ),
                  ) 
                ),
                Card(
                  color: Colors.white,
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none, // No border for the whole shape
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: DefaultColors.borderGray(),
                          width: 1,
                        ),
                        right: BorderSide(
                          color: DefaultColors.borderGray(),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, color: DefaultColors.textGray(), size: 18,),
                          SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Emissão",
                                  style: TextStyle(
                                    color: DefaultColors.textGray(),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14
                                  ),      
                                ),
                                Text(
                                DateFormater.formatISODate(data.findAllElements("dhEmi").first.text),
                                  style: TextStyle(
                                    color: DefaultColors.valueGray(),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                          )
                        ],
                      )
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: DefaultColors.borderGray(),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8)
                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, color: DefaultColors.textGray(), size: 18,),
                        SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Saída",
                                style: TextStyle(
                                  color: DefaultColors.textGray(),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14
                                ),      
                              ),
                              Text(
                                DateFormater.formatISODate(data.findAllElements("dhSaiEnt").first.text),
                                style: TextStyle(
                                  color: DefaultColors.valueGray(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ) 
                ),
                SizedBox(height: 16),
                provider.getAccount.id != ""
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Confira o aviário abaixo",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 8),
                    DropdownButtonHideUnderline(
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
                              Icons.house_siding_outlined,
                              size: 28,
                              color: DefaultColors.subTitleGray()
                            ),
                            filled: true,
                            fillColor: Colors.white
                          ),
                          onChanged: (String? value) {
                            if (value != null) {
                              
                            }
                          },
                          style: TextStyle(
                            fontSize: 16,
                            color: DefaultColors.valueGray(),
                          ),
                          hint: Text(
                            "Selecione um aviário", 
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            )
                          ),
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          value: matchingAviaryId,
                          items:  provider.getAviaries().map((aviary) {
                            return DropdownMenuItem(
                              value: aviary.id,
                              child: Text(
                                aviary.name, 
                                style: TextStyle(fontSize: 16)
                              ),
                            );
                          }).toList()
                        )
                      ) 
                    ),
                  ],
                )
                : SizedBox()
              ],
            ),
          ),
        )
      ))
    );
  }
}