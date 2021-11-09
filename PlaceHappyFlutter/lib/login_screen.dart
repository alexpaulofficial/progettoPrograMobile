import 'dart:core';
import 'dart:core';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:place_happy/plac_tag_arg.dart';
import 'package:place_happy/tag.dart';
import 'package:sqflite/sqflite.dart';
import 'package:place_happy/place.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final myControllerEmail = TextEditingController();
  final myControllerPass = TextEditingController();
  bool _initialized = false;
  bool _error = false;
  bool logged = false;

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
    super.dispose();
  }
 List _placesLogin = [];
 List _tagsLogin = [];
 var currentUser;
  void ao () async {
  WidgetsFlutterBinding.ensureInitialized();
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
      join(await getDatabasesPath(), 'place_happy_database.db'),
  // When the database is first created, create a table to store dogs.
      onCreate: (db, version) async {
  // Run the CREATE TABLE statement on the database.
  await db.execute(
  'CREATE TABLE places (name TEXT PRIMARY KEY, description TEXT'
  ', address TEXT, shortDescr TEXT, latitude DOUBLE, longitude DOUBLE, image TEXT)'
  );
  await db.execute(
  'CREATE TABLE tags (tagName TEXT, place TEXT)'
  );
},
// Set the version. This executes the onCreate function and provides a
// path to perform database upgrades and downgrades.
version: 1,
);

// Define a function that inserts dogs into the database
Future<void> insertPlace(Place place) async {
  // Get a reference to the database.
  final db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'places',
    place.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
Future<void> insertTag(Tag tag) async {
  // Get a reference to the database.
  final db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'tags',
    tag.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// A method that retrieves all the dogs from the dogs table.
Future<List<Place>> places() async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('places');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return Place(

      name: maps[i]['name'],
      description: maps[i]['description'],
      shortDescr: maps[i]['shortDescr'],
      address: maps[i]['address'],
      latitude: maps[i]['latitude'],
      longitude: maps[i]['longitude'],
      image: maps[i]['image'],
    );
  });
}

// A method that retrieves all the dogs from the dogs table.
Future<List<Tag>> tags() async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('tags');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return Tag(

      tagName: maps[i]['tagName'],
      place: maps[i]['place'],

    );
  });
}

Future<void> updatePlace(Place place) async {
  // Get a reference to the database.
  final db = await database;

  // Update the given Dog.
  await db.update(
    'places',
    place.toMap(),
    // Ensure that the Dog has a matching id.
    where: 'name = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [place.name],
  );
}

Future<void> updateTag(Tag tag) async {
  // Get a reference to the database.
  final db = await database;

  // Update the given Dog.
  await db.update(
    'places',
    tag.toMap(),
    // Ensure that the Dog has a matching id.
    where: 'tagName = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [tag.tagName],
  );
}

Future<void> deletePlace(String name) async {
  // Get a reference to the database.
  final db = await database;

  // Remove the Dog from the database.
  await db.delete(
    'places',
    // Use a `where` clause to delete a specific dog.
    where: 'name = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [name],
  );
}

Future<void> deleteTag(String tagName) async {
  // Get a reference to the database.
  final db = await database;

  // Remove the Dog from the database.
  await db.delete(
    'tags',
    // Use a `where` clause to delete a specific dog.
    where: 'tagName = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [tagName],
  );
}
// Create a Dog and add it to the dogs table
var giardini_pubblici  = Place(
    name: 'Giardini Pubblici',
    description: 'I Giardini Pubblici di Jesi sono da sempre un luogo di incontro per persone di ogni età. Ci sono infatti giochi per bambini, come ad esempio scivoli,  altalene, una pista da pattinaggio, ma si possono trovare anche tavoli da ping pong, scacchi e molto altro. All\'interno è situato anche un bar denominato \'Lo Sbarello\', che offre pizza, gelati, ma anche drink e aperitivi, sempre con musica annessa.',
    shortDescr: 'Parco con giochi, bar e pineta.',
    address: '',
    latitude: 43.51839320285577,
    longitude: 13.229754169318705,
    image: 'giardini_pubblici.jpeg'
);
    var birreria_agostino  = Place(
    name: 'Birreria Sant\'Agostino',
    description: 'La Birreria Sant\'Agostino, situata nel cuore del centro di Jesi, è specializzata nelle birre artigianali. Qui si possono trovare infatti birre di ogni tipologia e nazionalità. Ci sono molte birre speciali belghe, tedesche, irlandesi, ma sicuramente anche le più classiche, come la Weiss e la Guinness. Il luogo è fornito  di tavoli sia all\'aperto, sia sotto un loggiato, con riscaldamento per l\'inverno. Possibilità di aperitivi.',
    shortDescr: 'Birreria fornita di varie birre artigianali.',
    address: '',
    latitude: 43.522838388573014,
    longitude:13.244360149177467 ,
    image: 'birreria_agostino.jpg'
    );
    var circolo_cittadino  = Place(
    name: 'Circolo Cittadino',
    description: 'Il Circolo Cittadino di Jesi è una struttura ormai storica di questa città, che mette al centro la socialità e l\'interazione fra i suoi soci. E\' dotato di molti campi da tennis, ma anche di un ristorante e di una sala convegni. Spesso inoltre sono organizzati tornei di biliardo o di giochi di carte, come ad esempio poker, bridge.',
    shortDescr: 'Centro sportivo, ricreativo e con ristorante.',
    address: '',
    latitude:43.5186092800265 ,
    longitude:13.23958652517758 ,
    image: 'circolo_cittadino.jpg'
    );
    var ciro_pio = Place(
    name: 'Ciro e Pio',
    description: 'Ciro e Pio è una gelateria storica di Jesi, presente nella città dal 1952. Qui si possono trovare gelati artigianali con una grande varietà di gusti.  Molto frequentata anche d\'inverno, grazie al suo spazio al coperto.',
    shortDescr: 'Gelati artigianali e altre specialità, dal 1952.',
    address: '',
    latitude: 43.522261352097956,
    longitude: 13.240193713598416 ,
    image: 'ciro_pio.jpg'
    );
    var hemingway = Place(
    name: 'Hemingway Cafè',
    description: 'Locale nel centro di Jesi, specializzato in drink e cocktails di ogni genere. Soprattutto nel weekend risulta frequentato da moltissimi giovani, in quanto si trova in un luogo molto centrale, comodo per ritrovarsi, e crea una bella atmosfera mettendo musica.',
    shortDescr: 'Musica, drink e cocktails di ogni tipo.',
    address: '',
    latitude: 43.522817250948364,
    longitude:13.244443942364535 ,
    image: 'hemingway.jpg'
    );

var a = Tag(tagName: 'Drink', place: 'Giardini Pubblici');
var b = Tag(tagName: 'Musica', place: 'Giardini Pubblici');
var c = Tag(tagName: 'Svago', place: 'Giardini Pubblici');
var d = Tag(tagName: 'Cibo', place: 'Giardini Pubblici');
    var e = Tag(tagName: 'Drink', place: 'Birreria Sant\'Agostino');
    var f = Tag(tagName: 'Cibo', place: 'Birreria Sant\'Agostino');
    var g = Tag(tagName: 'Cibo', place: 'Circolo Cittadino');
    var h = Tag(tagName: 'Svago', place: 'Circolo Cittadino');
    var i = Tag(tagName: 'Cibo', place: 'Ciro e Pio');
    var l = Tag(tagName: 'Drink', place: 'Hemingway Cafè');
    var m = Tag(tagName: 'Musica', place: 'Hemingway Cafè');

await insertPlace(giardini_pubblici);
await insertPlace(birreria_agostino);
await insertPlace(circolo_cittadino);
await insertPlace(ciro_pio);
await insertPlace(hemingway);
await insertTag(a);
await insertTag(b);
    await insertTag(c);
    await insertTag(d);
    await insertTag(e);
    await insertTag(f);
    await insertTag(g);
    await insertTag(h);
    await insertTag(i);
    await insertTag(l);
    await insertTag(l);
    await insertTag(m);
_placesLogin = await places();
_tagsLogin = await tags();

}

_LoginState () {
    ao();
    initializeFlutterFire();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body:
        Column(

          children: <Widget>[

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
            ), Padding(
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

            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: myControllerEmail.text,
                        password: myControllerPass.text
                    );
                    if (userCredential.user != 0)
                      {
                        var currentUser = FirebaseAuth.instance.currentUser;
                        Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                            ModalRoute.withName('/'),
                          arguments: PlaceTagArg(_placesLogin, _tagsLogin, currentUser),
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
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
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
                        email: "barry.allen@example.com",
                        password: "SuperSecretPassword!"
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                    }
                  } catch (e) {
                    print(e);
                  }

                  Navigator.pushNamed(
                  context,
                  '/createaccount', arguments: PlaceTagArg(_placesLogin, _tagsLogin, currentUser)
                );



                },
                child: const Text(
                  'Crea un nuovo account', softWrap: true,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            )),



          ],
        ),

    );
  }
}