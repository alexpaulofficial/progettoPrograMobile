import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:place_happy/create_account_screen.dart';
import 'package:place_happy/plac_tag_arg.dart';
import 'package:place_happy/tag.dart';
import 'package:place_happy/user_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:place_happy/place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';


FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
const AndroidNotificationDetails androidPlatformChannelSpecifics =
AndroidNotificationDetails('1', 'Luogo Vicino',
    channelDescription: 'Notifica quando un luogo è vicino',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker');
const NotificationDetails platformChannelSpecifics =
NotificationDetails(android: androidPlatformChannelSpecifics);

void printHello() async {
  await flutterLocalNotificationsPlugin.show(
      0, 'Sei passato vicino a molti bei luoghi d''interesse',
      'Entra nell''app per tutte le info',
      platformChannelSpecifics,
      payload: 'item x');
}

void main () async {
  runApp(const MyApp());
  await AndroidAlarmManager.initialize();
  Future.delayed(const Duration(milliseconds: 100));
  final int helloAlarmID = 0;
  await AndroidAlarmManager.periodic(Duration(minutes: 10), helloAlarmID, printHello, wakeup: true, allowWhileIdle: true);
  }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes : {
        '/home' : (context) => const MyHomePage(),
       '/login': (context) => Login (),
        '/info': (context) => UserInformation(),
        '/createaccount': (context)=> CreateAccount()
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  bool _initialized = false;
  bool _error = false;

  //funzione asincrona che inizializza flutter
  void initializeFlutterFire() async {
    try {
     //aspetta che flutter si inizializzi e mette _initialized a true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Mette errore a true se si verifica un'eccezione
      setState(() {
        _error = true;
      });
    }
  }

  bool _enabled = true;
  int _status = 0;
  List _tagsStrings = [];
  bool _marker = false;
  List<DateTime> _events = [];
  int _currentIndex = 0;
  bool _place = false;
  List<Marker> _markers = <Marker>[];

  _MyHomePageState () {
    db();
    initializeFlutterFire();

  }

  List _places = [];
  List _tags = [];
  var _user;
  int _currentPlace = 0;
  String _tagName = '';
  List _placesByTag = [];
  double lat = 0;
  double long = 0;
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(43.51886, 13.227781),
    zoom: 16,
  );
  void notification() async {
  }
  void db() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
          if (payload != null) {
            debugPrint('notification payload: $payload');
          }});

  }
  //metodo eseguito al click dei tab della bottom bar
  //tramite setState cambio valore di variabili di stato e quindi si modifica l'interfaccia
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _place = false;
      _tagName = '';
    });
  }

  //gestione del bottone back di android per far sì che si torni sempre alla schermata precedente
 Future<bool> backbutton () async {
      if (_currentIndex==0){
        setState(() {
          _place=false;
        });
    return true;
      }
      if ((_tagName!='')){
        if (_place==true) {
          setState(() {
            _place = false;
            _currentIndex = 1;
          });
          return false;
        }
        else {
          setState(() {
            _place = false;
            _currentIndex = 2;

          });
          return false;
        }

      }
      else if((_tagName=='')&&(_place == true)){
        if (_marker == true)
          {
            setState(() {
              _currentIndex=0;
              _place=false;
              _marker=false;

            });
            return false;
          }
        else {
          setState(() {
            _place = false;
          });
          return false;
        }
      }

      else {
        setState(() {_currentIndex = 0;
      _place = false;
        });
        return false;
      }

 }
  //metodo che setta il titolo in base al valore di variabili di stato
  Widget titleSetter() {
    if (_place == true) {
      return Text('Informazioni sul luogo');
    }

    if (_currentIndex == 0) {
      return Text('Home Page');
    }
    else if (_currentIndex == 1) {
      if (_tagName != '') {
        return Text('Luoghi con il tag #$_tagName');
      }
      else {
        return Text('Luoghi');
      }
    }
    else {
      return Text('Tag');
    }
  }


  //metodo che setta il body in base al valore di variabili di stato
  Widget bodySetter() {
    //se place è true visualizza il luogo
    if (_place == true) {

      if(_tagName!= '')
      { return Column(

          children: [  Padding( padding: EdgeInsets.symmetric(vertical: 20),child: Text(_placesByTag[_currentPlace].name)),
            Container(width: 360,
                height: 160,
                child: Image.asset(
                    'images/' + (_placesByTag[_currentPlace].image)))
            ,
            Padding( padding:EdgeInsets.only(top:20, left:20, bottom:20), child: Center(child: Text(_placesByTag[_currentPlace].description, softWrap: true,)))]);


      }
      else {
        return Column(

          children: [  Padding( padding: EdgeInsets.symmetric(vertical: 20),child: Text(_places[_currentPlace].name)),
            Container(width: 360,
                height: 160,
                child: Image.asset(
                    'images/' + (_places[_currentPlace].image)))
            ,
            Padding( padding: EdgeInsets.only(top:20, left:20, bottom:20), child: Center(child: Text(_places[_currentPlace].description, softWrap: true,)))]);
      }
    }
    //se l'index è 0 visualizza la mappa
    if (_currentIndex == 0) {
      for (var i = 0 ; i < _places.length; i++ ) {
        _markers.add(
            Marker(
                markerId: MarkerId(i.toString()),
                position: LatLng(_places[i].latitude, _places[i].longitude),
                infoWindow: InfoWindow(
                  title: _places[i].name,
                  onTap: () =>
                      setState(() {
                        _marker=true;
                        _tagName='';
                        _currentIndex=1;


                        _place = true;
                        _currentPlace = i;


                      }),
                )
            )
        );
      }
      return Center(
        child: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set<Marker>.of(_markers),
          myLocationEnabled: true,
        ),

      );
    }
    //se l'index è 1 visualizza la lista dei luoghi
    else if (_currentIndex == 1) {
      if (_tagName != '') {
        return Column(children: [
          Expanded(child: ListView.separated(padding: const EdgeInsets.all(8),
              separatorBuilder: (BuildContext context,
                  int index) => const Divider (),
              itemCount: _placesByTag.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(onTap: () =>
                    setState(() {
                      _place = true;
                      _currentPlace = index;
                    }),
                    child:Center(child:  Column(
                        children: [ Padding(padding: EdgeInsets.only(top: 20, bottom:15), child:Text(_places[index].name, softWrap: true,)),


                          Container(width: 120,
                              height: 68,
                              child: Image.asset(
                                  'images/' + (_placesByTag[index].image))),
                          Padding(padding: EdgeInsets.only(top:20, bottom:30), child:Text(_placesByTag[index].shortDescr, softWrap: true,))]),


                    ));
              }))
        ]);
      }
      else {
        return Column(children: [
          Expanded(child: ListView.separated(padding: const EdgeInsets.all(8),
              separatorBuilder: (BuildContext context,
                  int index) => const Divider (),
              itemCount: _places.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(onTap: () =>
                    setState(() {
                      _place = true;
                      _currentPlace = index;
                    }),
                    child: Center(child:  Column(
                            children: [ Padding(padding: EdgeInsets.only(top: 20, bottom:15), child:Text(_places[index].name, softWrap: true,)),


                              Container(width: 120,
                                  height: 68,
                                  child: Image.asset(
                                      'images/' + (_places[index].image))),
                              Padding(padding: EdgeInsets.only(top:20, bottom:30), child:Text(_places[index].shortDescr, softWrap: true,))]),


                          ));
              }))
        ]);
      }
    }

  //se l'index è 2 visualizza la lista dei tag
    else {
      return Column(children: [
        Expanded(child: ListView.separated(padding: const EdgeInsets.all(8),
            separatorBuilder: (BuildContext context,
                int index) => const Divider (),
            itemCount: _tagsStrings.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(onTap: () =>
                  setState(() {
                    _placesByTag = [];
                    _currentIndex = 1;
                    _tagName = _tagsStrings[index];
                    var tag;
                    var place;
                    for (tag in _tags) {
                      if (tag.tagName == _tagName) {
                        for (place in _places) {
                          if (place.name == tag.place) {
                            if (!(_placesByTag.contains(place))) {
                              _placesByTag.add(place);
                            }
                          }
                        }
                      }
                    }
                  }),
                  child: Container(height: 100,
                      child: Center(child: Text(
                        '#${_tagsStrings[index]}', textScaleFactor: 3,))));
            }))
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    //argomenti di navigazione ricevuti
    final args = ModalRoute.of(context)!.settings.arguments as PlaceTagArg;
    _places = args.places;
    _tags = args.tags;
    _user = args.currentUser;
    for (var k =0; k<_tags.length; k++){
    if (!_tagsStrings.contains(_tags[k].tagName))
     {
       _tagsStrings.add(_tags[k].tagName);
     }
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return WillPopScope (onWillPop: ()  =>backbutton()

    ,child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: titleSetter(),
        ),
        body: bodySetter(),


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
            children:  [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Place Happy'),

              ),
              ListTile(
                  title: Text('Account'),
                  leading: Icon(Icons.home),
                onTap: (){ Navigator.pushNamed(context,'/info',  arguments: PlaceTagArg(_places, _tags, _user)
                );},


              ),


            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }


}




