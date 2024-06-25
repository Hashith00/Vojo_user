import 'package:firebase_auth/firebase_auth.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:vojo/Conatants/Constans.dart';
import 'package:vojo/DeletedRidesPage/DeletedRidesPage.dart';
import 'package:vojo/EditTrip_page/EditTrip_page.dart';
import 'package:vojo/MyJourneyPage/MyJourneyPage.dart';
import 'package:vojo/PendingRidersPage/PandingRidesPage.dart';
import 'package:vojo/PickHotelOrRoderPage/PickHotelOrRiderPage.dart';

import '/auth/firebase_auth/auth_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'landing_page_model.dart';
export 'landing_page_model.dart';

class LandingPageWidget extends StatefulWidget {
  const LandingPageWidget({Key? key}) : super(key: key);

  @override
  _LandingPageWidgetState createState() => _LandingPageWidgetState();
}

class _LandingPageWidgetState extends State<LandingPageWidget> {
  final _auth = FirebaseAuth.instance;
  late LandingPageModel _model;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int totalTrips = 0;
  int totalPendingTrips = 0;
  int SuccessfullTrips = 0;
  int totalAddedtoCanceltrips = 0;
  Color shifttedColor = primaryColorLight;
  var currentUserId;
  var profilePictureURL;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> getUserStatus()async{
     currentUserId = _auth.currentUser!.uid;

    final trips =  await _firestore.collection("temptrip").get();
    for(var trip in trips.docs){
      if(trip.data()["user_id"] == currentUserId && trip.data()["is_confirmed"] == true){
        setState(() {
          totalTrips += 1;
        });
      }else if(trip.data()["user_id"] == currentUserId && trip.data()["is_confirmed"] == false){
        setState(() {
          totalPendingTrips += 1;
          shifttedColor = warningColor;
        });

      }else if(trip.data()["user_id"] == currentUserId && trip.data()["Remove_Trip_by_Admin"] == false){
        setState(() {
          totalAddedtoCanceltrips += 1;
          shifttedColor = warningColor;
        });
      }

    }
  }
  Future<void> getCuurentUserImage()async{
    var url = await getUserProfilePicture(userId: currentUserId);
    setState(() {
      profilePictureURL = url;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserStatus();
    _model = createModel(context, () => LandingPageModel());

  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    bool hastrips = false;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var tripNote = "Book Your Ride";
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,

      body: SafeArea(
        top: true,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: AlignmentDirectional(0.00, -1.00),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.00, -1.00),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 16.0, 0.0),
                          child: Wrap(
                            spacing: 16.0,
                            runSpacing: 16.0,
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            direction: Axis.horizontal,
                            runAlignment: WrapAlignment.center,
                            verticalDirection: VerticalDirection.down,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: double.infinity,
                                constraints: BoxConstraints(
                                  maxWidth: 390.0,
                                ),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(12.0),

                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        profilePictureURL != null ?
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 3.0, 0.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed('profilePage');
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    image: DecorationImage(
                                                      image: NetworkImage(profilePictureURL),
                                                      fit: BoxFit.fill,

                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ) : Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 3.0, 0.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed('profilePage');
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    image: DecorationImage(
                                                      image: NetworkImage("https://media.licdn.com/dms/image/C4D03AQEeEyYzNtDq7g/profile-displayphoto-shrink_400_400/0/1524234561685?e=2147483647&v=beta&t=CJY6IY9Bsqc2kiES7HZmnMo1_uf11zHc9DQ1tyk7R7Y"),
                                                      fit: BoxFit.fill,

                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(16.0, 16.0, 16.0, 16.0),
                                          child: StreamBuilder<UsersRecord>(
                                            stream: UsersRecord.getDocument(
                                                currentUserReference!),
                                            builder: (context, snapshot) {
                                              // Customize what your widget looks like when it's loading.
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child: SizedBox(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                              final rowUsersRecord =
                                                  snapshot.data!;

                                              return Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              4.0, 0.0, 4.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    4.0,
                                                                    0.0,
                                                                    0.0),
                                                            child: Text(
                                                              'Welcome',
                                                              style: TextStyle(fontSize: 30, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w300),
                                                            ),
                                                          ),
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              rowUsersRecord
                                                                  .displayName,
                                                              'No Name',
                                                            ),
                                                            style: TextStyle(fontSize: 30, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w700)
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/vojo_travel.png',
                            width: 390.0,
                            height: 250.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Align(
                        alignment: AlignmentDirectional(-1.00, 0.00),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 10.0, 0.0, 0.0),
                          child: Text(
                            'My Status ',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                              fontFamily: primaryFontFamilty,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyJourneyPage()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  height: 130,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Total Trips", style: TextStyle(fontFamily: primaryFontFamilty, color: Colors.white , fontWeight: FontWeight.w300, fontSize: 15),),
                                          SizedBox(height: 10,),
                                          Text("$totalTrips", style: TextStyle(fontFamily: primaryFontFamilty, color: Colors.white, fontSize: 56),),
                                        ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PendingRidesPage()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: primaryColor),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  height: 130,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Pending Trips", style: TextStyle(fontFamily: primaryFontFamilty, color: primaryColorLight , fontWeight: FontWeight.w300, fontSize: 15),),
                                      SizedBox(height: 10,),
                                      Text("$totalPendingTrips", style: TextStyle(fontFamily: primaryFontFamilty, color: primaryColorLight, fontSize: 56),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyJourneyPage()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.greenAccent.shade700,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  height: 130,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Successful Trips", style: TextStyle(fontFamily: primaryFontFamilty, color: Colors.white , fontWeight: FontWeight.w300, fontSize: 15),),
                                      SizedBox(height: 10,),
                                      Text("$totalTrips", style: TextStyle(fontFamily: primaryFontFamilty, color: Colors.white, fontSize: 56),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DeletedRidesPage()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.orangeAccent.shade700),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  height: 130,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Deleted Trips", style: TextStyle(fontFamily: primaryFontFamilty, color: Colors.orangeAccent.shade700 , fontWeight: FontWeight.w300, fontSize: 15),),
                                      SizedBox(height: 10,),
                                      Text("$totalAddedtoCanceltrips", style: TextStyle(fontFamily: primaryFontFamilty, color: Colors.orangeAccent.shade700, fontSize: 56),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PickHotelOrRider()),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Center(
                            child: Text("Plan My Journey", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 18, color: Colors.white),),
                          ),
                        ),
                      ),

                    ].addToEnd(SizedBox(height: 72.0)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateJourney extends StatelessWidget {
  var hasjourney;
  CreateJourney({super.key, required this.hasjourney});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF311B92)),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${hasjourney}",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PickHotelOrRider()),
                      );
                    },
                    child: Text(
                      "Let's Start",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: Color(0xFF311B92),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

showAlertDialogBox(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("My title"),
    content: Text("This is my message."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
