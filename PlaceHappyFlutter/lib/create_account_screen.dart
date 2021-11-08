import 'dart:core';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:place_happy/dbhelper.dart';
import 'package:place_happy/tag.dart';
import 'package:sqflite/sqflite.dart';
import 'package:place_happy/place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';







class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Crea un nuovo account", ),
      ),
      body: Column (

    children: <Widget>[
      Padding(
        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
        padding:  EdgeInsets.only(
            left: 15.0, right: 15.0, top: 15, bottom: 0),
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nome',
          ),
        ),
      ),
      Padding(
        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
        padding:  EdgeInsets.only(
            left: 15.0, right: 15.0, top: 15, bottom: 0),
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Cognome',
          ),
        ),
      ),
    Padding(
    //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
    padding:  EdgeInsets.only(
    left: 15.0, right: 15.0, top: 15, bottom: 0),
    child: TextField(
    decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Email',
    ),
    ),
    ),
    Padding(
    padding: EdgeInsets.only(
    left: 15.0, right: 15.0, top: 15, bottom: 25),
    //padding: EdgeInsets.symmetric(horizontal: 15),
    child: TextField(

    obscureText: true,
    decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Password',
    ),
    ),
    ),
      Padding(padding: EdgeInsets.only(top: 25),child:Container(
        height: 50,
        width: 300,
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(20)),
        child: ElevatedButton(
          onPressed: () {



          },
          child: const Text(
            'Registrati', softWrap: true,
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      ))],
      ),

    );
  }}
