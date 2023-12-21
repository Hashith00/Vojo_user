import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserColRecord extends FirestoreRecord {
  UserColRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "password" field.
  String? _password;
  String get password => _password ?? '';
  bool hasPassword() => _password != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _password = snapshotData['password'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('userCol');

  static Stream<UserColRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UserColRecord.fromSnapshot(s));

  static Future<UserColRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UserColRecord.fromSnapshot(s));

  static UserColRecord fromSnapshot(DocumentSnapshot snapshot) =>
      UserColRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UserColRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UserColRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UserColRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UserColRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUserColRecordData({
  String? email,
  String? password,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'password': password,
    }.withoutNulls,
  );

  return firestoreData;
}

class UserColRecordDocumentEquality implements Equality<UserColRecord> {
  const UserColRecordDocumentEquality();

  @override
  bool equals(UserColRecord? e1, UserColRecord? e2) {
    return e1?.email == e2?.email && e1?.password == e2?.password;
  }

  @override
  int hash(UserColRecord? e) =>
      const ListEquality().hash([e?.email, e?.password]);

  @override
  bool isValidKey(Object? o) => o is UserColRecord;
}
