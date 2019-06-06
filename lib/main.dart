import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseApp app =  FirebaseApp.configure(
    name: 'db2',
    options: Platform.isIOS
        ? const FirebaseOptions(
            googleAppID: '1:890885856842:ios:578b8e53de67c136',
            gcmSenderID: '890885856842',
            databaseURL: 'https://tech-trivia-d9c05.firebaseio.com',
          )
        : const FirebaseOptions(
            googleAppID: '1:890885856842:android:a6fdf2106c9640b0',
            apiKey: 'AIzaSyBZgyLZit9y-ZEHsxOstK8fRChdZHNK0NI',
            databaseURL: 'https://tech-trivia-d9c05.firebaseio.com',
          ),
  ) as FirebaseApp;

final coolYello = Colors.amber[800];
void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Google'),
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String result = "Scan School ID";
  String btnTxt = "";
  Color btnColor;
  bool valid = false;

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        if((qrResult.indexOf("100") != -1) || (qrResult.indexOf("300") != -1)){ //checks if its a SBHS ID
            /*database.reference().child(qrResult).once().then((DataSnapshot snapshot) {
         result = snapshot.value;

    }); */
          result = qrResult;
          btnTxt = "Add Attendance";
          valid = true;
          btnColor = coolYello;
        } else{
          result = "Not School ID";
          valid = false;
          btnColor = Colors.grey[200];
          btnTxt = "";
        }
      });
    } on PlatformException catch (ex) {
        btnColor = Colors.grey[200];
        btnTxt = "";
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera Permission Denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
       result = "Scan School ID";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: coolYello,
        title: Text("ID Card Scanner"),
      ),
      body: Padding(
  padding: EdgeInsets.all(80.0),
  child: Center(
        child: Column(
          children: <Widget>[
          Text(
          result,
          style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
          RaisedButton(
            onPressed: () {
              if(valid == true){
              //result --> to get the value of the number
              //ANYTHING YOU WNT TO DO AFTER YOU CLICK THE BUTTON
              }
            },
            color:btnColor,
            child: Text(btnTxt, style: TextStyle(fontSize: 20),),
          ),
        ],)
      ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        backgroundColor: coolYello,
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}