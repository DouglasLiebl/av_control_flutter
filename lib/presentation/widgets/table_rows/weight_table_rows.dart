import 'package:demo_project/domain/entity/weight.dart';
import 'package:demo_project/domain/entity/weight_box.dart';
import 'package:demo_project/utils/date_formater.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:flutter/material.dart';

class WeightTableRows {

  static Card getWeightTopRow(String description) {
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
            description,
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

  static Card getWeightBoxMiddleRow(WeightBox history, Function delete) {
    return Card(
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
                        Text(
                          "Peso Total: ${history.weight} kg",
                          style: TextStyle(
                            color: DefaultColors.textGray(),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Quantidade: ${history.units}",
                          style: TextStyle(
                            color: DefaultColors.textGray(),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Box: ${history.number}",
                          style: TextStyle(
                            color: DefaultColors.textGray(),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            delete();
                          },
                          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return DefaultColors.iconRed().withOpacity(0.1);
                              }
                              return null;
                            },
                          ),
                          borderRadius: BorderRadius.circular(9999),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.delete_forever_outlined, size: 28.0, color: DefaultColors.iconRed()),
                              ],
                            ),
                          ),
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

  static Card getWeightBoxBottomRow(WeightBox history, Function delete) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
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
                        Text(
                          "Peso Total: ${history.weight} kg",
                          style: TextStyle(
                            color: DefaultColors.textGray(),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Quantidade: ${history.units}",
                          style: TextStyle(
                            color: DefaultColors.textGray(),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Box: ${history.number}",
                          style: TextStyle(
                            color: DefaultColors.textGray(),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          delete();
                        },
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return DefaultColors.iconRed().withOpacity(0.1);
                            }
                            return null;
                          },
                        ),
                        borderRadius: BorderRadius.circular(9999),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.delete_forever_outlined, size: 28.0, color: DefaultColors.iconRed()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ) 
      )
    );
  }


  static Card getWeightMiddleRow(Weight history) {
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
                            Icon(Icons.balance_outlined, size: 16, color: DefaultColors.iconPurple(),),
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
                              "Total de aves: ",
                              style: TextStyle(
                                color: DefaultColors.textGray(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "${history.totalUnits}",
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
                              "Peso Médio: ",
                              style: TextStyle(
                                color: DefaultColors.textGray(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "${history.weight}",
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
                              "Tara: ",
                              style: TextStyle(
                                color: DefaultColors.textGray(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "${history.tare}",
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
                    Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            
                          },
                          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return DefaultColors.iconRed().withOpacity(0.1);
                              }
                              return null;
                            },
                          ),
                          borderRadius: BorderRadius.circular(9999),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit_note_outlined, size: 28.0, color: DefaultColors.bgGray()),
                              ],
                            ),
                          ),
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

  static Card getWeightBottomRow(Weight history) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
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
                            Icon(Icons.balance_outlined, size: 16, color: DefaultColors.iconPurple(),),
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
                              "Total de aves: ",
                              style: TextStyle(
                                color: DefaultColors.textGray(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "${history.totalUnits}",
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
                              "Peso Médio ",
                              style: TextStyle(
                                color: DefaultColors.textGray(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "${history.weight}",
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
                              "Tara: ",
                              style: TextStyle(
                                color: DefaultColors.textGray(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "${history.tare}",
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
                    
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          
                        },
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return DefaultColors.iconRed().withOpacity(0.1);
                            }
                            return null;
                          },
                        ),
                        borderRadius: BorderRadius.circular(9999),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit_note_outlined, size: 28.0, color: DefaultColors.bgGray()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ) 
      )
    );
  }
}