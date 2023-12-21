import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Newpage extends StatefulWidget {
  const Newpage({super.key});

  @override
  State<Newpage> createState() => _NewpageState();
}

var _auth = FirebaseAuth.instance;
var user;

void getCurrentUer() async {
  try {
    user = _auth.currentUser;
  } catch (e) {}
}

class _NewpageState extends State<Newpage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
            child: Container(
          child: Text("${user.uid}"),
        )),
      ),
    );
  }
}
