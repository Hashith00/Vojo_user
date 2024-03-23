import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vojo/ChatPage/ChatPageModel.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:vojo/backend/backend.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final textController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  var userId;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = _auth.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection("chat").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // Use hasData instead of != null
                      final messages = snapshot.data!.docs;
                      List<Widget> messagesList =
                          []; // Use camelCase for variable names

                      for (var message in messages) {
                        final messageData = message.data()
                            as Map<String, dynamic>; // Explicit cast

                        final messageText = messageData["position"];
                        final containers = Container(
                          child: Column(
                            children: [
                              Container(
                                child: (messageData["isUser"] == true) ? Container(
                                  margin: EdgeInsets.only(left: 260),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blueAccent
                                  ),
                                  child: Text(
                                    "Me : ${messageData["content"]}",
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                ) : Container(
                                  margin: EdgeInsets.only(right: 220),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue.shade400
                                  ),
                                  child: Text(
                                    "Admin : ${messageData["content"]}",
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,)
                            ],
                          ),
                        );
                        if(messageData["user_id"] == userId){
                          messagesList.add(containers);
                        }

                      }

                      return Column(
                        children: messagesList,
                      );
                    } else if (snapshot.hasError) {
                      // Handle the error case
                      return Text("Error: ${snapshot.error}");
                    } else {
                      return CircularProgressIndicator(); // Show a loading indicator
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 80,
                      width: 370,
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextFormField(
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(

                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  FlutterFlowTheme.of(context).primaryBackground,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor:
                              FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        style: FlutterFlowTheme.of(context).bodyLarge,
                        controller: textController,
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                       Response response = Response();
                        response = await ChatPageModel.createChat(uid: userId, isUser: true, content: textController.value.text.toString());
                        print(response);
                        textController.clear();
                      },
                        child: Icon(Icons.send, size: 30,))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
