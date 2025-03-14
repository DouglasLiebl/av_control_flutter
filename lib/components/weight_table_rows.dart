import 'package:demo_project/models/weight_box.dart';
import 'package:demo_project/utils/default_colors.dart';
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
                        Text(
                          "Peso: ${history.weight}",
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
                            "Peso: ${history.weight}",
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
}