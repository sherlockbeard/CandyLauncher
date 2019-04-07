import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:launcher_assist/launcher_assist.dart';

void main() => runApp(new CandyLauncher());

class CandyLauncher extends StatefulWidget {
  @override
  State createState() => new _CandyLauncherState();
}

class _CandyLauncherState extends State<CandyLauncher> {
  var installedAppDetails;
  var userWallpaper;

  @override
  Widget build(BuildContext context) {
    if (installedAppDetails != null) {
      List<Widget> appWidgets = getAppIcons();
      return MaterialApp(
          home: Stack(children: <Widget>[
        userWallpaper == null
            ? Center()
            : Image.memory(userWallpaper,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity),
        Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: GridView.count(
                physics: const AlwaysScrollableScrollPhysics(),
                children: appWidgets,
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(16.0)))
      ]));
    } else {
      return Center();
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    loadNativeStuff();
  }

  void loadNativeStuff() {
    LauncherAssist.getAllApps().then((_appDetails) {
      setState(() {
        installedAppDetails = _appDetails;
      });
    });
    LauncherAssist.getWallpaper().then((_imageData) {
      setState(() {
        userWallpaper = _imageData;
      });
    });
  }

  getAppIcons() {
    List<Widget> appWidgets = [];
    for (var i = 0; i < installedAppDetails.length; i++) {
      if (installedAppDetails[i]["package"] == "com.progur.candy") continue;
      var label = Text(installedAppDetails[i]["label"],
          style: TextStyle(
              fontSize: 10.0,
              color: Colors.white,
              decoration: TextDecoration.none,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.normal),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center);
      var labelContainer = Container(
          decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: label,
          padding: EdgeInsets.all(4.0),
          margin: EdgeInsets.only(top: 4.0));
      var icon = Image.memory(installedAppDetails[i]["icon"],
          fit: BoxFit.scaleDown, width: 48.0, height: 48.0);
      appWidgets.add(GestureDetector(
          onTap: () {
            launchApp(installedAppDetails[i]["package"]);
          },
          child: GridTile(
              child: Column(children: <Widget>[icon, labelContainer]))));
    }
    return appWidgets;
  }

  void launchApp(String packageName) {
    LauncherAssist.launchApp(packageName);
  }
}
