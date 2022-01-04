import 'package:awesomeweather/UI/weatherconverter.dart';
import 'package:awesomeweather/WeatherModals/forcast.dart';
import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  const HourlyForecast({Key? key, required this.hourly}) : super(key: key);
  final List<Current> hourly;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 25, bottom: 15),
            child: Text(
              'HOURLY',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: 180,
            child: ListView.builder(
              // separatorBuilder: (context, index) => VerticalDivider(
              //   color: Colors.transparent,
              //   thickness: 10,
              // ),
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: (hourly.length ~/ 4).toInt(),
              itemBuilder: (context, item) => Container(
                // color: Colors.green,
                width: MediaQuery.of(context).size.width * 0.19,
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      getTime(timestamp: hourly[item].dt, format: 'hh a'),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                    ),
                    Container(
                      height: 40,
                      // color: Colors.green,
                      clipBehavior: Clip.none,
                      child: Image.asset(
                        'Assets/images/${hourly[item].weather[0].icon}.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      converter(hourly[item].temp),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
