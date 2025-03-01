import 'package:batting_app/screens/settingscreen.dart';
import 'package:batting_app/screens/winnerScreens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../homescreens.dart';
import '../widget/appbarscreen.dart';
import '../widget/balance_notifire.dart';
import 'my_matches.dart';

class Bottom extends StatelessWidget {
  const Bottom({super.key});



  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreens(matchID: '', matchName: '',),
    // const HomeTwoScreens(),
    const WinnerScreen(isfromhomescreen:true),
    const MatchesScreen(),
    const SettingScreen()
  ];
  // DateTime? _currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    final balanceNotifier = Provider.of<BalanceNotifier>(context); // Access BalanceNotifier


    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70.0), child: Appbarscreen(balanceNotifier: balanceNotifier)),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 0.1,
            )
          ],
        ),
        child: BottomNavigationBar(
          unselectedLabelStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          selectedLabelStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/solar_home-angle-bold.png',
                      height: 26, color: const Color(0xff140B40)),
                  const SizedBox(height: 8),
                ],
              ),
              backgroundColor: Colors.white,
              icon: Column(
                children: [
                  Image.asset('assets/solar_home-angle-bold (1).png',
                      height: 26, color: const Color(0xff140B40)),
                  const SizedBox(height: 8),
                ],
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              activeIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/Winner_active2 (1).png',
                      height: 26, color: const Color(0xff140B40)),
                  const SizedBox(height: 8),
                ],
              ),
              backgroundColor: Colors.white,
              icon: Column(
                children: [
                  Image.asset('assets/Winner_black1 (1).png',
                      height: 26, color: const Color(0xff140B40)),
                  const SizedBox(height: 8),
                ],
              ),
              label: 'Winner',
            ),
            // BottomNavigationBarItem(
            //   activeIcon: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Image.asset('assets/Winner_actives.png',
            //           height: 26, color: const Color(0xff140B40)),
            //       const SizedBox(height: 8),
            //     ],
            //   ),
            //   backgroundColor: Colors.white,
            //   icon: Column(
            //     children: [
            //       Image.asset('assets/winner_black.png',
            //           height: 26, color: const Color(0xff140B40)),
            //       const SizedBox(height: 8),
            //     ],
            //   ),
            //   label: 'Winner',
            // ),
            BottomNavigationBarItem(
              activeIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/Matches_Active.png',
                      height: 26, color: const Color(0xff140B40)),
                  const SizedBox(height: 8),
                ],
              ),
              backgroundColor: Colors.white,
              icon: Column(
                children: [
                  Image.asset('assets/Matches_Normal.png',
                      height: 26, color: const Color(0xff140B40)),
                  const SizedBox(height: 8),
                ],
              ),
              label: 'My Matches',
            ),
            BottomNavigationBarItem(
              activeIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/Settings_Active.png',
                      height: 26, color: const Color(0xff140B40)),
                  const SizedBox(height: 8),
                ],
              ),
              backgroundColor: Colors.white,
              icon: Column(
                children: [
                  Image.asset('assets/Setting_Normal.png',
                      height: 26, color: const Color(0xff140B40)),
                  const SizedBox(height: 8),
                ],
              ),
              label: 'Setting',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff140B40),
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
