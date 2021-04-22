import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mylocation/model/locModel.dart';
import 'package:mylocation/services/services.dart';
import 'package:provider/provider.dart';
import 'package:geocoder/geocoder.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      // statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black));
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<LocationModel>(
//         create: (_) => LocationService().getStreamDate,
//         child: MaterialApp(
//           home: MyHomePage(),
//         ));
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<LocationModel>(
        create: (_) => LocationService().locationStream,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var locationModel = Provider.of<LocationModel>(context);
    // print((locationModel.speed / 1000).toStringAsFixed(2));
    // print(locationModel.speedAccuracy);
    // print(locationModel.heading);
    // print(locationModel.time);

    Future getPlaceName() async {
      final coordinates =
          new Coordinates(locationModel.latitude, locationModel.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.last;
      // print("${first.subAdminArea}, ${first.countryName}");
      return first;
    }

    return Scaffold(
        backgroundColor: Colors.black,
        body:

            // Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text("Lattitude: ${locationModel.latitude}"),
            //       Text("longitude: ${locationModel.longitude}"),
            //       Text("longitude: ${getPlaceName()}"),
            //     ],
            //   ),
            // ),
            SafeArea(
          child: FutureBuilder(
              future: getPlaceName(),
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text("Lattitude: ${locationModel.latitude}"),
                        // Text("longitude: ${locationModel.longitude}"),
                        locationModel.speed != null
                            ? Column(
                                children: [
                                  Text(
                                    "${(locationModel.speed).toStringAsFixed(2)}",
                                    style: TextStyle(
                                        // shadows: [
                                        //   Shadow(
                                        //     blurRadius: 10.0,
                                        //     color: Colors.greenAccent,
                                        //     offset: Offset(0.0, 0.0),
                                        //   ),
                                        // ],
                                        color: Colors.greenAccent,
                                        fontSize: 70,
                                        fontFamily: 'liquidCrystalBold'),
                                  ),
                                  Text(
                                    " m/s",
                                    style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontSize: 20,
                                        fontFamily: 'liquidCrystalBold'),
                                  )
                                ],
                              )
                            : Column(
                                children: [
                                  Text(
                                    "0 m/s",
                                    style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontSize: 70,
                                        fontFamily: 'liquidCrystalBold'),
                                  ),
                                  Text(
                                    " m/s",
                                    style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontSize: 20,
                                        fontFamily: 'liquidCrystalBold'),
                                  )
                                ],
                              ),

                        SizedBox(
                          height: 25,
                        ),

                        (snapshot.data.subAdminArea) != null ||
                                (snapshot.data.countryName) != null
                            ? Text(
                                "${snapshot.data.subAdminArea},  ${snapshot.data.countryName}",
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 15,
                                    fontFamily: 'liquidCrystalBold'))
                            : Text("Getting location..",
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 15,
                                    fontFamily: 'liquidCrystalBold')),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ));
  }
}
