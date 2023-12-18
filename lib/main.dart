import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pricetracker/data/local_storage.dart';
import 'package:pricetracker/widgets/splash.dart';
import 'package:url_launcher/url_launcher.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.instance.getToken().then((value) async {
    debugPrint("getToken : $value");
    await localStoreSetToken(value!);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    debugPrint("onMessageOpenedApp: $message");
    Navigator.pushNamed(
      navigatorKey.currentState!.context,
      '/push',
      arguments: {"message": json.encode(message.data)},
    );
  });

  FirebaseMessaging.instance.getInitialMessage().then(
    (RemoteMessage? message) async {
      debugPrint("getInitialMessage: $message");
      if (message != null) {
        Navigator.pushNamed(
          navigatorKey.currentState!.context,
          '/push',
          arguments: {"message": json.encode(message)},
        );
      }
    },
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("_firebaseMessagingBackgroundHandler : $message");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xFF26A842),
        primaryColorLight: const Color(0xFFE7F6EA),
        primaryColorDark: const Color(0xFF7CCE8E),
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => const SplashScreen(),
        '/push': (context) => const TrackPage(),
      },
    );
  }
}

class TrackPage extends StatefulWidget {
  const TrackPage({super.key});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  dynamic message;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments != null) {
      Map pushArguments = arguments as Map;

      pushArguments.forEach((key, value) async {
        message = await jsonDecode(value);
        print(message['url']);
        print(message['imgUrl']);
        print(message['alert_price']);
        setState(() {});
        print(value + " ----- Check");
        print(key + " ----- Test");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Price drop alert !!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              message != null && message['imgUrl'] != null
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1C000000),
                            spreadRadius: 1,
                            blurRadius: 15,
                            offset: Offset(0, 0),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          message['imgUrl'],
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                      ),
                    )
                  : const SizedBox(),
              Text(
                message != null && message['title'] != null
                    ? message['title']
                    : "",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Price is less than or equal to your alert price ",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    message != null && message['alert_price'] != null
                        ? "Rs. ${message['alert_price']}"
                        : "",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () async {
                  String productId = "";

                  if (message['url'].contains('/dp/')) {
                    debugPrint(
                        "${message['url'].split('/dp/')[1].split('/').first} - 1");
                    productId =
                        message['url'].split('/dp/')[1].split('/').first;
                  } else if (message['url'].contains('/gp/product/')) {
                    debugPrint(
                        "${message['url'].split('/gp/product/')[1].split('/').first} - 2");
                    productId = message['url']
                        .split('/gp/product/')[1]
                        .split('/')
                        .first;
                  } else if (message['url'].contains('/gp/aw/d/')) {
                    debugPrint(
                        "${message['url'].split('/gp/aw/d/')[1].split('/').first} - 3");
                    productId =
                        message['url'].split('/gp/aw/d/')[1].split('/').first;
                  }

                  Uri url;

                  if (productId.isNotEmpty) {
                    url = Uri.parse(
                        "https://www.amazon.in/dp/$productId?tag=affluencer0d-21");
                  } else {
                    url = Uri.parse("${message['url']}&tag=affluencer0d-21");
                  }

                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw Exception('Could not launch $url');
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    "Buy on Amazon",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
