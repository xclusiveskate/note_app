import 'package:flutter/material.dart';
import 'package:note_app/ui/home.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const MyNoteApp(),
        // initialRoute: '/',
        // routes: {
        //   '/': (context) => const MyNoteApp(),
        //   '/editpage': (context) => const EditPage(),
        //   '/categorypage': (context) => const CategoryScreen()
        // },
      ),
    );
  }
}
