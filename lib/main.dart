import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) =>
      MaterialApp(
        theme: ThemeData.dark(),
        home: loc(),);
}

class loc extends StatefulWidget {
  @override
  _locState createState() => _locState();
}

class _locState extends State<loc> {
  var Lat;
  var Lon;
  var permission;
  late Position currentLocation;
  var temp;
  var feelslike;
  var place;
  var desc;
  var descarr = [];
  var desctemp;
  var country;
  var icon;
  var pic;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLocation();
  }

  Future<Position> locateUser() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();}

    return Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  void getData() async {
    Response response = await get (Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$Lat&lon=$Lon&appid=0d993d97f23b87ec4b24056d88fa90d7'));
    Map data = jsonDecode(response.body);
    setState(() {temp = (data["main"]["temp"]-273.15).toInt();
    feelslike = (data["main"]["feels_like"]-273.15).toInt();
    place = data["name"];
    descarr = data["weather"];
    desctemp = descarr[0];
    desc = desctemp["description"].toUpperCase();
    country = data["sys"]["country"];
    icon = data["weather"][0]["icon"];
    if (icon[2] == "n") {
      pic = "night";
    }
    else {
      pic = "afternoon";
    }
    print("$data");
    });}



  getUserLocation() async {
    currentLocation = await locateUser();
    setState(() {
      Lat = currentLocation.latitude;
      Lon = currentLocation.longitude;
    });
    print('latitude-$Lat and longitude-$Lon');
  }


  Widget build(BuildContext context) {
      getData();
      return MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Weather'),
            actions: [
              IconButton(onPressed: () {},
                  icon: Icon(Icons.search),)
            ],
            centerTitle: true,

          ),
          body: Stack(fit: StackFit.expand,
              children: <Widget>[Image(image: AssetImage('assets/${pic}_1.jpg'),
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.fill),
                Padding(padding: EdgeInsets.fromLTRB(100, 100, 0, 0),
                    child: Text('$desc',
                        style: TextStyle(
                            fontSize: 25))
                ),
                Padding(padding: EdgeInsets.fromLTRB(100, 800, 0, 0),
                    child: Text("$place,$country",
                        style: TextStyle(
                            fontSize: 31.25))
                ), Padding(
                  padding: EdgeInsets.fromLTRB(100, 820, 0, 0),
                  child: Text("$temp°",
                      style: TextStyle(
                          fontSize: 125)),
                ), Padding(
                  padding: EdgeInsets.fromLTRB(100, 950, 0, 0),
                  child: Text("Feels Like $feelslike°",
                      style: TextStyle(
                          fontSize: 18.75)),
                ), Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 460, 800),
                  child: Image(image: AssetImage('assets/$icon.png'),
                    height: 100,
                      width: 100),

                ),
              ]
          ),


        ),

      );

}}






