import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rxdart/rxdart.dart';

import 'package:vojo/ChatPage/ChatPage.dart';
import 'package:vojo/CurretLocation/CurrentLocation.dart';
import 'package:vojo/HotelPaymentPage/HotelPayment.dart';
import 'package:vojo/LocationSearchPage/LocationSearchPage.dart';
import 'package:vojo/MyJourneyPage/GoogleMapsWeidget.dart';
import 'package:vojo/MyJourneyPage/MyJourneyPage.dart';
import 'package:vojo/MyJourneyPage/SearchTilePage.dart';
import 'package:vojo/MyJourneyPage/temp.dart';
import 'package:vojo/NotificationService/NotificationService.dart';
import 'package:vojo/PlacesSuggetionPage/PlacesSuggetionPage.dart';
import 'package:vojo/StateManagment/StateManagment.dart';
import 'package:vojo/TestLocation/TestLocations.dart';
import 'package:vojo/rider_list_page/rider_list_page.dart';
import 'package:vojo/stripPage/newStripe.dart';

import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';
import 'transpotation_mode/transport_mode.dart';

import 'backend/firebase/firebase_config.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'pick_location_page/pick_location_page.dart';

import 'flutter_flow/nav/nav.dart';
import 'index.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51OSCmFCem4pjyRAzDzsny1yS8fm8RQRjqQDNryrarztSx6kxpvty3SZMx3jaWcCE54pyo4Zmtv3DWMfzNa65V5HH00p1wiVzRu";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await initFirebase();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true
  );

  runApp(MyApp());
}

// Top Level named handler which background/terminated messages will call
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle the message
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'main_channel',
      title: message.notification?.title ?? 'Notification',
      body: message.notification?.body ?? 'You have a new message',
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;

  late Stream<BaseAuthUser> userStream;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  final authUserSub = authenticatedUserStream.listen((_) {});

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'main_channel',
          title: message.notification?.title ?? 'Notification',
          body: message.notification?.body ?? 'You have a new message',
        ),
      );
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 10,
            channelKey: 'main_channel',
            title: message.notification?.title ?? 'Notification',
            body: message.notification?.body ?? 'You have a new message',
          ),
        );
      }
    });
    FirebaseMessaging.instance.subscribeToTopic('data_changes');

    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = vojoFirebaseUserStream()
      ..listen((user) => _appStateNotifier.update(user));
    jwtTokenStream.listen((_) {});
    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  void dispose() {
    authUserSub.cancel();

    super.dispose();
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Vojo',
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        scrollbarTheme: ScrollbarThemeData(),
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({Key? key, this.initialPage, this.page}) : super(key: key);

  final String? initialPage;
  final Widget? page;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'landingPage';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'landingPage': LandingPageWidget(),
      'myJourneyPage' : MyJourneyPage(),
      'PaymentPage' : PlacesSuggestionPage(),
      'profilePage': ProfilePageWidget(),

    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HotelDetailsProvider()),
        ChangeNotifierProvider(create: (context) => RiderDetailsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/picklocation': (context) => PickLocationPage(),
          '/transport': (context) => TransportModePage(),
          '/riderList': (context) => RidersListPage(),
          '/landing': (context) => LandingPageWidget(),
        },
        home: Scaffold(
          body: _currentPage ?? tabs[_currentPageName],
          bottomNavigationBar: GNav(
            selectedIndex: currentIndex,
            onTabChange: (i) => setState(() {
              _currentPage = null;
              _currentPageName = tabs.keys.toList()[i];
            }),
            backgroundColor: Colors.white,
            color: Color(0x8A000000),
            activeColor: FlutterFlowTheme.of(context).primary,
            tabBackgroundColor: Color(0x00000000),
            tabBorderRadius: 100.0,
            tabMargin: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 15.0),
            gap: 0.0,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            duration: Duration(milliseconds: 500),
            haptic: false,
            tabs: [
              GButton(
                icon: currentIndex == 0 ? Icons.home_filled : Icons.home,
                text: 'Home',
                iconSize: 24.0,
              ),
              GButton(
                icon: Icons.bookmark_add,
                text: 'Journey',
                iconSize: 24.0,
              ),
              GButton(

                icon: Icons.location_on,
                text: 'Places',

                iconSize: 24.0,
              ),GButton(
                icon: Icons.person,
                text: 'Profile',
                iconSize: 24.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationService{
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService(){
    return _notificationService;
  }
  NotificationService._internal();

  Future<void> initAwesomeNotification()async{
    AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
          channelKey: 'main_channel',
          channelName: 'main_channel',
          channelDescription: 'main_channel notifications',
          enableLights: true,
          importance: NotificationImportance.Max,
        )
      ],
    );
  }
  Future<void> requestPermission() async{
    AwesomeNotifications().isNotificationAllowed().then((allowed){
      if(!allowed){
        AwesomeNotifications().requestPermissionToSendNotifications();

      }
    });

  }
  Future<void> showNotification(int id,String channelKey,String title,String body) async{
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelKey,
        title: title,
        body: body,
      ),
    );
  }

  Future<void> showScheduledNotification(int id, String channelKey, String title, String body, int interval) async {
    String localTZ = await AwesomeNotifications().getLocalTimeZoneIdentifier();

    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: channelKey,
          title: title,
          body: body,
        ),
        schedule: NotificationInterval(
          interval: interval,
          timeZone: localTZ,
          repeats: false,
        )
    );
  }
}