import 'package:awesomeweather/UI/weatherconverter.dart';
import 'package:awesomeweather/WeatherModals/forcast.dart';
import 'package:flutter/material.dart';

class DailyForecast extends StatelessWidget {
  const DailyForecast({Key? key, required this.daily}) : super(key: key);
  final List<Daily> daily;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, bottom: 25),
            child: Text(
              'Daily',
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
              itemCount: daily.length,
              itemBuilder: (context, item) => Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: MediaQuery.of(context).size.width * 0.19,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      getDate(timestamp: daily[item].dt, format: 'EEE'),
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
                        'Assets/images/${daily[item].weather[0].icon}.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      converter(daily[item].temp.max),
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
