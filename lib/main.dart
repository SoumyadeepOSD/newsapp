import 'package:flutter/material.dart';
import 'package:newsapp/pages/actual.dart';
import 'package:newsapp/tabs/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newsapp/provider/stateprovider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".ENV");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Actual(),
      ),
    );
  }
}
