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







class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Informazioni Account", ),
      ),
      body: Column (crossAxisAlignment: CrossAxisAlignment.start, children: [

          Padding(padding: EdgeInsets.only(bottom:15, top: 50, left:20),child:Text("Nome: ", style: TextStyle(fontSize: 25) )),
        Padding(padding: EdgeInsets.only(bottom:15, left:20),child:Text("Cognome: ", style: TextStyle(fontSize: 25) )),
        Padding(padding: EdgeInsets.only(left:20), child: Text("Email: ",style: TextStyle(fontSize: 25), textAlign: TextAlign.left, )),
        Padding(padding: EdgeInsets.only(left:200,top: 100),child:
        Container(
          height: 50,
          width: 250,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(20)),
          child: ElevatedButton(
            onPressed: () {Navigator.pushNamed(context, '/login');},






            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        )),

        ],
      ),

      );
  }
}