import 'dart:async';

import 'package:demo_project/presentation/components/loading.dart';
import 'package:demo_project/presentation/provider/account_provider.dart';
import 'package:demo_project/presentation/provider/allotment_provider.dart';
import 'package:demo_project/domain/service/sync_service.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/widgets/tags/status_tags.dart';
import 'package:demo_project/presentation/views/details.dart';
import 'package:demo_project/presentation/views/options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  SyncService syncService = SyncService();
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
      syncService.syncrhronize();
    }

  });
  

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnection().hasInternetAccess;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ));

  @override
  Widget build(BuildContext context) {
    final allotmentProvider = context.watch<AllotmentProvider>();
    final provider = context.watch<AccountProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: DefaultColors.bgGray(),
      appBar: AppBar(
        backgroundColor: DefaultColors.bgGray(),
        title: Text("Aviários"),
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
                                style: TextStyle(
                                  color: DefaultColors.subTitleGray(),
                                  fontSize: 12
                                )
                              ),
                              Text(
                                  "${provider.getAccount.aviaries
                                    .where((a) => a.activeAllotmentId != null)
                                    .length
                                  }",
                                style: TextStyle(
                                  color: Color(0xFF38a169),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                ),
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
                                style: TextStyle(
                                  color: DefaultColors.subTitleGray(),
                                  fontSize: 12
                                )
                              ),
                              Text(
                                "${provider.getAccount.aviaries.length}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                ),
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
                    return Card(
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
                      child: ListTile(
                        leading: Icon(Icons.home_work),
                        title: aviary.activeAllotmentId != null 
                          ? StatusTags.getActiveTag(aviary.alias) 
                          : StatusTags.getInactiveTag(aviary.alias),
                        subtitle: Text(
                          aviary.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: DefaultColors.textGray(),
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 15,),
                        onTap: () async {
                          Loading.getLoading(context);
                          
                          if (aviary.activeAllotmentId != null) {
                            await allotmentProvider.loadContext( aviary.activeAllotmentId!);
                          } else {
                            await allotmentProvider.cleanContext();
                          }

                          if (!context.mounted) return;
                          Navigator.pop(context);
                        
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetailsPage(aviary: aviary))
                          );
                        }
                      )
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