import 'package:demo_project/context/allotment_provider.dart';
import 'package:demo_project/context/data_provider.dart';
import 'package:demo_project/utils/default_colors.dart';
import 'package:demo_project/utils/status_tags.dart';
import 'package:demo_project/views/details.dart';
import 'package:demo_project/views/options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final allotmentProvider = context.read<AllotmentProvider>();

    return Consumer<DataProvider>(
      builder:(context, provider, child) {
        return Scaffold(
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
            child: SingleChildScrollView(
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
                        SizedBox(width: 10), // Spacing between containers
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
                    ListView.builder(
                      shrinkWrap: true,
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
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircularProgressIndicator(
                                            color: Colors.black,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            "Carregando detalhes...",
                                            style: TextStyle(
                                              color: DefaultColors.textGray(),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );

                              if (aviary.activeAllotmentId != null) {
                                await allotmentProvider.loadContext(aviary.activeAllotmentId!);
                              } else {
                                await allotmentProvider.cleanContext();
                              }

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
                  ],
                )
              ),
            )
          )
        );
      },
    );
  }
}