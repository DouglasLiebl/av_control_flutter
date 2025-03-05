import 'package:demo_project/models/mortality.dart';
import 'package:demo_project/utils/date_formater.dart';
import 'package:demo_project/utils/default_colors.dart';
import 'package:flutter/material.dart';

class TableRows {

  static Card getMortalityTopRow() {
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
            "Registros de Mortalidade",
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

  static Card getMortalityMiddleRow(Mortality history) {
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
            top: BorderSide(
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
                          "Data: ${DateFormater.formatDateString(history.createdAt)}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Idade: ${history.age}",
                          style: TextStyle(
                            color: DefaultColors.textGray(),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Mortes: ${history.deaths}",
                          style: TextStyle(
                            color: DefaultColors.textGray(),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Eliminações: ${history.eliminations}",
                          style: TextStyle(
                            color: DefaultColors.textGray(),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.edit_note_outlined, size: 28.0,)
                  ],
                ),

              )
            ],
          )
        ),
      ),
    );
  }

  static Card getMortalityBottomRow(Mortality history) {
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
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8)
        )
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
                          "Data: ${DateFormater.formatDateString(history.createdAt)}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Idade: ${history.age}",
                          style: TextStyle(
                            color: DefaultColors.textGray(),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Mortes: ${history.deaths}",
                          style: TextStyle(
                            color: DefaultColors.textGray(),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Eliminações: ${history.eliminations}",
                          style: TextStyle(
                            color: DefaultColors.textGray(),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.edit_note_outlined, size: 28.0)
                  ],
                ),
            ),
          ],
        )
      ) 
    );
  }
}