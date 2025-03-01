import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../db/app_db.dart';
import '../model/Homeleagmodel.dart';
import '../widget/appbartext.dart';
import 'ind_vs_sa_screen.dart';

class LeagListScreeen extends StatefulWidget {
  const LeagListScreeen({super.key,this.model});

  final AppDatum? model;

  @override
  State<LeagListScreeen> createState() => _LeagListScreeenState();
}

class _LeagListScreeenState extends State<LeagListScreeen> {
  late Future<HomeLeagModel?> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = profileDisplay();
  }

  Future<HomeLeagModel?> profileDisplay() async {
    try {
      String? token = await AppDB.appDB.getToken();
      debugPrint('Token $token');

      final response = await http.get(
        Uri.parse(
            'https://batting-api-1.onrender.com/api/user/desbord_details'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );
      if (response.statusCode == 200) {
        final data = HomeLeagModel.fromJson(jsonDecode(response.body));
        debugPrint('Data: ${data.message}');
        print("print from if part ${response.body}");
        return data;
      } else {
        debugPrint('Failed to fetch profile data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching profile data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title:AppBarText(color: Colors.white, text: "Indian Premier League") ,
        backgroundColor: const Color(0xffF0F1F5),
        elevation: 0, // Remove shadow
        centerTitle: true,
        flexibleSpace: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          height: 100,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff1D1459), Color(0xff140B40)],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  AppBarText(color: Colors.white, text:widget.model?.leagueDetails?.leaguaName??''),
                  Container(width: 20),
                ],
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<HomeLeagModel?>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!;
            final premier = data.data?[0].leagueDetails?.matches;
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: const Color(0xffF0F1F5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount:data.data?[0].leagueDetails?.matches?.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => IndVsSaScreens(
                                          matchName: premier?[index].matchName,
                                          Id: premier?[index].id,
                                        ),
                                      ),
                                    );

                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 171,
                                        padding: const EdgeInsets.only(top: 8),
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                            image: AssetImage('assets/Frame 5223.png'),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.red,
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 40,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text( data.data?[0].leagueDetails!.matches?[index].matchName?.split(' ') [ 0] ?? "",
                                                    // data.data[index]?.leagueDetails?.matches?.first?.matchName?.split(' ')[0] ?? '',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 7),
                                                  Image.asset('assets/vs.png', height: 40),
                                                  const SizedBox(width: 7),

                                                  Text( data.data?[0].leagueDetails!.matches?[index].matchName?.split(' ') [2] ?? "",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        child: Container(
                                          padding: const EdgeInsets.only(left: 20, right: 25),
                                          height: 96,
                                          width: 353,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const SizedBox(height: 3),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 80,
                                                    child: Column(
                                                      children: [
                                                        Text( data.data?[0].leagueDetails!.matches?[index].team1Details?.teamName ?? "",
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w500,
                                                            color: Color(0xffFFCB05),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    child: Column(
                                                      children: [
                                                        const Text(
                                                          "55m 27s",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w700,
                                                            color: Color(0xffDC0000),
                                                          ),
                                                        ),
                                                        Column(
                                                          children: [
                                                            Text( data.data?[0].leagueDetails!.matches?[index].time ?? "",
                                                              style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 55,
                                                    child: Column(
                                                      children: [
                                                        Text( data.data?[0].leagueDetails!.matches?[index].team2Details?.teamName ?? "",
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w500,
                                                            color: Color(0xff005195),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: 1,
                                                width: MediaQuery.of(context).size.width,
                                                color: Colors.grey.shade300,
                                              ),
                                              const Text(
                                                "Mega Content ₹70 Crores",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xffD4AF37),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 27,
                                        left: 20,
                                        child: Image.asset('assets/csk.png', height: 63),
                                      ),
                                      Positioned(
                                        top: 34,
                                        right: 27,
                                        child: Image.asset('assets/mubai.png', height: 47),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        )),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
