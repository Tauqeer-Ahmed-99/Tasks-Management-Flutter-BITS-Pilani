// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:task_back4app/providers/task_provider.dart';
import 'package:task_back4app/providers/user_provider.dart';
import 'package:task_back4app/screens/auth.dart';
import 'package:task_back4app/screens/details.dart';
import 'package:task_back4app/screens/home.dart';

void main() async {
  await dotenv.load();

  final APPLICATION_ID = dotenv.env['APPLICATION_ID'];
  final CLIENT_KEY = dotenv.env['CLIENT_KEY'];
  final API_KEY = dotenv.env['API_KEY'];

  final PARSE_SERVER_URL = dotenv.env['PARSE_SERVER_URL'];

  WidgetsFlutterBinding.ensureInitialized();

  await Parse().initialize(APPLICATION_ID as String, PARSE_SERVER_URL as String,
      clientKey: CLIENT_KEY, autoSendSessionId: true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'Taskss App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff152534)),
          useMaterial3: true,
        ),
        routes: {
          AuthScreen.route: (context) => const AuthScreen(),
          HomeScreen.route: (context) => const HomeScreen(),
          DetailsScreen.route: (context) => const DetailsScreen(),
        },
        home: Consumer<UserProvider>(
          builder: (context, user, child) =>
              user.isLoggedIn ? const HomeScreen() : const AuthScreen(),
        ),
      ),
    );
  }
}
