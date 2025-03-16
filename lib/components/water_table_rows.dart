import 'package:demo_project/models/water.dart';
import 'package:demo_project/utils/date_formater.dart';
import 'package:demo_project/utils/default_colors.dart';
import 'package:flutter/material.dart';

class WaterTableRows {

  static Card getWaterTopRow() {
    return Card(
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
            "Registros de Cosumo de Água",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16
            ),
          ),
        ],
      ),
    ) 
  );
  }

  static Card getWaterMiddleRow(Water history) {
    return Card(
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
            bottom: BorderSide(
              color: DefaultColors.borderGray(),
              width: 1,
            ),
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
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.water_drop_outlined, size: 14, color: DefaultColors.iconLightBlue(),),
                            SizedBox(width: 5),
                            Text(
                              DateFormater.formatDateString(history.createdAt),
                              style: TextStyle(
                                color: DefaultColors.valueGray(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Idade: ",
                              style: TextStyle(
                                color: DefaultColors.textGray(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "${history.age}",
                              style: TextStyle(
                                color: DefaultColors.valueGray(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Medida: ",
                              style: TextStyle(
                                color: DefaultColors.textGray(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "${history.currentMeasure}",
                              style: TextStyle(
                                color: DefaultColors.valueGray(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Litros Consumidos: ",
                              style: TextStyle(
                                color: DefaultColors.textGray(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "${history.consumedLiters} L",
                              style: TextStyle(
                                color: DefaultColors.valueGray(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Icon(Icons.edit_note_outlined, size: 28.0, color: DefaultColors.borderGray(),)
                  ],
                ),

              )
            ],
          )
        ),
      ),
    );
  }

  static Card getWaterBottomRow(Water history) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide.none, // No border for the whole shape
        borderRadius: BorderRadius.zero,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
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
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.water_drop_outlined, size: 14, color: DefaultColors.iconLightBlue(),),
                              SizedBox(width: 5),
                              Text(
                                DateFormater.formatDateString(history.createdAt),
                                style: TextStyle(
                                  color: DefaultColors.valueGray(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Idade: ",
                                style: TextStyle(
                                  color: DefaultColors.textGray(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "${history.age}",
                                style: TextStyle(
                                  color: DefaultColors.valueGray(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Medida: ",
                                style: TextStyle(
                                  color: DefaultColors.textGray(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "${history.currentMeasure}",
                                style: TextStyle(
                                  color: DefaultColors.valueGray(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Litros Consumidos: ",
                                style: TextStyle(
                                  color: DefaultColors.textGray(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "${history.consumedLiters} L",
                                style: TextStyle(
                                  color: DefaultColors.valueGray(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(Icons.edit_note_outlined, size: 28.0, color: DefaultColors.borderGray())
                    ],
                  ),
              ),
            ],
          )
        ) 
      )
    );
  }

  static Card getWaterStartPointRow(Water history) {
    return Card(
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
            bottom: BorderSide(
              color: DefaultColors.borderGray(),
              width: 1
            ),
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
              Icon(Icons.start_outlined, color: DefaultColors.textGray(), size: 18,),
              SizedBox(width: 12),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ponto de Partida",
                      style: TextStyle(
                        color: DefaultColors.textGray(),
                        fontWeight: FontWeight.w500,
                        fontSize: 14
                      ),      
                    ),
                    Text(
                      "${history.currentMeasure}",
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
    );
  }

  static Card getWaterBottomStartPointRow(Water history) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide.none, // No border for the whole shape
        borderRadius: BorderRadius.zero,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
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
              Icon(Icons.start_outlined, color: DefaultColors.textGray(), size: 18,),
              SizedBox(width: 12),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ponto de Partida",
                      style: TextStyle(
                        color: DefaultColors.textGray(),
                        fontWeight: FontWeight.w500,
                        fontSize: 14
                      ),      
                    ),
                    Text(
                      "${history.currentMeasure}",
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
      )
    );
  }
}