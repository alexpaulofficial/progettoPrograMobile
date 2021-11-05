import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:place_happy/place_screen.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:place_happy/place.dart';


void main () async {
  runApp(const MyApp());




}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes : {
        '/' : (context) => const MyHomePage(),
       // '/place': (context) => PlaceScreen ()
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);



  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   int _currentIndex = 0;
   bool _place = false;
    List _places = [];
    int _currentPlace = 0;
   void db () async {
     // Avoid errors caused by flutter upgrade.
     // Importing 'package:flutter/widgets.dart' is required.
     WidgetsFlutterBinding.ensureInitialized();
     // Open the database and store the reference.
     final database = openDatabase(
       // Set the path to the database. Note: Using the `join` function from the
       // `path` package is best practice to ensure the path is correctly
       // constructed for each platform.
       join(await getDatabasesPath(), 'place_happy_database.db'),
       // When the database is first created, create a table to store dogs.
       onCreate: (db, version) {
         // Run the CREATE TABLE statement on the database.
         return db.execute(
           'CREATE TABLE places (name TEXT PRIMARY KEY, description TEXT'
               ', address TEXT, shortDescr TEXT, latitude DOUBLE, longitude DOUBLE, image TEXT)',
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
     // Create a Dog and add it to the dogs table
     var piazzarep = Place(
         name : 'Piazza della Repubblica',
         description: 'un bellissimo luogo, adesso è stata spostata la fontana ok',
         shortDescr: 'veramente stupefacente',
         address: 'via repubblica',
         latitude: 54.0,
         longitude: 27.3,
         image: 'IMMAGINE'
     );
     var piazzetta = Place(
         name : 'Piazza Colocci',
         description: 'un bruttissimo luogo, adesso è stata spostata la fontana ok',
         shortDescr: 'aaaaaaaaaaaaaaaaaaaaaa',
         address: 'via colli',
         latitude: 56.0,
         longitude: 20.3,
         image: 'AOOOOO'
     );

     await insertPlace(piazzarep);
     await insertPlace(piazzetta);
     _places = await places();


   }


   void onTabTapped(int index) {
     setState(() {
       _currentIndex = index;
       _place = false;
       if (_currentIndex==1)
         {
          db();
         }
     });
   }

   /*void onPlaceTapped() {
     setState(() {
       _place = true;

     });
   }*/

   Widget titleSetter () {
     if (_place == true) {
       return Text('Informazioni sul luogo');
     }

     if (_currentIndex == 0) {
       return Text('Home Page');
     }
     else if (_currentIndex == 1){
       return Text('Luoghi');}
     else {
       return Text('Tag');
     }

   }

   Widget bodySetter () {
    if (_place==true) {
      return Text(_places[_currentPlace].shortDescr);
    }

     if (_currentIndex == 0) {
       return Center(
           child:  FlutterMap (options:MapOptions(
             bounds: LatLngBounds(LatLng(43.4, 13.15), LatLng(43.6, 13.35)),
             boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(8.0)),
           ),
             layers: [
               TileLayerOptions(
                 urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                 subdomains: ['a', 'b', 'c'],
                 attributionBuilder: (_) {
                   return Text("© OpenStreetMap contributors");
                 },
               ),
               MarkerLayerOptions(
                 markers: [
                   Marker(
                     width: 30.0,
                     height: 30.0,
                     point: LatLng(43.52876, 13.24017),
                     builder: (ctx) =>
                       GestureDetector(child:  Icon(Icons.access_alarm_outlined),
                         onTap : () {print('tap');})
                   ),
                 ],
               ),
             ],
           )


       );
     }
     else if (_currentIndex == 1){
       return Column (children:[
         Expanded (child: ListView.separated(padding: const EdgeInsets.all(8),
       separatorBuilder: (BuildContext context, int index) => const Divider (),
       itemCount: _places.length,
       itemBuilder: (BuildContext context, int index){
         return GestureDetector(onTap: ()=> setState(() {
           _place = true;
           _currentPlace = index;

         }), child: Column (children :[ Text(_places[index].name),
           Text(_places[index].shortDescr),
           Text(_places[index].image),
         ]));
       }))]);


     }


     else {
       return Text('');
     }

   }




  @override
  Widget build(BuildContext context) {

   // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: titleSetter(),
      ),
      body: bodySetter() ,


      bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on_rounded),
          label: 'Luoghi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer_rounded),
          label: 'Tag',
        ),
      ],
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.purple[900],

    ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Place Happy'),

            ),
            ListTile(
              title: Text('Home'),
                 leading: Icon(Icons.local_offer_rounded)

            ),
            ListTile(
              title: Text('Gallery'),
                leading: Icon(Icons.local_offer_rounded)

            ),
            ListTile(
              title: Text('Account'),
                leading: Icon(Icons.local_offer_rounded)

            ),
          ],
        ),
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}





