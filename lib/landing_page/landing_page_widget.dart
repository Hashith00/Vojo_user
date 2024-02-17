
import 'package:firebase_auth/firebase_auth.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:vojo/EditTrip_page/EditTrip_page.dart';
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

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
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
      appBar: MediaQuery.sizeOf(context).width <= 991.0
          ? AppBar(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              automaticallyImplyLeading: false,
              title: Text(
                'My Profile',
                style: FlutterFlowTheme.of(context).headlineMedium,
              ),
              actions: [],
              centerTitle: false,
              elevation: 0.0,
            )
          : null,
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
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 1.0,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
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
                                            child: Icon(
                                              Icons.location_history,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 40.0,
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
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMedium,
                                                            ),
                                                          ),
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              rowUsersRecord
                                                                  .displayName,
                                                              'No',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .headlineSmall,
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
                                        Divider(
                                          height: 2.0,
                                          thickness: 1.0,
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1678496479367-28592d3620a9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxNHx8Y2FsbWluZyUyMG5hdHVyZXxlbnwwfHx8fDE3MDA2NTk5ODZ8MA&ixlib=rb-4.0.3&q=80&w=1080',
                          width: 390.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-1.00, 0.00),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 30.0, 0.0, 0.0),
                          child: Text(
                            'Upcomming Journeys',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 30.0, 20.0, 0.0),
                        child: Container(
                            width: double.infinity,
                            height: 150.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: hastrips
                                ? Column()
                                : Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Haven't  any journeys?",
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          height: 50,
                                        ),
                                        Container(
                                            alignment: Alignment.bottomRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, "/picklocation");
                                              },
                                              child: Text("Let's Start",
                                                  style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.w400,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  )),
                                            ))
                                      ],
                                    ),
                                  )),

                      Container(
                        margin: EdgeInsets.all(10),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              StreamBuilder<QuerySnapshot>(
                                stream: _firestore
                                    .collection("temptrip")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    // Use hasData instead of != null
                                    final messages = snapshot.data!.docs;
                                    List<Widget> rides = [];

                                    for (var message in messages) {
                                      final tripData = message.data() as Map<
                                          String, dynamic>; // Explicit cast
                                      //var messageText = messageData["end_date"];
                                      //messagesList.add(Text('$messageText'));
                                      String docId = message.id;

                                      final tripCard = Container(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 16.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: const Color(0xFF311B92),
                                              width: 2.0,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              ListTile(
                                                title: Text(
                                                  "${tripData["start_location"]} to  ${tripData["end_location"]}",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.person,
                                                          size: 16.0),
                                                      const SizedBox(
                                                          width: 8.0),
                                                      Text(
                                                          "Booked a  ${tripData["travelling_mode"]}"),
                                                    ],
                                                  ),
                                                ),
                                                trailing: AvatarGlow(
                                                    glowColor: Color(0xFF311B92),
                                                    child: Icon(Icons.circle, color:Color(0x1A311B92) ,)),
                                                //onTap: onTap,
                                              ),
                                              const SizedBox(height: 4.0),
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.push(context, MaterialPageRoute(
                                                      builder: (context) =>  EditTrip(id: docId,),
                                                    ),);


                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF311B92),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Edit Booking',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 1.0),
                                              Container(
                                                margin:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16.0),
                                                child: TextButton(
                                                  onPressed: ()async {
                                                    deleteTrip(docId: docId);
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Color(0xFFFFFFFF),
                                                    padding:
                                                    const EdgeInsets.all(
                                                        12.0),
                                                      side: BorderSide(
                                                        color: Color(0xFF311B92), // your color here
                                                        width: 1,
                                                      ),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Remove Booking',
                                                    style: TextStyle(
                                                        color: Color(0xFF311B92)),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 6.0),
                                            ],
                                          ),
                                        ),
                                      );
                                      //print(category);
                                      if (tripData["status"] == "Confirmed" &&
                                          (tripData['user_id'] ==
                                              _auth.currentUser?.uid)) {
                                        rides.add(tripCard);
                                      }
                                    }

                                    return SingleChildScrollView(
                                      child: Column(
                                        children: rides,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    // Handle the error case
                                    return Text("Error: ${snapshot.error}");
                                  } else {
                                    return CircularProgressIndicator(); // Show a loading indicator
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                      ),
                      CreateJourney(hasjourney: tripNote),

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
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 30.0, 20.0, 0.0),
      child: Container(
          width: double.infinity,
          height: 130.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${hasjourney}",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PickHotelOrRider()),
                        );

                       // Navigator.pushNamed(context, "/picklocation");
                      },
                      child: Text("Let's Start",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                          )),
                    )),
              ],
            ),
          )),
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
