import 'dart:core';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:place_happy/plac_tag_arg.dart';
import 'package:place_happy/tag.dart';
import 'package:sqflite/sqflite.dart';
import 'package:place_happy/place.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  var _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PlaceTagArg;
    _user = args.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Informazioni Account", ),
      ),
      body: Column (crossAxisAlignment: CrossAxisAlignment.start, children: [

          Padding(padding: EdgeInsets.only(bottom:15, top: 50, left:20),child:Text("Nome: ", style: TextStyle(fontSize: 25) )),
        Padding(padding: EdgeInsets.only(bottom:15, left:20),child:Text("Cognome: ", style: TextStyle(fontSize: 25) )),
        Padding(padding: EdgeInsets.only(left:20), child: Text(_user.email,style: TextStyle(fontSize: 25), textAlign: TextAlign.left, )),
        Padding(padding: EdgeInsets.only(left:200,top: 100),child:
        Container(
          height: 50,
          width: 250,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(20)),
          child: ElevatedButton(
            onPressed: () {Navigator.pushNamedAndRemoveUntil(context, '/login',ModalRoute.withName('/'));},
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