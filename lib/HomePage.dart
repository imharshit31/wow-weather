// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
//import 'package:geolocator/geolocator.dart';
import 'location.dart';
import 'package:http/http.dart';

const apikey = '24499d32bccc19d09cafbfda5a4d3665';
late double latitude;
late double longitude;
bool showWait = false;
String city = 'finding city';
double temp = -1;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void getLocation() async {
    print('inside get location');

    Location location = Location();
    await location.getCurrentLocation();

    setState(() {
      showWait = true;
    });

    latitude = location.latitude;
    longitude = location.longitude;

    print(latitude);
    print(longitude);

    print('calling get data');

    getData();
  }

  void getData() async {
    print('inside get data');

    Uri uri = Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apikey');
    Response response = await get(uri);

    print('got response');
    // print('yahan');
    // print(response.body);
    // print('here');
    if (response.statusCode == 200) {
      print('in if');
      String data = response.body;
      var decodeData = jsonDecode(data);

      temp = decodeData['main']['temp']-273.15;
      city = decodeData['name'];
      print('temp is');
      print(temp);
      print('yes');
      print(city);
    } else {
      print('else');
      print(response.statusCode);
    }

    setState(() {
      showWait = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  void buttonpressed(){

    setState(() {
      showWait=true;
    });

    getData();
  }

  @override
  Widget build(BuildContext context) {

    print('Build');


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wow Weather',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 160,
          ),
          Container(
            height: 300,
            width: 300,
            child: Column(children: [
              Visibility(
                visible: showWait,
                child: Lottie.asset(
                  'assets/wait.json',
                ),
              ),
              Visibility(
                visible: !showWait,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'City:',
                          style: TextStyle(
                            fontSize: 28,
                          ),
                        ),
                        Text(
                          city,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Temperature:',
                          style: TextStyle(
                            fontSize: 28,
                          ),
                        ),
                        Text(
                          temp.toStringAsFixed(3)+'°C',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ]),
          ),
          SizedBox(
            height: 150,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              height: 55,
              width: 110,
              child: ElevatedButton(
                  onPressed: getData,
                  child: Text(
                    'Refresh',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )),
            ),
          ])
        ],
      ),
    );
  }
}
