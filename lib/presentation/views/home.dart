import 'dart:async';

import 'package:demo_project/domain/entity/aviary.dart';
import 'package:demo_project/presentation/components/loading.dart';
import 'package:demo_project/presentation/provider/account_provider.dart';
import 'package:demo_project/presentation/provider/allotment_provider.dart';
import 'package:demo_project/domain/service/sync_service.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/style/default_typography.dart';
import 'package:demo_project/presentation/widgets/menu/home_item.dart';
import 'package:demo_project/presentation/views/details.dart';
import 'package:demo_project/presentation/views/options.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final SyncService syncService;
  const HomePage({super.key, required this.syncService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
    subscription = InternetConnection().onStatusChange.listen((status) async {

    if ((status == InternetStatus.connected)) {
      await widget.syncService.synchronize();
    }

  });
  

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<void> goToDetails(Aviary aviary) async {
    final allotmentProvider = context.read<AllotmentProvider>();
    Loading.getLoading(context);
                          
    if (aviary.activeAllotmentId != null) {
      await allotmentProvider.loadContext( aviary.activeAllotmentId!);
    } else {
      await allotmentProvider.cleanContext();
    }

    if (!mounted) return;
    Navigator.pop(context);
  
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailsPage(aviary: aviary))
    );
  }

  @override
  Widget build(BuildContext context) {
    
    final provider = context.watch<AccountProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: DefaultColors.bgGray(),
      appBar: AppBar(
        backgroundColor: DefaultColors.bgGray(),
        title: Text(
          "Aviários",
          style: DefaultTypography.appBar()
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => OptionsPage())
              );
            },
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return const Color.fromARGB(255, 153, 151, 151).withOpacity(0.2);
                  }
                  return null;
                },
              ),
            ),
            child: Icon(
              Icons.menu_rounded, 
              size: 30,
              color: Colors.black,
            ),
          )
        ]
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: DefaultColors.borderGray(),
                          width: 1
                        )
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Ativos",
                                style: DefaultTypography.countBox()
                              ),
                              Text(
                                  "${provider.getAccount.aviaries
                                    .where((a) => a.activeAllotmentId != null)
                                    .length
                                  }",
                                style: DefaultTypography.countBoxActiveValue()
                              )
                            ],
                          ),
                        )
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: DefaultColors.borderGray(),
                          width: 1
                        )
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Total",
                                style: DefaultTypography.countBox()
                              ),
                              Text(
                                "${provider.getAccount.aviaries.length}",
                                style: DefaultTypography.countBoxValue()
                              )
                            ],
                          ),
                        )
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: provider.getAccount.aviaries.length,
                  itemBuilder: (context, index) {
                    final aviary = provider.getAccount.aviaries[index];
                    return HomeItem(
                      aviary: aviary, 
                      onPress: () async => await goToDetails(aviary)
                    );
                  },
                ) 
              )
            ],
          )
        ),

      )
    );
  }

  
}