import 'map_screen.dart';
import 'package:flutter/material.dart';
void main()
{
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(useMaterial3: true),
    home: MapScreen(),
  ));
}