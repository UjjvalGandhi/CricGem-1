// import 'package:flutter/material.dart';
//
// class PlaceTypeView extends StatefulWidget {
//   const PlaceTypeView({super.key});
//
//   @override
//   State<PlaceTypeView> createState() => _PlaceTypeViewState();
// }
//
// class _PlaceTypeViewState extends State<PlaceTypeView> {
//   static const textStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//         length: 3,
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             backgroundColor: Colors.white,
//             elevation: 0,
//             title: const Text(
//               "Place Type",
//               style: TextStyle(color: Colors.black),
//             ),
//             bottom: TabBar(
//                 indicator: ShapeDecoration(
//                   color: Colors.deepPurple,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//                 labelColor: Colors.white,
//                 unselectedLabelColor: Colors.black,
//                 padding: EdgeInsets.symmetric(horizontal: 8),
//                 tabs: const [
//                   Tab(
//                     text: 'Home',
//                   ),
//                   Tab(
//                     text: 'Hotel',
//                   ),
//                   Tab(
//                     text: 'Hostel',
//                   ),
//                 ]),
//           ),
//           body: const TabBarView(children: [
//             Center(
//                 child: Text(
//                   "Home",
//                   style: textStyle,
//                 )),
//             Center(
//                 child: Text(
//                   "Hotel",
//                   style: textStyle,
//                 )),
//             Center(
//                 child: Text(
//                   "Hostel",
//                   style: textStyle,
//                 )),
//           ]),
//         ));
//   }
// }

import 'package:flutter/material.dart';

class PlaceTypeView extends StatefulWidget {
  const PlaceTypeView({super.key});

  @override
  State<PlaceTypeView> createState() => _PlaceTypeViewState();
}

class _PlaceTypeViewState extends State<PlaceTypeView> {
  static const textStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              "Place Type",
              style: TextStyle(color: Colors.black),
            ),
            bottom: TabBar(
                indicator: ShapeDecoration(
                  color: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                tabs: const [
                  Tab(
                    text: 'Home',
                  ),
                  Tab(
                    text: 'Hotel',
                  ),
                  Tab(
                    text: 'Hostel',
                  ),
                ]),
          ),
          body: const TabBarView(children: [
            Center(
                child: Text(
                  "Home",
                  style: textStyle,
                )),
            Center(
                child: Text(
                  "Hotel",
                  style: textStyle,
                )),
            Center(
                child: Text(
                  "Hostel",
                  style: textStyle,
                )),
          ]),
        ));
  }
}