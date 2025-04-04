import 'package:demo_project/domain/entity/feed.dart';
import 'package:demo_project/utils/date_formater.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:flutter/material.dart';

class FeedTableRows {

  static Card getFeedTopRow() {
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
            "Registros de Ração Recebida",
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

  static Card getFeedMiddleRow(Feed history) {
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
                        Row(
                          children: [
                            Icon(Icons.breakfast_dining_outlined, size: 16, color: DefaultColors.iconGreen(),),
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
                              "Nº da Nota: ",
                              style: TextStyle(
                                color: DefaultColors.textGray(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              history.nfeNumber,
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
                              "Tipo: ",
                              style: TextStyle(
                                color: DefaultColors.textGray(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              history.type,
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
                              "Peso: ",
                              style: TextStyle(
                                color: DefaultColors.textGray(),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "${history.weight} Kg",
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

  static Card getFeedBottomRow(Feed history) {
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
                              Icon(Icons.breakfast_dining_outlined, size: 16, color: DefaultColors.iconGreen(),),
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
                                "Nº da Nota: ",
                                style: TextStyle(
                                  color: DefaultColors.textGray(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                history.nfeNumber,
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
                                "Tipo: ",
                                style: TextStyle(
                                  color: DefaultColors.textGray(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                history.type,
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
                                "Peso: ",
                                style: TextStyle(
                                  color: DefaultColors.textGray(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "${history.weight} Kg",
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
}