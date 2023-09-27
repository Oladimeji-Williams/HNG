// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_cv/providers/data_provider.dart';
import 'package:mobile_cv/screens/edit_page.dart';
import 'package:mobile_cv/screens/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final CVDataProvider dataProvider = CVDataProvider();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => MaterialApp(
        title: 'Mobile CV',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: HomePage(dataProvider),
        routes: {
          '/edit': (context) => EditPage(dataProvider),
        },
      ),
    );
  }
}
