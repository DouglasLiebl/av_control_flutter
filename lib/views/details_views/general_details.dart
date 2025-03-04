import 'package:demo_project/context/allotment_provider.dart';
import 'package:demo_project/context/data_provider.dart';
import 'package:demo_project/models/aviary.dart';
import 'package:demo_project/utils/default_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GeneralDetails extends StatelessWidget {
  final Aviary aviary;

  const GeneralDetails({super.key, required this.aviary});
  

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DataProvider>();
    final allotment = context.read<AllotmentProvider>();

    return SafeArea(
      child: SingleChildScrollView(
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
                    color: const Color.fromARGB(255, 173, 171, 171),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Icon(Icons.home_outlined),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  aviary.alias,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: DefaultColors.activeBgGreen(),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.0, top: 2.0, right: 10.0, bottom: 2.0),
                                    child: Center(
                                    child: Text(
                                        "Ativo",  
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: DefaultColors.activeGreen()
                                        ),
                                      ),
                                    ),  
                                  )
                                )
                                
                              ],
                            ),

                            SizedBox(height: 4),
                            Text(
                              "ID: ${aviary.id}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ) 
              ),
            ],
          ),
        ),
      )
    );
  }
}