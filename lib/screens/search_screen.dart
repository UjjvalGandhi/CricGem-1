import 'package:batting_app/screens/ind_vs_sa_screen.dart';
import 'package:flutter/material.dart';
import '../widget/smalltext.dart';
import 'bnb.dart';

class SearchScreen extends StatefulWidget {

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List player = [
    "assets/sachin.jpg",
    'assets/maxwell.jpg',
    'assets/kohli.jpg',
    'assets/football.jpg',
    'assets/dhoni.jpg',
    "assets/football2.jpg"
  ];

  List<Image> teams = [
    Image.asset(
      'assets/indea.png',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/csk.webp',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/mi.png',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/rcb.jpg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/africa.webp',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/football2.jpg',
      fit: BoxFit.cover,
    ),
  ];
  List<String> playerName = [
    "Name",
    "Name ",
    "Name",
    "Name",
    "Name",
    "Name",
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:false,
      onPopInvokedWithResult: (didPop, result) async {
        // Navigate to HomeScreens when back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
        );
        return; // Prevent the default back navigation
      },
      child: Scaffold(
        // appBar: PreferredSize(
        //     preferredSize: const Size.fromHeight(63.0), child: Appbarscreen()),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          color: const Color(0xffF0F1F5),
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            //physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),


                Container(
                  padding: const EdgeInsets.only(bottom: 6),
                  height: 41,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(10), // Set rounded corner radius
                  ),
                  child: Center(
                    child: TextFormField(
                      style: const TextStyle(fontSize: 15),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
      contentPadding: const EdgeInsets.only(left: 5,bottom: 8),
                        hintText: "Search Your Matches, Team etc..",
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 5, top: 5),
                          child: Icon(
                            Icons.search,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "I'm Searching for",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black45),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/match.png',
                            height: 14,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            "Matches",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/team.png',
                            height: 14,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            "Teams",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/team.png',
                            height: 14,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            "Players",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Recently Searched",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                SmallText(color: Colors.grey, text: "Players"),
                const SizedBox(
                  height: 6,
                ),
                SizedBox(
                  height: 100,
                  //color: Colors.red,
                  child: ListView.builder(
                    itemCount: player.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(player[index]),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            playerName[index],
                            style: const TextStyle(fontSize: 14),
                          )
                        ],
                      );
                    },
                  ),
                ),
                SmallText(color: Colors.grey, text: "Matches"),
                const SizedBox(
                  height: 6,
                ),
                SizedBox(
                  height: 125,
                  child: ListView.builder(
                    itemCount: 2,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (index == 0) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  IndVsSaScreens(),
                                ));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Row(
                                    children: [
                                      Text(
                                        "22 March 2024 - ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "10:30 am",
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Container(
                                    height: 0.8,
                                    width: 200,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 30,
                                        height: 20,
                                        child: Image.asset('assets/india.png'),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      const Text(
                                        "India",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 30,
                                        height: 20,
                                        child: Image.asset('assets/nz.png'),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      const Text(
                                        "South Africa",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SmallText(color: Colors.grey, text: "Teams"),
                const SizedBox(
                  height: 6,
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    itemCount: teams.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.red,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: teams[index],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
