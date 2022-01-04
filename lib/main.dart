import 'package:awesomeweather/Bloc/cityBloc.dart';
import 'package:awesomeweather/Bloc/weather_bloc.dart';
import 'package:awesomeweather/weatherRepo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'bloc_observer.dart';
import 'homepage.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:page_transition/page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = WeatherBlocObserver();
  if (kIsWeb) {
    // if web
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorage.webStorageDirectory,
    );
  } else {
    // var status = await Permission.storage.request();
    // // if android or tabletvar status = await Permission.storage.request();
    // if (status.isDenied || status.isPermanentlyDenied) {
    //   SystemNavigator.pop();
    // } else {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
    );
    // }
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: WeatherRepo,
      child: MultiBlocProvider(
          providers: [
            BlocProvider<WeatherBloc>(
              create: (_) => WeatherBloc(WeatherRepo()),
            ),
            BlocProvider<CityBloc>(
              create: (_) => CityBloc(WeatherRepo()),
            ),
          ],
          child: MaterialApp(
            title: 'Awesome Weather',
            home: AnimatedSplashScreen(
              curve: Curves.easeOutSine,
              nextScreen: MyHomePage(),
              backgroundColor: Color(0xFF1E50F4),
              pageTransitionType: PageTransitionType.fade,
              splashTransition: SplashTransition.fadeTransition,
              splash: Image.asset('Assets/images/icon.png'),
            ),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
            ),
          )),
    );
  }
}
