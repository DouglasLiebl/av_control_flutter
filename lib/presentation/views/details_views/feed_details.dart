import 'dart:io';

import 'package:demo_project/presentation/components/loading.dart';
import 'package:demo_project/presentation/widgets/table_rows/feed_table_rows.dart';
import 'package:demo_project/presentation/provider/allotment_provider.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/views/xml_receiver.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedDetails extends StatefulWidget {
  final String id;
  final VoidCallback onRefresh;

  const FeedDetails({
    super.key, 
    required this.id,
    required this.onRefresh,
  });

  @override
  State<FeedDetails> createState() => _FeedDetailsState();
}

class _FeedDetailsState extends State<FeedDetails> {
  Future<void> _pickAndOpenXmlFile() async {
    try {
      Loading.getLoading(context);
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xml'],
      );

      if (result != null && result.files.single.path != null) {
        String content = await File(result.files.single.path!).readAsString();
        
        if (!mounted) return;
        
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => XmlReceiver(
              xmlContent: content,
              changeState: _refreshData,
              allotmentId: widget.id,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Não foi possível ler o arquivo XML.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _refreshData() {
    setState(() {});
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final allotmentProvider = context.read<AllotmentProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
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
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white
                        ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Novo Registro de Ração",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: 12,),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Clique em importar nota e selecione o arquivo XML que deseja registrar.",
                                style: TextStyle(
                                  color: DefaultColors.subTitleGray(),
                                  fontSize: 15
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(DefaultColors.valueGray()),
                                minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                ),
                                elevation: MaterialStateProperty.all(5),
                                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed)) {
                                      return Colors.grey.withOpacity(0.2);
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              onPressed: _pickAndOpenXmlFile,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.upload_file, color: Colors.white),
                                  SizedBox(width: 16),
                                  Text(
                                    "Importar Nota",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ) 
              ),
              SizedBox(height: 16),
              // Registers
              if (allotmentProvider.getFeedHistory().isNotEmpty) 
                FeedTableRows.getFeedTopRow(),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: allotmentProvider.getFeedHistory().length,
                itemBuilder: (context, index) {
                  
                  final history = allotmentProvider.getFeedHistory()[index];

                  if (!((allotmentProvider.getFeedHistory().length - 1) == index)) {
                    return FeedTableRows.getFeedMiddleRow(history);
                  } else {
                    return FeedTableRows.getFeedBottomRow(history);
                  }
                }
              )
            ],
          ),
        ),
      )
    );
  }
}