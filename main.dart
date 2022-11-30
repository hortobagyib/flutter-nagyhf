import 'package:flutter/material.dart';
import 'package:my_app/beer_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized;
  await Firebase.initializeApp(
      // Replace with actual values
      options: const FirebaseOptions(
          apiKey: "AIzaSyDjSVujt9oKMNn-hHLMI4aV2k6BGpuko4g",
          authDomain: "nagyhazi-81f20.firebaseapp.com",
          projectId: "nagyhazi-81f20",
          storageBucket: "nagyhazi-81f20.appspot.com",
          messagingSenderId: "570143657896",
          appId: "1:570143657896:web:89632eda5324eea226d79d",
          measurementId: "G-N161JVFEB1"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List of Beers',
      theme: ThemeData(
        colorScheme:
            const ColorScheme.light(primary: Color.fromRGBO(255, 180, 0, 1)),
      ),
      home: FutureBuilder(
          future: _initialization,
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return const BeerListScreen();
            }
            return const CircularProgressIndicator();
          })),
    );
  }
}
