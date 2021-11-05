import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PlaceScreen extends StatefulWidget {
  const PlaceScreen({Key? key}) : super(key: key);







  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
 String title = 'Informazioni sul luogo';
 int _currentIndex = 1;


void onTabTapped(index) {
  setState(() {
    _currentIndex = index;
  });
  Navigator.pushNamed(context, '/', arguments : PlaceScreenArguments(_currentIndex));
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
          title: Text(title),
        ),
        body:  Text('Qui ci sarà il luogo'),


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

class PlaceScreenArguments {
   int _index = 0;
  int get () {return _index;}
  PlaceScreenArguments(this._index);
}





