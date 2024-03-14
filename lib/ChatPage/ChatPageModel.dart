import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vojo/backend/backend.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _MessageCollection = _firestore.collection("chat");

class ChatPageModel{
  static Future<Response> createChat({
    required String uid,
    required bool isUser,
    required String content,

  }) async {

    Response response = Response();
    DocumentReference documentReferencer =
    _MessageCollection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "user_id": uid,
      "isUser" : isUser,
      "content" : content,
      'dateTime' : DateTime.now(),


    };

    var result = await documentReferencer
        .set(data)
        .whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added the Chat";
      print("Sucessfully added the Chat");
    })
        .catchError((e) {
      response.code = 500;
      //response.message = e;
      print("$e");
    });
    String documentId = documentReferencer.id;

    return response ;
  }


}