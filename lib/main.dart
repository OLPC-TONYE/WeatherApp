import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: "Weather App",
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  var temp;
  var locationCountry;
  var locationName;
  var condition;
  var time;
  var weatherIcon;

  Future getWeather() async {
    http.Response response = await http.get(
        "https://api.weatherapi.com/v1/current.json?key=ba98ac910ebc42a4b79191541210207&q=auto:ip");
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results["current"]["temp_c"];
      this.condition = results["current"]["condition"]["text"];
      this.weatherIcon = results["current"]["condition"]["icon"];
      this.locationCountry = results["location"]["country"];
      this.locationName = results["location"]["name"];
      this.time = results["location"]["localtime_epoch"];
    });
  }

  IconData decideIcon(dynamic condition) {
    var timeOfDay = timeDecode(this.time);
    if (timeOfDay == "Day") {
      if (condition.toString().contains("thunder") &&
          condition.toString().contains("rain")) {
        return FontAwesomeIcons.cloudSunRain;
      } else if (condition.toString().contains("rain")) {
        return FontAwesomeIcons.cloudRain;
      } else if (condition.toString().contains("cloud")) {
        return FontAwesomeIcons.cloudSun;
      } else {
        return FontAwesomeIcons.sun;
      }
    } else {
      if (condition.toString().contains("thunder") &&
          condition.toString().contains("rain")) {
        return FontAwesomeIcons.cloudMoonRain;
      } else if (condition.toString().contains("rain")) {
        return FontAwesomeIcons.cloudRain;
      } else if (condition.toString().contains("cloud")) {
        return FontAwesomeIcons.cloudMoon;
      } else {
        return FontAwesomeIcons.moon;
      }
    }
  }

  String timeDecode(dynamic time) {
    var currentTime = DateTime.now();
    if (currentTime.hour >= 5 && currentTime.hour <= 17) {
      return "Day";
    } else {
      return "Night";
    }
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.55,
            color: Colors.white,
            child: Center(
                child: FaIcon(
              decideIcon(condition),
              size: MediaQuery.of(context).size.width * 0.65,
              color: Colors.blueAccent,
            )),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width,
            color: Colors.blue,
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 20.0)),
                Text(
                  temp != null ? temp.toString() + "\u00B0C" : "Loading...",
                  style: TextStyle(
                      fontSize: 68.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                Text(
                  locationName != null ? locationName.toString() : "Loading...",
                  style: TextStyle(fontSize: 25.0, color: Colors.white),
                ),
                Text(
                  locationCountry != null
                      ? locationCountry.toString()
                      : "Loading...",
                  style: TextStyle(fontSize: 25.0, color: Colors.white),
                ),
                Text(
                  condition != null ? condition.toString() : "Loading...",
                  style: TextStyle(fontSize: 25.0, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
