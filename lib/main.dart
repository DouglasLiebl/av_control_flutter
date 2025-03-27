import 'dart:io';

import 'package:demo_project/context/allotment_provider.dart';
import 'package:demo_project/context/data_provider.dart';
import 'package:demo_project/views/home.dart';
import 'package:demo_project/views/login.dart';
import 'package:demo_project/views/xml_receiver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => AllotmentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? fileContent;

   @override
  void initState() {
    super.initState();

    ReceiveSharingIntent.instance.getMediaStream().listen((List<SharedMediaFile> value) {
      _handleSharedFile(value);
    }, onError: (err) {
      print("Error: $err");
    });

    // Handle shared files when the app is launched
    ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) {
      _handleSharedFile(value);
    });
  }

    void _handleSharedFile(List<SharedMediaFile> files) async {
    if (files.isNotEmpty) {
      String path = files.first.path;
      print("Received file path: $path");

      // Read the file content
      File file = File(path);
      String content = await file.readAsString();

      setState(() {
        fileContent = content;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<DataProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<bool>(
            future: provider.dbHelper.hasLocalData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 4,
                      ),
                    )
                  )
                );
              }

             if (fileContent != null) {
                return XmlReceiver(
                  xmlContent: fileContent!, 
                  changeState: () => setState(() {
                    fileContent = null;
                  }));
              } else if (snapshot.hasData && snapshot.data == true) {
                return HomePage();
              } else {
                return LoginPage();
              }
            },
          );
        }
      ),
    );
  }
}
