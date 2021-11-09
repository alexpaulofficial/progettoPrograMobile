import 'dart:core';
import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:place_happy/plac_tag_arg.dart';
import 'package:place_happy/tag.dart';
import 'package:sqflite/sqflite.dart';
import 'package:place_happy/place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  List _places = [];
  List _tags = [];
  final myControllerEmail = TextEditingController();
  final myControllerPass = TextEditingController();
  final myControllerNome = TextEditingController();
  final myControllerCognome = TextEditingController();
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerEmail.dispose();
    myControllerPass.dispose();
    myControllerNome.dispose();
    myControllerCognome.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('utenti');

    Future<void> addUser (String uid) {
      // Call the user's CollectionReference to add a new user
      return users
          .doc(uid)
        .set({
        'nome': myControllerNome.text, // John Doe
        'cognome': myControllerCognome.text, // Stokes and Sons
      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }
    final args = ModalRoute.of(context)!.settings.arguments as PlaceTagArg;
    _places = args.places;
    _tags = args.tags;
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
          controller: myControllerNome,
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
          controller: myControllerCognome,
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
      controller: myControllerEmail,
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
    controller: myControllerPass,
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
          onPressed: () async {
            try {
              UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: myControllerEmail.text,
                  password: myControllerPass.text
              );
              if (userCredential.user != 0)
              {
                var currentUser = FirebaseAuth.instance.currentUser;

                addUser(currentUser!.uid);
                Navigator.pushNamed(
                    context,
                    '/home',
                    arguments: PlaceTagArg(_places, _tags, currentUser)
                );
              }
            } on FirebaseAuthException catch (e) {
              Fluttertoast.showToast(
                  msg: e.code,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
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
