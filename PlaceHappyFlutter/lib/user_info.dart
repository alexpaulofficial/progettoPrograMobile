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
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  var _user;
  var _nome;
  var _congome;
  @override
  Widget build(BuildContext context) {
   //argomenti di navigazione
    final args = ModalRoute.of(context)!.settings.arguments as PlaceTagArg;
    _user = args.currentUser;
    //connessione al database dell'utente per recuperare i dati da visualizzare
    CollectionReference users = FirebaseFirestore.instance.collection('utenti');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(_user.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          _nome = data['nome'];
          _congome = data['cognome'];
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Informazioni Account", ),
            ),
            body: Column (crossAxisAlignment: CrossAxisAlignment.start, children: [

              Padding(padding: EdgeInsets.only(bottom:15, top: 50, left:20),child:Text("Nome: " + _nome, style: TextStyle(fontSize: 25) )),
              Padding(padding: EdgeInsets.only(bottom:15, left:20),child:Text("Cognome: " + _congome, style: TextStyle(fontSize: 25) )),
              Padding(padding: EdgeInsets.only(left:20), child: Text("Email: " + _user.email,style: TextStyle(fontSize: 25), textAlign: TextAlign.left, )),
              Padding(padding: EdgeInsets.only(left:200,top: 100),child:
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(context, '/login',ModalRoute.withName('/'));},
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
        return Scaffold();

      },
    );
  }
}