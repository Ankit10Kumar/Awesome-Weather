// ignore_for_file: must_be_immutable
import 'package:location/location.dart';
import 'package:awesomeweather/Bloc/bloc.dart';
import 'package:awesomeweather/Bloc/cityBloc.dart';
import 'package:awesomeweather/WeatherModals/locations.dart';
import 'package:awesomeweather/custom_progress.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:awesomeweather/Bloc/weather_bloc.dart';
import 'package:awesomeweather/Bloc/weather_event.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  Map<String, dynamic> forecast;
  Map<String, dynamic> location;
  SearchPage({Key? key, required this.forecast, required this.location})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // ConnectivityResult _connectionStatus = ConnectivityResult.none;
  // final Connectivity _connectivity = Connectivity();
  bool isInternetOn = true;
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  // @override
  // void initState() {
  //   super.initState();
  //   getConnect();
  //   // initConnectivity();
  // }

  // @override
  // void dispose() {
  //   // _connectivitySubscription.cancel();
  //   super.dispose();
  // }

  // void getConnect() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.wifi ||
  //       connectivityResult == ConnectivityResult.mobile) {
  //     setState(() {
  //       isInternetOn = true;
  //     });
  //   } else {
  //     setState(() {
  //       isInternetOn = false;
  //     });
  //   }
  // }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initConnectivity() async {
  //   late ConnectivityResult result;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } on PlatformException catch (e) {
  //     print(e.toString());
  //     return;
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) {
  //     return Future.value(null);
  //   }

  //   return setState(() {
  //     _connectionStatus = result;
  //   });
  // }

  var locat = new Location();

  final popularCities = [
    City(name: 'Delhi', lat: 28.6667, lon: 77.2167, country: 'IN'),
    City(name: 'Mumbai', lat: 19.0144, lon: 72.8479, country: 'IN'),
    City(name: 'New York', lat: 43.0004, lon: -75.4999, country: 'US'),
    City(name: 'Berlin', lat: 44.4687, lon: -71.1851, country: 'US'),
    City(name: 'London', lat: 51.5085, lon: -0.1257, country: 'GB'),
    City(name: 'Tokyo', lat: 35.6895, lon: 139.6917, country: 'JP'),
    City(name: 'Moscow', lat: 55.7522, lon: 37.6156, country: 'RU'),
    City(name: 'Los Angeles', lat: 34.0522, lon: -118.2437, country: 'US'),
    City(name: 'Chennai', lat: 13.0878, lon: 80.2785, country: 'IN'),
    City(name: 'Chicago', lat: 41.85, lon: -87.65, country: 'US'),
    City(name: 'Las Vegas', lat: 36.175, lon: -115.1372, country: 'US'),
    City(name: 'Paris', lat: 48.8534, lon: 2.3488, country: 'FR'),
    City(name: 'Indianapolis', lat: 39.7684, lon: -86.158, country: 'US'),
    City(name: 'Singapore', lat: 1.2897, lon: 103.8501, country: 'SG'),
    City(name: 'Rome', lat: 41.8947, lon: 12.4839, country: 'IT'),
    City(name: 'Switzerland', lat: 47.0002, lon: 8.0143, country: 'CH'),
    City(name: 'Sydney', lat: -33.8679, lon: 151.2073, country: 'AU'),
    City(name: 'Shanghai', lat: 31.2222, lon: 121.4581, country: 'CN'),
    City(name: 'Seoul', lat: 37.5683, lon: 126.9778, country: 'KR'),
  ];

  List<String> cities = [''];

  final TextEditingController query = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blueAccent),
        elevation: 0,
        leading: IconButton(
            iconSize: 35,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.keyboard_arrow_left_rounded)),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.black,
        title: Card(
          color: Colors.cyanAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 10,
          // constraints: BoxConstraints(maxHeight: 40, maxWidth: 400),
          child: TextField(
            autofocus: true,
            onChanged: (text) {
              if (text.isNotEmpty)
                context.read<CityBloc>().add(
                      CityEvent(
                        city: text,
                        predata: {
                          'forecast': widget.forecast,
                          'location': widget.location,
                        },
                      ),
                    );
              buildCities(context);
            },
            cursorColor: Colors.cyanAccent,
            cursorRadius: Radius.circular(5),
            cursorWidth: 4,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            controller: query,
            cursorHeight: 25,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 40),
              hintText: ' Search your City',
              hintStyle: TextStyle(color: Colors.white60),
              suffixIcon: IconButton(
                iconSize: 20,
                color: Colors.white,
                onPressed: () {
                  if (query.text == '') {
                    Navigator.of(context).pop();
                  } else {
                    query.clear();
                    buildCities(context);
                  }
                },
                icon: Icon(Icons.clear),
              ),
              fillColor: Colors.black87,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ),
      body: buildCities(context),
    );
  }

  close(BuildContext context, City city) {
    if (city.name.isNotEmpty) {
      var formattedTime = DateFormat('yyyy-mm-dd HH:mm:ss');
      context.read<WeatherBloc>().add(
            ResetWeather(
              location: city,
              lastUpdate: formattedTime.format(DateTime.now()),
              preForecast: widget.forecast,
              preLocation: widget.location,
            ),
          );
    }
    Navigator.of(context).pop();
  }

  Widget buildCities(BuildContext context) {
    return Container(
      color: Colors.black,
      child: BlocConsumer<CityBloc, CityState>(
        listener: (context, state) {
          if (state is CitiesError) if (!state.error
              .contains('Something Went wrong')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                duration: Duration(seconds: 2),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                padding: EdgeInsets.all(15),
              ),
            );
          }
        },
        builder: (context, state) {
          if (!isInternetOn) {
            // print(object)
            return Center(
              child: Text(
                'No Internet Connection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (query.text.isNotEmpty) {
            if (state is CitiesLoaded) {
              if (state.cities.isNotEmpty) {
                return buildPopularCities(context, state.cities);
              }
              return Center(
                child: Text(
                  'No Such City Found',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else if (state is CityLoading)
              return Center(
                child: SpinKitSpinningLines(
                  color: Colors.limeAccent,
                ),
              );
            return Center(
              child: Text(
                'No Such City Found',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return buildPopularCities(context, popularCities);
        },
      ),
    );
  }

  List<Widget> recentCity(BuildContext context, List<City>? city) {
    int count = city!.length;
    return List<Widget>.generate(
      count,
      (i) => GestureDetector(
        onTap: () {
          close(context, city[i]);
        },
        child: Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white24,
          ),
          child: Text(
            "${city[i].name},${city[i].country}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ),
      ),
    ).toList();
  }

  Widget buildPopularCities(BuildContext context, List<City>? recents) {
    return Container(
      color: Colors.black,
      child: ListView(
        padding: EdgeInsets.only(top: 20, right: 5),
        children: [
          Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 8),
                child: TextButton.icon(
                  style: buttonStyle,
                  onPressed: () async* {
                    // print('in button');
                    // var service = await locat.serviceEnabled();
                    // var permiss = await locat.hasPermission();
                    // print(service);
                    // if (permiss == PermissionStatus.denied) {
                    //   permiss = await locat.requestPermission();
                    //   if (permiss != PermissionStatus.granted) {}
                    //   if (!service) {
                    //     service = await locat.requestService();
                    //     if (!service) {
                    //       return;
                    //     }
                    //     var curr = await locat.getLocation();
                    //     City city = await WeatherRepo.getCityName(
                    //         curr.latitude, curr.longitude);
                    //     BlocProvider.of<WeatherBloc>(context).add(
                    //       ResetWeather(
                    //         location: City(
                    //             name: city.name,
                    //             lat: city.lat,
                    //             lon: city.lon,
                    //             country: city.country),
                    //         predata: {
                    //           'forecast': forecast,
                    //           'location': location,
                    //           'lastUpdate': DateFormat().format(DateTime.now()),
                    //         },
                    //       ),
                    //     );
                    //   }
                    // }
                  },
                  icon: Icon(
                    Icons.room,
                    size: 20,
                    color: Colors.cyanAccent,
                  ),
                  label: Text(
                    'Locate',
                    style: TextStyle(color: Colors.cyanAccent),
                  ),
                ),
              ),
              ...recentCity(context, recents),
            ],
          )
        ],
      ),
    );
  }

  ButtonStyle buttonStyle = TextButton.styleFrom(
      backgroundColor: Colors.white24,
      onSurface: Colors.cyanAccent,
      padding: EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)));
}
