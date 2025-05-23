import 'package:demo_project/infra/factory/service_factory.dart';
import 'package:demo_project/main.dart';
import 'package:demo_project/presentation/provider/account_provider.dart';
import 'package:demo_project/presentation/provider/allotment_provider.dart';
import 'package:demo_project/domain/entity/aviary.dart';
import 'package:demo_project/presentation/widgets/buttons/finish_button.dart';
import 'package:demo_project/utils/date_formater.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/views/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';


class XmlReceiver extends StatefulWidget {
  final String xmlContent;
  final Function changeState;
  final String? allotmentId; 

  const XmlReceiver({super.key, required this.xmlContent, required this.changeState, this.allotmentId});

  @override
  State<StatefulWidget> createState() => _XmlReceiverState();
}

class _XmlReceiverState extends State<XmlReceiver> {
  
  final _allotmentController = TextEditingController();
  final _accessKeyController = TextEditingController();
  final _nfeNumberController = TextEditingController();
  final _emmitedAtController = TextEditingController();
  final _typeController = TextEditingController();
  final _weightController = TextEditingController();
  final _transporterController = TextEditingController();

  late XmlDocument data;
  bool _isLoading = false;

  void _refreshData() {
    setState(() {
      _isLoading = false;
    });
    widget.changeState();
  }

  @override
  void initState() {
    super.initState();
    data = XmlDocument.parse(widget.xmlContent);
  }

  String? findMatchingAviaryId(String xmlAviaryName, List<Aviary> aviaries) {
    final receivedName = xmlAviaryName.toLowerCase().trim();
    final matching = aviaries.firstWhere(
      (aviary) => aviary.name.toLowerCase().trim() == receivedName,
      orElse: () => Aviary(id: '', name: '', alias: '', accountId: '', activeAllotmentId: null),
    );

    return matching.activeAllotmentId?.isNotEmpty == true ? matching.activeAllotmentId : null;
  }

  void initalizeData() {
    _accessKeyController.text = data.findAllElements("chNFe").first.text;
    _nfeNumberController.text = data.findAllElements("nNF").first.text;
    _typeController.text = data.findAllElements("xProd").first.text;
    _weightController.text = data.findAllElements("qTrib").first.text;
    _emmitedAtController.text = DateFormater.formatISODate(data.findAllElements("dhEmi").first.text).toString();
    _transporterController.text = data.findAllElements("transporta").first.findAllElements("xNome").first.text;
  }

  @override
  Widget build(BuildContext context) {
    initalizeData();
    final provider = context.read<AccountProvider>();
    final allotmentProvider = context.read<AllotmentProvider>();

    final xmlAviaryName = data.findAllElements("dest").first.findElements("xNome").first.text;
    final matchingAviaryId = findMatchingAviaryId(xmlAviaryName, provider.getAviaries());
    final hasActiveAllotments = provider.getAviaries()
      .any((aviary) => aviary.activeAllotmentId != null);
    _allotmentController.text = matchingAviaryId ?? "";

    Future<void> registerFeed() async {
      FocusScope.of(context).unfocus();
      setState(() => _isLoading = true);

      await allotmentProvider.updateFeed(
        widget.allotmentId ?? _allotmentController.text,
        _accessKeyController.text, 
        _nfeNumberController.text, 
        _emmitedAtController.text, 
        double.parse(_weightController.text), 
        _typeController.text
      );

      _refreshData();

      if (!context.mounted) return;
      if (widget.allotmentId == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(syncService: getIt<ServiceFactory>().getSyncService()))
        );   
      } else {
        Navigator.of(context).pop();
      }       
    }

    return WillPopScope(
      onWillPop: () async {
        widget.changeState();
        return true;
      },
      child:Scaffold(
      backgroundColor: DefaultColors.bgGray(),
      appBar: AppBar(
        backgroundColor: DefaultColors.bgGray(),
        title: Text("Registro de Nota"),
        actions: [
          provider.getAccount.id != "" && hasActiveAllotments
          ? FinishButton(value: "Salvar", isLoading: _isLoading, onPress: registerFeed)
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
                            child: Icon(Icons.lock_open_outlined),
                            ),  
                          )
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Chave de Acesso",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _accessKeyController.text,
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
                SizedBox(height: 10.0),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Número da Nota",
                            style: TextStyle(
                              color: DefaultColors.textGray(),
                              fontWeight: FontWeight.w500,
                              fontSize: 14
                            ),      
                          ),
                          Text(
                            _nfeNumberController.text,
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
                            _typeController.text,
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
                            "${NumberFormat.decimalPattern("pt_BR")
                              .format(double.parse(_weightController.text))} Kg",
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
                            "Transp.",
                            style: TextStyle(
                              color: DefaultColors.textGray(),
                              fontWeight: FontWeight.w500,
                              fontSize: 14
                            ),      
                          ),
                          Text(
                            _transporterController.text,
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
                                  _emmitedAtController.text,
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
                provider.getAccount.id.isNotEmpty && 
                widget.allotmentId == null &&
                hasActiveAllotments
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
                          menuMaxHeight: 300,
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
                              Icons.home_work_rounded,
                              size: 28,
                              color: DefaultColors.subTitleGray()
                            ),
                            filled: true,
                            fillColor: Colors.white
                          ),
                          onChanged: (String? value) {
                            if (value != null) {
                              _allotmentController.text = value;
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
                          value: matchingAviaryId != null && provider.getAviaries().any(
                            (aviary) => aviary.activeAllotmentId == matchingAviaryId
                          ) ? matchingAviaryId : null,
                          items:  provider.getAviaries()
                            .where((aviary) => aviary.activeAllotmentId != null)
                            .map((aviary) {
                              return DropdownMenuItem(
                                value: aviary.activeAllotmentId,
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