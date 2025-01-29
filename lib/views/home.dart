import 'package:demo_project/context/data_provider.dart';
import 'package:demo_project/utils/default_colors.dart';
import 'package:demo_project/views/options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                                color: const Color.fromARGB(255, 173, 171, 171),
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
                                      "${provider.getAccount.aviaries.length}",
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
                                color: const Color.fromARGB(255, 173, 171, 171),
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
                              color: const Color.fromARGB(255, 173, 171, 171),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: ListTile(
                            leading: Icon(Icons.home_work),
                            title: Text(aviary.alias),
                            subtitle: Text(aviary.name),
                            trailing: Icon(Icons.arrow_forward_ios, size: 15,),
                            onTap: () {

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