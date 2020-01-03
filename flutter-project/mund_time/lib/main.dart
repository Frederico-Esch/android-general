import 'package:flutter/material.dart';
import 'package:mund_time/pages/home.dart';
import 'package:mund_time/pages/loading.dart';
import 'package:mund_time/pages/location.dart';
void main() => runApp(MaterialApp(
  initialRoute: '/', //testing purposes
  routes: {
    '/': (context) => Loading(),
    '/home' : (context) => HomeScreen(),
    '/location' : (context) => ChooseLocation(),
  },
));
