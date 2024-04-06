import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/firebase_auth/auth_util.dart';

import '../flutter_flow/flutter_flow_util.dart';
import 'schema/util/firestore_util.dart';

import 'schema/users_record.dart';
import 'schema/user_col_record.dart';

export 'dart:async' show StreamSubscription;
export 'package:cloud_firestore/cloud_firestore.dart';
export 'schema/index.dart';
export 'schema/util/firestore_util.dart';
export 'schema/util/schema_util.dart';

export 'schema/users_record.dart';
export 'schema/user_col_record.dart';

/// Functions to query UsersRecords (as a Stream and as a Future).
Future<int> queryUsersRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      UsersRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<UsersRecord>> queryUsersRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      UsersRecord.collection,
      UsersRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<UsersRecord>> queryUsersRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      UsersRecord.collection,
      UsersRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query UserColRecords (as a Stream and as a Future).
Future<int> queryUserColRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      UserColRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<UserColRecord>> queryUserColRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      UserColRecord.collection,
      UserColRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<UserColRecord>> queryUserColRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      UserColRecord.collection,
      UserColRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<int> queryCollectionCount(
  Query collection, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0) {
    query = query.limit(limit);
  }

  return query.count().get().catchError((err) {
    print('Error querying $collection: $err');
  }).then((value) => value.count);
}

Stream<List<T>> queryCollection<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query.snapshots().handleError((err) {
    print('Error querying $collection: $err');
  }).map((s) => s.docs
      .map(
        (d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList());
}

Future<List<T>> queryCollectionOnce<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query.get().then((s) => s.docs
      .map(
        (d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList());
}

extension QueryExtension on Query {
  Query whereIn(String field, List? list) => (list?.isEmpty ?? true)
      ? where(field, whereIn: null)
      : where(field, whereIn: list);

  Query whereNotIn(String field, List? list) => (list?.isEmpty ?? true)
      ? where(field, whereNotIn: null)
      : where(field, whereNotIn: list);

  Query whereArrayContainsAny(String field, List? list) =>
      (list?.isEmpty ?? true)
          ? where(field, arrayContainsAny: null)
          : where(field, arrayContainsAny: list);
}

class FFFirestorePage<T> {
  final List<T> data;
  final Stream<List<T>>? dataStream;
  final QueryDocumentSnapshot? nextPageMarker;

  FFFirestorePage(this.data, this.dataStream, this.nextPageMarker);
}

Future<FFFirestorePage<T>> queryCollectionPage<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  DocumentSnapshot? nextPageMarker,
  required int pageSize,
  required bool isStream,
}) async {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection).limit(pageSize);
  if (nextPageMarker != null) {
    query = query.startAfterDocument(nextPageMarker);
  }
  Stream<QuerySnapshot>? docSnapshotStream;
  QuerySnapshot docSnapshot;
  if (isStream) {
    docSnapshotStream = query.snapshots();
    docSnapshot = await docSnapshotStream.first;
  } else {
    docSnapshot = await query.get();
  }
  final getDocs = (QuerySnapshot s) => s.docs
      .map(
        (d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList();
  final data = getDocs(docSnapshot);
  final dataStream = docSnapshotStream?.map(getDocs);
  final nextPageToken = docSnapshot.docs.isEmpty ? null : docSnapshot.docs.last;
  return FFFirestorePage(data, dataStream, nextPageToken);
}

// Creates a Firestore document representing the logged in user if it doesn't yet exist
Future maybeCreateUser(User user) async {
  final userRecord = UsersRecord.collection.doc(user.uid);
  final userExists = await userRecord.get().then((u) => u.exists);
  if (userExists) {
    currentUserDocument = await UsersRecord.getDocumentOnce(userRecord);
    return;
  }

  final userData = createUsersRecordData(
    email: user.email ??
        FirebaseAuth.instance.currentUser?.email ??
        user.providerData.firstOrNull?.email,
    displayName:
        user.displayName ?? FirebaseAuth.instance.currentUser?.displayName,
    photoUrl: user.photoURL,
    uid: user.uid,
    phoneNumber: user.phoneNumber,
    createdTime: getCurrentTimestamp,
  );

  await userRecord.set(userData);
  currentUserDocument = UsersRecord.getDocumentFromData(userData, userRecord);
}

Future updateUserDocument({String? email}) async {
  await currentUserDocument?.reference
      .update(createUsersRecordData(email: email));
}

// Creating Firebase instances
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('trips');
final CollectionReference _CollectionTip = _firestore.collection('temptrip');
final CollectionReference _CollectionBooking = _firestore.collection("bookings");

// create Response Class to store formatted response
  class Response{
    int? code;
    String? message;
    Response({this.code,this.message});
  }

  // Update Employee details
    Future<Response> updateEmployee({
    required String name,
    required String position,
    required String contactno,
    required String docId,
    }) async {
    Response response = Response();
    DocumentReference documentReferencer =
    _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
    "employee_name": name,
    "position": position,
    "contact_no" : contactno
    };

    await documentReferencer
        .update(data)
        .whenComplete(() {
    response.code = 200;
    response.message = "Sucessfully updated Employee";
    })
        .catchError((e) {
    response.code = 500;
    response.message = e;
    });

    return response;
    }


// Update Trip details where trip is ready to show in the riders app
Future<Response> UpdateTripStatustoConfiremed({
  required String docId,
}) async {
  Response response = Response();
  DocumentReference documentReferencer =
  _CollectionTip.doc(docId);

  Map<String, dynamic> data = <String, dynamic>{
    "is_confirmed": true,
  };

  await documentReferencer
      .update(data)
      .whenComplete(() {
    response.code = 200;
    response.message = "Sucessfully updated Trip";
  })
      .catchError((e) {
    response.code = 500;
    response.message = e;
  });

  return response;
}


// Add Travelling Mode
updateTravellingMode({
  required String travallingMode,
  required String docId,
}) async {
  Response response = Response();
  DocumentReference documentReferencer =
  _CollectionTip.doc(docId);

  Map<String, dynamic> data = <String, dynamic>{
    "travelling_mode": travallingMode,
  };

  await documentReferencer
      .update(data)
      .whenComplete(() {
    response.code = 200;
    response.message = "Sucessfully updated Trip Travelling Mode";
  })
      .catchError((e) {
    response.code = 500;
    response.message = e;
  });

  return response.message;
}

// Creating new trip record
addTrip({
    required String uid,
    required String type,
    required String startDate,
    required String endDate,
    required String startLocation,
    required String endLocation,
    String intermidiateLocation = "",
    String riderId = "",
    String travellingMode = "",
  required int cost,
  required double distance,
  double? startLocationLatitude,
  double? startLocationLongitude,
  double? endLocationLatitude,
  double? endLocationLongitude,
  double? intermediateLocationLatitude,
  double? intermediateLocationLongitude,
  String? duration


  }) async {

    Response response = Response();
    DocumentReference documentReferencer =
    _CollectionTip.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "user_id": uid,
      "trip_type": type,
      "start_date" : startDate,
      "end_date" : endDate,
      "start_location" : startLocation,
      "end_location" : endLocation,
      "intermediate_location" : intermidiateLocation,
      "Rider_id" : riderId,
      "is_confirmed" : false,
      "travelling_Mode" : travellingMode,
      "cost" : cost,
      "distance" : distance,
      "startLocationLatitude" : startLocationLatitude,
      "startLocationLongitude" : startLocationLongitude,
      "endLocationLatitude" : endLocationLatitude,
      "endLocationLongitude" : endLocationLongitude,
      "intermediateLocationLatitude" : intermediateLocationLatitude,
      "intermediateLocationLongitude" : intermediateLocationLongitude,
      "duration" : duration

    };

    var result = await documentReferencer
        .set(data)
        .whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the Trip";
      print("Sucessfully added to the Trip");
    })
        .catchError((e) {
      response.code = 500;
      //response.message = e;
      print("$e");
    });
    String documentId = documentReferencer.id;

    return documentId ;
  }

// Deleting A trip
Future<Response> deleteTrip({
required String docId,
}) async {
Response response = Response();
DocumentReference documentReferencer =
_CollectionTip.doc(docId);

await documentReferencer
    .delete()
    .whenComplete((){
response.code = 200;
response.message = "Sucessfully Deleted Employee";
})
    .catchError((e) {
response.code = 500;
response.message = e;
});

return response;
}

getTripDetails({required String docId})async{
  CollectionReference trips = _firestore.collection('temptrip');
  DocumentSnapshot snapshot = await trips.doc(docId).get();
  var userData = snapshot.data() as Map<String, dynamic>;

  return userData;

}

updateTripStartDate({required String docId, required String date})async{
  DocumentReference documentReferencer =
  _CollectionTip.doc(docId);

  Map<String, dynamic> data = <String, dynamic>{
    "start_date": date,
  };

  Response response = Response();

  var res = await documentReferencer.update(data).then((value) => {
    response.code = 200,
    response.message = "Update the Staring Date"
  });

  return response;

}

updateTripEndDate({required String docId, required String date})async{
  DocumentReference documentReferencer =
  _CollectionTip.doc(docId);

  Map<String, dynamic> data = <String, dynamic>{
    "end_date": date,
  };

  Response response = Response();

  var res = await documentReferencer.update(data).then((value) => {
    response.code = 200,
    response.message = "Update the ending Date"
  });

  return response;

}
updateTripStartLocation({required String docId, required String startLocation})async{
  DocumentReference documentReferencer =
  _CollectionTip.doc(docId);

  Map<String, dynamic> data = <String, dynamic>{
    "start_location": startLocation,
  };

  Response response = Response();

  var res = await documentReferencer.update(data).then((value) => {
    response.code = 200,
    response.message = "Update the start location"
  });

  return response;

}
updateTripEndLocation({required String docId, required String endLocation})async{
  DocumentReference documentReferencer =
  _CollectionTip.doc(docId);

  Map<String, dynamic> data = <String, dynamic>{
    "end_location": endLocation,
  };

  Response response = Response();

  var res = await documentReferencer.update(data).then((value) => {
    response.code = 200,
    response.message = "Update the end location"
  });

  return response;

}

// BackEnd for booking Hotels
CreateBooking({
  required String uid,
  required DateTime startDate,
  required DateTime endDate,
  required String hotelName,
  required String hotelUserId,
  required int numberOfRooms,
  required double price,
}) async {

  Response response = Response();
  DocumentReference documentReferencer =
  _CollectionBooking.doc();

  Map<String, dynamic> data = <String, dynamic>{
    "user_id": uid,
    "start_date" : startDate,
    "end_date" : endDate,
    "hotel" : hotelName,
    'NumberOfRooms' : numberOfRooms,
    "HotelUserId" : hotelUserId,
    "price" : price

   
  };

  var result = await documentReferencer
      .set(data)
      .whenComplete(() {
    response.code = 200;
    response.message = documentReferencer.id;
    print("Sucessfully creted the booking");
  })
      .catchError((e) {
    response.code = 500;
    //response.message = e;
    print("$e");
  });
  String documentId = documentReferencer.id;

  return response ;
}

















// Testing Functions
Future<Response> updateEmployeeTesting({
  required String name,
  required String position,
  required String contactno,
  required String docId,
  DocumentReference? documentReferencer

}) async {
  Response response = Response();


  Map<String, dynamic> data = <String, dynamic>{
    "employee_name": name,
    "position": position,
    "contact_no" : contactno
  };

  await documentReferencer!
      .update(data)
      .whenComplete(() {
    response.code = 200;
    response.message = "Sucessfully updated Employee";
  })
      .catchError((e) {
    response.code = 500;
    response.message = e;
  });

  return response;
}


// Add Travelling Mode
Future<Response> updateTravellingModeTest({
  required String travallingMode,
  required String docId,
  DocumentReference? documentReferencer
}) async {
  Response response = Response();

  Map<String, dynamic> data = <String, dynamic>{
    "travelling_mode": travallingMode,
  };

  await documentReferencer!
      .update(data)
      .whenComplete(() {
    response.code = 200;
    response.message = "Sucessfully updated Trip Travelling Mode";
  })
      .catchError((e) {
    response.code = 500;
    response.message = e;
  });

  return response;
}