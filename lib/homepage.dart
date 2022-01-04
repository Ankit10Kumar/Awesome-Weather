import 'package:awesomeweather/Bloc/weather_bloc.dart';
import 'package:awesomeweather/Bloc/weather_state.dart';
import 'package:awesomeweather/UI/Details.dart';
import 'package:awesomeweather/UI/currentWeather.dart';
import 'package:awesomeweather/UI/dailyForcast.dart';
import 'package:awesomeweather/UI/hourlyForcast.dart';
import 'package:awesomeweather/UI/search2.0.dart';
import 'package:awesomeweather/UI/weather_viewer.dart';
import 'package:awesomeweather/WeatherModals/forcast.dart';
import 'package:awesomeweather/WeatherModals/locations.dart';
import 'package:awesomeweather/animatedText.dart';
import 'package:awesomeweather/custom_progress.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'Bloc/weather_event.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<WeatherBloc, WeatherState>(
          listener: (context, state) {
            if (state is WeatherError)
              ScaffoldMessenger.of(context).showSnackBar(
                mySnack(error: state.error, color: Colors.redAccent),
              );
          },
          builder: (context, state) {
            return AnimatedSwitcher(
              transitionBuilder: (Widget child, Animation<double> animation) =>
                  FadeTransition(
                opacity: animation,
                child: child,
              ),
              duration: Duration(seconds: 3),
              child: getState(state),
            );
          },
        ),
      ),
    );
  }

  Widget getState(WeatherState state) {
    if (state is WeatherInitial) {
      return WeatherSearch();
    } else if (state is WeatherLoaded) {
      return Awesome(
        forecast: state.forecast,
        location: state.location,
        time: state.lastUpdate,
      );
    } else if (state is WeatherLoading) {
      return Container(
        color: Colors.black,
        child: SpinKitSpinningLines(
          color: Colors.limeAccent,
        ),
      );
    } else if (state is WeatherError) {
      if (state.preForecast.isNotEmpty && state.preLocation.isNotEmpty)
        return Awesome(
          forecast: Forecast.fromJson(state.preForecast),
          location: City.fromJson(state.preLocation),
          time: state.lastUpdate,
        );
      return WeatherSearch();
    } else {
      return WeatherSearch();
    }
  }
}

class WeatherSearch extends StatelessWidget {
  WeatherSearch({Key? key}) : super(key: key);
  final TextEditingController text = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('Assets/images/initial.jpg'),
                fit: BoxFit.cover),
          ),
        ),
        AnimatedText(),
        AnimatedButton(),
      ],
    );
  }
}

class Awesome extends StatefulWidget {
  Awesome({
    Key? key,
    required this.forecast,
    required this.location,
    required this.time,
  }) : super(key: key);
  final String time;
  final Forecast forecast;
  final City location;

  @override
  State<Awesome> createState() => _AwesomeState();
}

class _AwesomeState extends State<Awesome> {
  var formattedTime = DateFormat('yyyy-mm-dd HH:mm:ss');

  @override
  void initState() {
    var parse = formattedTime.parse(widget.time);
    var diff = DateTime.now().difference(parse).inMinutes;
    super.initState();
    if (diff > 30) {
      print('in refresh if');
      autoRefresh(formattedTime);
    }
  }

  void autoRefresh(DateFormat formattedTime) async {
    await Future.delayed(Duration(milliseconds: 250));
    BlocProvider.of<WeatherBloc>(context).add(
      ResetWeather(
        location: widget.location,
        preForecast: widget.forecast.toJson(),
        preLocation: widget.location.toJson(),
        lastUpdate: formattedTime.format(
          DateTime.now(),
        ),
      ),
    );
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    var lup = formattedTime.parse(widget.time);
    return Stack(
      children: [
        WeatherBg(
          weatherType:
              WeatherViewe.weatherType(widget.forecast.hourly[0].weather[0]),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Column(
          children: [
            Container(
              child: AppBar(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50))),
                elevation: 0,
                title: Text('Awesome Weather'),
                backgroundColor: Colors.transparent,
                actions: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: IconButton(
                      focusColor: Colors.transparent,
                      splashColor: Colors.blue[200],
                      hoverColor: Colors.transparent,
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => SearchPage(
                              forecast: widget.forecast.toJson(),
                              location: widget.location.toJson(),
                            ),
                            transitionsBuilder: (c, anim, a2, child) =>
                                FadeTransition(
                              opacity: anim,
                              child: child,
                            ),
                            transitionDuration: Duration(milliseconds: 500),
                          ),
                        );
                      },
                      icon: Icon(Icons.search_rounded),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SmartRefresher(
                dragStartBehavior: DragStartBehavior.start,
                controller: _refreshController,
                onRefresh: () async {
                  var parse = formattedTime.parse(widget.time).minute;
                  print("$parse,${DateTime.now().minute}");
                  var diff = DateTime.now().minute - parse;
                  print(diff);
                  if (diff < 30) {
                    print('in if, $diff');
                    await Future.delayed(Duration(milliseconds: 300));
                    _refreshController.refreshCompleted();
                    ScaffoldMessenger.of(context).showSnackBar(
                      mySnack(
                          error:
                              'Already Updated , Please Update after ${(parse + 30) - DateTime.now().minute} minutes',
                          color: Colors.lightBlue),
                    );
                  } else {
                    print('in else,$diff');
                    BlocProvider.of<WeatherBloc>(context).add(
                      ResetWeather(
                        location: widget.location,
                        preForecast: widget.forecast.toJson(),
                        preLocation: widget.location.toJson(),
                        lastUpdate: formattedTime.format(
                          DateTime.now(),
                        ),
                      ),
                    );
                  }
                },
                child: ListView(
                  // physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  children: [
                    CurrentWeather(
                      forecast: widget.forecast,
                      location: widget.location,
                    ),
                    Divider(
                      color: Colors.white60,
                      height: 10,
                      thickness: 1,
                    ),
                    HourlyForecast(hourly: widget.forecast.hourly),
                    Divider(
                      color: Colors.white60,
                      height: 50,
                      thickness: 1,
                    ),
                    DailyForecast(daily: widget.forecast.daily),
                    Divider(
                      color: Colors.white60,
                      height: 50,
                      thickness: 1,
                    ),
                    Details(details: widget.forecast)
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Open Weather Map',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Last Updated ${DateFormat('kk:mm a').format(lup)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 5),
                    IconButton(
                      color: Colors.white,
                      onPressed: () {
                        var parse = formattedTime.parse(widget.time).minute;
                        print("$parse,${DateTime.now().minute}");
                        var diff = DateTime.now().minute - parse;
                        print(diff);
                        if (diff < 30) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            mySnack(
                                error:
                                    'Already Updated , Please Update after ${(parse + 30) - DateTime.now().minute} minutes',
                                color: Colors.lightBlue),
                          );
                        } else {
                          print('in else,$diff');
                          BlocProvider.of<WeatherBloc>(context).add(
                            ResetWeather(
                              location: widget.location,
                              preForecast: widget.forecast.toJson(),
                              preLocation: widget.location.toJson(),
                              lastUpdate: formattedTime.format(
                                DateTime.now(),
                              ),
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.refresh),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

SnackBar mySnack({required String error, required Color color}) {
  return SnackBar(
    content: Text(
      error,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    ),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    duration: Duration(seconds: 2),
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    padding: EdgeInsets.all(15),
  );
}
