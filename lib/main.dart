import 'dart:async';
import 'dart:io';

import 'package:demo_project/infra/factory/repository_factory.dart';
import 'package:demo_project/infra/factory/service_factory.dart';
import 'package:demo_project/infra/third_party/local_storage/secure_storage.dart';
import 'package:demo_project/presentation/provider/account_provider.dart';
import 'package:demo_project/presentation/provider/allotment_provider.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/views/home.dart';
import 'package:demo_project/presentation/views/login.dart';
import 'package:demo_project/presentation/views/xml_receiver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

final getIt = GetIt.instance;

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");

    getIt.registerSingleton<SecureStorage>(SecureStorage(storage: FlutterSecureStorage()));
    getIt.registerSingleton<RepositoryFactory>(RepositoryFactory());
    getIt.registerSingleton<ServiceFactory>(ServiceFactory());

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AllotmentProvider(
            allotmentService: getIt<ServiceFactory>().getAllotmentService()
          )),
          ChangeNotifierProvider(create: (_) => AccountProvider(
            authService: getIt<ServiceFactory>().getAuthService(),
            accountService: getIt<ServiceFactory>().getAccountService()
          ))
        ],
        child: const MyApp(),
      ),
    );
  }, (e, stackTrace) {
    debugPrint('Error in runZonedGuarded: $e');
    debugPrint('Stack trace: $stackTrace');
  });
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
      debugPrint("Error: $err");
    });

    ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) {
      _handleSharedFile(value);
    });
  }

  void _handleSharedFile(List<SharedMediaFile> files) async {
    if (files.isNotEmpty) {
      String path = files.first.path;

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
      home: Consumer<AccountProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<bool>(
            future: provider.authService.hasLoggedUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  backgroundColor: DefaultColors.bgGray(),
                  body: Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        backgroundColor: DefaultColors.valueGray(),
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
                return HomePage(syncService: getIt<ServiceFactory>().getSyncService());
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
