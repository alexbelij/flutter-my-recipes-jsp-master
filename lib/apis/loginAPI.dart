import 'dart:async';

import 'package:Flavr/model/loginModel.dart';
import 'package:Flavr/ui/homeScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<LoginModel> loginAPI(
    BuildContext context, String email, String password) async {
  LoginModel loginModel;
  final url = "http://35.160.197.175:3006/api/v1/user/login";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Dio dio = new Dio();
  final response = await dio.post(url,
      data: {"email": email, "password": password}).catchError((dynamicError) {
    print("called error loop");
    prefs.setBool('authenticated', false);
    showDialogSingleButton(
        context, "Unable to Login", "Please Try Again", "OK");
  });

  if (response.statusCode == 200) {
    print("called if loop");
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
    await prefs.setBool('authenticated', true);
    prefs.setString("mail", email.toString());

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(email),
        ));
  }

  loginModel = LoginModel(
    response.data["email"],
    response.data["password"],
  );
  return loginModel;
}

void showDialogSingleButton(
    BuildContext context, String title, String message, String buttonLabel) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          new FlatButton(
            child: new Text(buttonLabel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}