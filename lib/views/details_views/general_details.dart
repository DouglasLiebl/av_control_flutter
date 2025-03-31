import 'package:demo_project/context/allotment_provider.dart';
import 'package:demo_project/models/aviary.dart';
import 'package:demo_project/utils/date_formater.dart';
import 'package:demo_project/utils/default_colors.dart';
import 'package:demo_project/utils/status_tags.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GeneralDetails extends StatelessWidget {
  final Aviary aviary;

  const GeneralDetails({super.key, required this.aviary});
  

  @override
  Widget build(BuildContext context) {
    final allotment = context.read<AllotmentProvider>();

    return SafeArea(
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
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: DefaultColors.borderGray(),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: DefaultColors.iconBgGray(),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Center(
                          child: Icon(Icons.home_outlined),
                          ),  
                        )
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StatusTags.getActiveTag(aviary.alias),
                            SizedBox(height: 4),
                            Text(
                              "ID: ${aviary.id}",
                              style: TextStyle(
                                fontSize: 14,
                                color: DefaultColors.textGray(),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ) 
              ),
              SizedBox(height: 10),
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
                          "Número",
                          style: TextStyle(
                            color: DefaultColors.textGray(),
                            fontWeight: FontWeight.w500,
                            fontSize: 14
                          ),      
                        ),
                        Text(
                          allotment.getAllotment.number.toString(),
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
                          "Quantidade Total",
                          style: TextStyle(
                            color: DefaultColors.textGray(),
                            fontWeight: FontWeight.w500,
                            fontSize: 14
                          ),      
                        ),
                        Text(
                          allotment.getAllotment.totalAmount.toString(),
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
                        "Idade Atual",
                        style: TextStyle(
                          color: DefaultColors.textGray(),
                          fontWeight: FontWeight.w500,
                          fontSize: 14
                        ),      
                      ),
                      Text(
                        "${allotment.getAllotment.currentAge.toString()} dias",
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
                                "Início",
                                style: TextStyle(
                                  color: DefaultColors.textGray(),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14
                                ),      
                              ),
                              Text(
                                DateFormater.formatDateString(allotment.getAllotment.startedAt),
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
                              "Fim Previsto",
                              style: TextStyle(
                                color: DefaultColors.textGray(),
                                fontWeight: FontWeight.w500,
                                fontSize: 14
                              ),      
                            ),
                            Text(
                              DateFormater.addDaysToDate(allotment.getAllotment.startedAt, 40),
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

              // STATISTICS
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
                        "Estatísticas Atuais",
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
                  side: BorderSide.none,
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
                      bottom: BorderSide(
                        color: DefaultColors.borderGray(),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Icon(Icons.breakfast_dining_outlined, color: DefaultColors.iconAmber(), size: 22,),
                              Text(
                                "Ração Total Recebida",
                                style: TextStyle(
                                  color: DefaultColors.textGray(),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "${allotment.getAllotment.currentTotalFeedReceived.toString()} Kg",
                                style: TextStyle(
                                  color: DefaultColors.valueGray(),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ) 
                )
              ),
              Card(
                color: Colors.white,
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
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
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Column(
                              children: [
                                Icon(Icons.percent_outlined, color: DefaultColors.iconRed(), size: 22),
                                Text(
                                  "Mortalidade",
                                  style: TextStyle(
                                    color: DefaultColors.textGray(),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "${allotment.getAllotment.currentDeathPercentage.toString()}%",
                                  style: TextStyle(
                                    color: DefaultColors.valueGray(),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: DefaultColors.borderGray(),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Column(
                              children: [
                                Icon(Icons.balance_outlined, color: DefaultColors.iconGreen(), size: 22),
                                Text(
                                  "Peso Médio atual",
                                  style: TextStyle(
                                    color: DefaultColors.textGray(),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "${allotment.getAllotment.currentWeight.toString()} Kg",
                                  style: TextStyle(
                                    color: DefaultColors.valueGray(),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
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
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.water_drop_outlined, color: DefaultColors.iconLightBlue(), size: 22,),
                            Text(
                              "Consumo Total de Água",
                              style: TextStyle(
                                color: DefaultColors.textGray(),
                                fontWeight: FontWeight.w500,
                                fontSize: 14
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "${allotment.getAllotment.currentTotalWaterConsume.toString()} L",
                              style: TextStyle(
                                color: DefaultColors.valueGray(),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ) 
              ),
            ],
          ),
        ),
      )
    );
  }
}