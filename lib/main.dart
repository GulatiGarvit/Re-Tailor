import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:retailor/Welcome/welcome_screen.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = 'L1tCCrbiiYskmdLx5fPm66NltSHTiYihhfAboWx8';
  final keyClientKey = 'Zi4eSjUD0wKokf2q6gJ0PtoZR7qpNryLGfbHsMFj';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
