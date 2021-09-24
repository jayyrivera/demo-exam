import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seaoil/providers/main/main_notifier.dart';
import 'package:seaoil/providers/map_notifier.dart';
import 'package:seaoil/routing/obs.dart';
import 'package:seaoil/routing/routes.dart';
import 'package:seaoil/screens/login_screen.dart';
import 'package:seaoil/screens/map_screen.dart';
import 'package:seaoil/utils/constants.dart';
import 'package:seaoil/utils/sharedprefs.dart';
import 'package:velocity_x/velocity_x.dart';

import 'providers/main/login_notifier.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white, //or set color with: Color(0xFF0000FF)
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MainNotifier>(
          create: (context) => MainNotifier(),
        ),
      ],
      child: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var isLoggedIn = false;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    isLoggedIn = await check();
    setState(() {});
    super.didChangeDependencies();
  }

  Future<bool> check() async {
    var token = await SharedPrefUtils.readPrefStr(Constants.token_key);
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xff6c3eb5),
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            titleTextStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            elevation: 0.0,
          )),
      title: 'SeaOil',
      debugShowCheckedModeBanner: false,
      routerDelegate: VxNavigator(routes: {
        Main: (_, __) {
          if (isLoggedIn) {
            return MaterialPage(
                child: ChangeNotifierProvider<MapNotifier>(
                    lazy: false,
                    create: (context) => MapNotifier(),
                    child: const MapScreen()));
          } else {
            return MaterialPage(
                child: ChangeNotifierProvider<LoginNotifier>(
                    create: (context) => LoginNotifier(),
                    child: const LoginScreen()));
          }
        },
        MapPath: (_, __) {
          return MaterialPage(
              child: ChangeNotifierProvider<MapNotifier>(
                  lazy: false,
                  create: (context) => MapNotifier(),
                  child: const MapScreen()));
        }
      }, observers: [
        MyObs()
      ]),
      routeInformationParser: VxInformationParser(),
    );
  }
}
