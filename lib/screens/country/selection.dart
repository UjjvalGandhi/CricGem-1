// import 'dart:convert';
// import 'package:flutter/services.dart';
//
// class LocationSelection {
//   List? _countryData;
//   List? _cityData;
//   List? _statesData;
//
//   Future<List<dynamic>> jsonLoad() async {
//     String response = await rootBundle.loadString('assets/CountryStateCity.json');
//     List data = jsonDecode(response);
//     return data;
//   }
//
//   Future<List<String>> countryNameList() async {
//     _countryData = await jsonLoad();
//     // Map to List<String> and ensure the type is correct
//     List<String> data = _countryData!.map<String>((e) => e["name"] as String).toList();
//     return data;
//   }
//
//   List<String> stateNameList(String country) {
//     Map<String, dynamic> data = _countryData!.firstWhere((element) => element["name"] == country);
//     _statesData = data["states"];
//
//     List<String> stateNames = _statesData!.map<String>((e) => e["name"] as String).toList();
//     return stateNames;
//   }
//
//   List<String> cityNameList(String state) {
//     Map<String, dynamic> stateNames = _statesData!.firstWhere((element) => element["name"] == state);
//     _cityData = stateNames["cities"];
//
//     List<String> cityName = _cityData!.map<String>((e) => e["name"] as String).toList();
//     return cityName;
//   }
// }
import 'dart:convert';

import 'package:flutter/services.dart';

class LocationSelection {
  List? stateName;
  List? _countryData;
  List? _cityData;
  List? _statesData;

  Future<List> jsonLoad() async {
    String response = await rootBundle.loadString('assets/CountryStateCity.json');
    List data = await jsonDecode(response);
    return data;
  }

  Future<List> countryNameList() async {
    _countryData = await jsonLoad();
    var data = _countryData!.map((e) => e["name"]).toList();
    return data;
  }

  List<String> stateNameList(String country) {
    Map<String, dynamic> data = _countryData!.firstWhere((element) => element["name"] == country);
    _statesData = data["states"];

    List stateNames = _statesData!.map((e) => e["name"]).toList();
    List<String> finalNames = [];
    print(stateNames);
    for (var _d in stateNames) {
      finalNames.add(_d);
    }
    return finalNames;
  }

  List<String> cityNameList(String state) {
    Map<String, dynamic> stateNames = _statesData!.firstWhere((element) => element["name"] == state);
    print("satasjdjhsg $stateNames");
    _cityData = stateNames["cities"];

    var cityName = _cityData!.map((e) => e["name"]).toList();
    print(cityName);
    List<String> finalCity = [];
    for (var _d in cityName) {
      finalCity.add(_d);
    }
    return finalCity;
  }
}
