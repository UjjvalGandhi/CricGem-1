import 'dart:convert';
import 'package:batting_app/screens/point_systum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../db/app_db.dart';
import '../model/PlayerModel.dart';
import '../widget/appbartext.dart';
import '../widget/small3.dart';
import 'content_inside screen.dart';
import 'contestScreenList.dart';
import 'create_team_next.dart';
import 'ind_vs_sa_screen.dart';

class SelectedPlayer {
  final Player player;
  final String teamShortName;
  final String? role; // Make role nullable
  SelectedPlayer(this.player, this.teamShortName, this.role);
}

class CreateTeamScreen extends StatefulWidget {
  final String? Id;
  final String? matchId;
  final String? contestID;
  final List<String>? currentuserids; // Add this line in ContestMatchList

  final String? matchName;
  final String? firstMatch;
  final String? secMatch;
  final bool isMyTeam;
  final bool isJoinContestScreen;
  final bool isContestScreen;

  final String? amount;
  final String? time;

  const CreateTeamScreen(
      {super.key,
      required this.Id,
      this.time,
      this.matchId,
      this.matchName,
      this.contestID,
      this.amount,
      this.currentuserids,
      this.firstMatch,
      this.isMyTeam = false,
      this.isContestScreen = false,
      this.isJoinContestScreen = false,
      this.secMatch});
  @override
  _CreateTeamScreenState createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen>
    with SingleTickerProviderStateMixin {
  var team1name;
  var team2name;
  late TabController _tabController;
  late DateTime matchDateTime;
  late Duration remainingTime;
  String formatRemainingTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return "${hours}h ${minutes}m left";
  }

  List<bool> isSelectedListWK = [];
  List<SelectedPlayer> selectedPlayersWithTeams = [];
  var shortname;
  List<bool> isSelectedListBAT = [];
  List<bool> isSelectedListAR = [];
  List<bool> isSelectedListBOWL = [];
  late Future<PlayerModel?> _futureData;
  List<Player> selectedPlayers = [];
  List<Player> selectedPlayersPoint = [];
  List<Player> selectedPlayersPhoto = [];
  List<TeamDetails> teamLogos = [];
  int wicketKeeperCount = 0;
  int batsmanCount = 0;
  int allrounderCount = 0;
  int bowlerCount = 0;
  int team1PlayerCount = 0;
  int team2PlayerCount = 0;
  @override
  void initState() {
    super.initState();
    print('id for match is :------ ${widget.Id}');
    _futureData = playerDisplay();
    print('Api called for display player.....');
    _tabController = TabController(length: 4, vsync: this);
    updateSelectedPlayerCounts();
  }

  void updateSelectedPlayerCounts() {
    setState(() {
      wicketKeeperCount = selectedPlayers
          .where((player) => player.role == 'Wicket Keeper')
          .length;
      batsmanCount =
          selectedPlayers.where((player) => player.role == 'Batsman').length;
      allrounderCount = selectedPlayers
          .where((player) => player.role == 'All Rounder')
          .length;
      bowlerCount =
          selectedPlayers.where((player) => player.role == 'Bowler').length;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int selectedCount = 0;
  int maxSelections = 11;
  Future<PlayerModel?> playerDisplay() async {
    print('Api called for display player111111111111111111.....');
    try {
      String? token = await AppDB.appDB.getToken();
      final response = await http.get(
        Uri.parse(
            'https://batting-api-1.onrender.com/api/player/getplayers?matchId=${widget.Id}'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token",
        },
      );
      if (response.statusCode == 200) {
        print('Api called for display player22222222222222222222222.....');
        final data = PlayerModel.fromJson(jsonDecode(response.body));
        print('Response data for player..................:-${response.body}');
        // matchDateTime = DateTime.parse(data.data[0].date.toString())
        //     .add(Duration(
        //     hours: int.parse(data.data[0].time.split(':')[0]),
        //     minutes: int.parse(data.data[0].time.split(':')[1])));
        matchDateTime = DateTime.parse(data.data[0].date.toString()).add(
          Duration(
            hours: int.parse(data.data[0].time.toString().split(':')[0]),
            minutes: int.parse(data.data[0].time.split(':')[1]),
          ),
        );
        print("Match DateTime (IST): $matchDateTime");
        DateTime currentTimeIST = DateTime.now().toUtc().add(const Duration(
            hours: 5, minutes: 30)); // Convert current time to IST
        remainingTime = matchDateTime.difference(currentTimeIST);
        // remainingTime = matchDateTime.difference(DateTime.now());
        setState(() {
          teamLogos = [
            data.data.first.team1Details,
            data.data.first.team2Details,
          ];
          shortname = [
            data.data.first.team1Details.teamShortName,
            data.data.first.team2Details.teamShortName,
          ];
          team1name = data.data.first.team1Details.teamShortName;
          team2name = data.data.first.team2Details.teamShortName;
        });
        initializeSelectionLists(data);
        return data;
      } else {
        print('Api called for display player333333333333333333333.....');
        debugPrint('Failed to fetch contest data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching contest data: $e');
      return null;
    }
  }

  void initializeSelectionLists(PlayerModel data) {
    for (var classifiedPlayer in data.data.first.classifiedPlayers) {
      if (classifiedPlayer.role == 'Wicket Keeper') {
        isSelectedListWK =
            List<bool>.filled(classifiedPlayer.players.length, false);
      } else if (classifiedPlayer.role == 'Batsman') {
        isSelectedListBAT =
            List<bool>.filled(classifiedPlayer.players.length, false);
      } else if (classifiedPlayer.role == 'All Rounder') {
        isSelectedListAR =
            List<bool>.filled(classifiedPlayer.players.length, false);
      } else if (classifiedPlayer.role == 'Bowler') {
        isSelectedListBOWL =
            List<bool>.filled(classifiedPlayer.players.length, false);
      }
    }
  }

  void onPlayerSelect(Player player, bool isSelected) {
    setState(() {
      print('player role is :- ${player.role}');
      if (isSelected) {
        if (player.teamShortName == teamLogos[0].teamShortName &&
            team1PlayerCount >= 7) {
          // Prevent selection if team 1 already has 7 players
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Team 1 already has 7 players.')),
          );
          return;
        } else if (player.teamShortName == teamLogos[1].teamShortName &&
            team2PlayerCount >= 7) {
          // Prevent selection if team 2 already has 7 players
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Team 2 already has 7 players.')),
          );
          return;
        }
        print("Selecting player: ${player.playerName}");
        selectedPlayers.add(player);
        String teamShortName = player.teamShortName;
        String? playerRole = player.role!;
        if (playerRole.isNotEmpty) {
          print('player role is :- $playerRole');
          selectedPlayersWithTeams
              .add(SelectedPlayer(player, teamShortName, playerRole));
        } else {
          print(
              "Player role is empty or null for player: ${player.playerName}");
        }
        if (teamShortName == teamLogos[0].teamShortName) {
          team1PlayerCount++;
        } else if (teamShortName == teamLogos[1].teamShortName) {
          team2PlayerCount++;
        }
      } else {
        print("Deselecting player: ${player.playerName}");
        selectedPlayers.remove(player);
        selectedPlayersWithTeams
            .removeWhere((selectedPlayer) => selectedPlayer.player == player);
        String teamShortName = player.teamShortName;
        if (teamShortName == teamLogos[0].teamShortName) {
          team1PlayerCount--;
        } else if (teamShortName == teamLogos[1].teamShortName) {
          team2PlayerCount--;
        }
      }
      selectedCount = selectedPlayers.length;
      print("Total selected: $selectedCount");
    });
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 290,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Image.asset(
                  'assets/warning.png',
                  height: 70,
                  color: const Color(0xff140B40),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Are you sure want to",
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 0.8,
                    color: Color(0xff140B40),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Text(
                  "discard changes?",
                  style: TextStyle(
                    fontSize: 22,
                    letterSpacing: 0.8,
                    color: Color(0xff140B40),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          print('open the pop up111111111111');
                          print('time:- ${widget.time}');
                          print('contestId:- ${widget.contestID}');
                          print('match name is:- ${widget.matchName}');
                          print('id is:- ${widget.matchId}');
                          if (widget.isJoinContestScreen) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContentInside(
                                  isCreateTeam: true,
                                  time: widget.time,
                                  CId: widget.contestID,
                                  matchName: widget.matchName,
                                  Id: widget.matchId,
                                ),
                              ),
                              (route) => false, // Removes all previous routes.
                            );
                          } else if (widget.isContestScreen) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IndVsSaScreens(
                                    IsCreateTeamScreen: true,
                                    Id: widget.Id,
                                    matchName: widget.matchName),
                              ),
                              (route) => false, // Removes all previous routes.
                            );
                          } else {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContestMatchList(
                                  iscreatematch: true,
                                  firstmatch: "${widget.firstMatch}",
                                  secMatch: "${widget.secMatch}",
                                  matchName: "${widget.matchName}",
                                  cId: "${widget.contestID}",
                                  Id: "${widget.Id}",
                                  amount: "${widget.amount}",
                                  currentUserTeamIds: widget.currentuserids!
                                      .map((teamId) => teamId.split('(')[0])
                                      .toList(), // Extracting team ID before '('
                                ),
                              ),
                              (route) => false, // Removes all previous routes.
                            );
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: const Color(0xff010101).withOpacity(0.35),
                          ),
                          child: const Center(
                            child: Text(
                              "Discard",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          print('open the pop up 222222222222222');
                          Navigator.of(context).pop(false); // User pressed No
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: const Color(0xff140B40),
                          ),
                          child: const Center(
                            child: Text(
                              "Countinue",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) => value ?? false); // Return false if dialog is dismissed
  }

  Future<bool> _showPlayerRemoveDialougeBox(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 290, // Match the height from _dialogBuilder
            width: MediaQuery.of(context)
                .size
                .width, // Match the width from _dialogBuilder
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Image.asset(
                  'assets/warning.png',
                  height: 70,
                  color: const Color(0xff140B40),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Are you sure want to",
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 0.8,
                    color: Color(0xff140B40),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Text(
                  "discard changes?",
                  style: TextStyle(
                    fontSize: 22,
                    letterSpacing: 0.8,
                    color: Color(0xff140B40),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          isSelectedListWK.fillRange(
                              0, isSelectedListWK.length, false);
                          isSelectedListBAT.fillRange(
                              0, isSelectedListBAT.length, false);
                          isSelectedListAR.fillRange(
                              0, isSelectedListAR.length, false);
                          isSelectedListBOWL.fillRange(
                              0, isSelectedListBOWL.length, false);

                          // Clear the selected players lists
                          selectedPlayers.clear();
                          selectedPlayersWithTeams.clear();

                          // Reset counts
                          selectedCount = 0;
                          team1PlayerCount = 0;
                          team2PlayerCount = 0;

                          // Update UI
                          updateSelectedPlayerCounts();
                          Navigator.pop(context); // Close the dialog box
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: const Color(0xff010101).withOpacity(0.35),
                          ),
                          child: const Center(
                            child: Text(
                              "Discard",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          print('open the pop up 222222222222222');
                          Navigator.of(context).pop(false); // User pressed No
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: const Color(0xff140B40),
                          ),
                          child: const Center(
                            child: Text(
                              "Countinue",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) => value ?? false); // Return false if dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return PopScope(
      canPop: false, // Prevent the default back action
      onPopInvokedWithResult: (didPop, result) async {
        await Future.microtask(() async {
          if (team1PlayerCount > 0 || team2PlayerCount > 0) {
            await _showExitConfirmationDialog(context);
          } else {
            if (widget.isJoinContestScreen) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ContentInside(
                    isCreateTeam: true,
                    time: widget.time,
                    CId: widget.contestID,
                    matchName: widget.matchName,
                    Id: widget.matchId,
                  ),
                ),
                (route) => false, // Removes all previous routes.
              );
            } else if (widget.isContestScreen) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => IndVsSaScreens(
                      IsCreateTeamScreen: true,
                      Id: widget.Id,
                      matchName: widget.matchName),
                ),
                (route) => false, // Removes all previous routes.
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ContestMatchList(
                    iscreatematch: true,
                    firstmatch: "${widget.firstMatch}",
                    secMatch: "${widget.secMatch}",
                    matchName: "${widget.matchName}",
                    cId: "${widget.contestID}",
                    Id: "${widget.Id}",
                    amount: "${widget.amount}",
                    currentUserTeamIds: widget.currentuserids!
                        .map((teamId) => teamId.split('(')[0])
                        .toList(), // Extracting team ID before '('
                  ),
                ),
                (route) => false, // Removes all previous routes.
              );
            }
          }
        });
      },
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: const Color(0xff140B40),
          backgroundColor: const Color(0xff140B40),
          elevation: 0,
          leading: InkWell(
              onTap: () async {
                if (team1PlayerCount > 0 || team2PlayerCount > 0) {
                  await _showExitConfirmationDialog(context);
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Icon(
                Icons.keyboard_backspace,
                size: 30,
                color: Colors.white,
              )),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppBarText(color: Colors.white, text: "Create Team"),
              FutureBuilder<PlayerModel?>(
                future: _futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Small3Text(color: Colors.white, text: "Loading...");
                  } else if (snapshot.hasError) {
                    return Small3Text(
                        color: Colors.white, text: "Error loading time");
                  } else if (snapshot.hasData) {
                    final data = snapshot.data;
                    final remaining = formatRemainingTime(remainingTime);
                    return Small3Text(color: Colors.white, text: remaining);
                  } else {
                    return Small3Text(
                        color: Colors.white, text: "No data available");
                  }
                },
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PointSystumScreen(),
                      ));
                },
                child: Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(width: 0.8, color: Colors.white)),
                  child: const Center(
                    child: Text(
                      "P",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: FutureBuilder<PlayerModel?>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xffF0F1F5),
                  child: const Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || teamLogos.isEmpty) {
              return const Center(child: Text('No data available'));
            } else {
              return SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xffF0F1F5),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 160,
                            width: MediaQuery.of(context).size.width,
                            decoration:
                                const BoxDecoration(color: Color(0xff140B40)),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Maximum 10 players from one team",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: 11,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              height: 20,
                                              width: 20,
                                              margin: const EdgeInsets.only(
                                                  right: 2),
                                              decoration: BoxDecoration(
                                                color:
                                                    selectedCount >= index + 1
                                                        ? Colors.white
                                                        : Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await _showPlayerRemoveDialougeBox(
                                              context);
                                        },
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.white)),
                                          child: const Center(
                                              child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: 16,
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 22, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Credits Left",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            "100",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 48,
                                        width: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                height: 13,
                                                child: teamLogos.isNotEmpty
                                                    ? Image.network(
                                                        teamLogos[0].teamLogo,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            const Icon(
                                                                Icons.error),
                                                      )
                                                    : Container(),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                "${teamLogos[0].teamShortName} - $team1PlayerCount",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                height: 13,
                                                child: teamLogos.length > 1
                                                    ? Image.network(
                                                        teamLogos[1].teamLogo,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            const Icon(
                                                                Icons.error),
                                                      )
                                                    : Container(),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                "${teamLogos[1].teamShortName} - $team2PlayerCount",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 44,
                                        width: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Players",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            "$selectedCount/11",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorColor: const Color(0xff140B40),
                              labelColor: const Color(0xff140B40),
                              unselectedLabelColor: Colors.grey,
                              tabs: [
                                Tab(text: 'WK($wicketKeeperCount)'),
                                Tab(text: 'BAT($batsmanCount)'),
                                Tab(text: 'AR($allrounderCount)'),
                                Tab(text: 'BOWL($bowlerCount)'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 15, bottom: 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Selected By",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 10,
                                ),
                                const Text(
                                  "Points",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                                const Row(
                                  children: [
                                    Text(
                                      "Ceadit",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.grey),
                                    ),
                                    SizedBox(width: 3),
                                    Icon(
                                      Icons.arrow_downward,
                                      size: 13,
                                      color: Colors.grey,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                buildTabContent(
                                    isSelectedListWK, 'Wicket Keeper'),
                                buildTabContent(isSelectedListBAT, 'Batsman'),
                                buildTabContent(
                                    isSelectedListAR, 'All Rounder'),
                                buildTabContent(isSelectedListBOWL, 'Bowler'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(20.w),
          color: Colors.white,
          child: InkWell(
            onTap: () {
              int wicketKeepers =
                  isSelectedListWK.where((isSelected) => isSelected).length;
              int batsmen =
                  isSelectedListBAT.where((isSelected) => isSelected).length;
              int allrounders =
                  isSelectedListAR.where((isSelected) => isSelected).length;
              int bowlers =
                  isSelectedListBOWL.where((isSelected) => isSelected).length;
              print('Wicket Keepers: $wicketKeepers');
              print('Batsmen: $batsmen');
              print('All Rounders: $allrounders');
              print('Bowlers: $bowlers');
              print('Selected Count: $selectedCount');
              setState(() {
                if (wicketKeepers < 1 ||
                    batsmen < 1 ||
                    allrounders < 1 ||
                    bowlers < 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Center(
                          child: Text(
                              'Please select at least one player from each role.')),
                    ),
                  );
                } else if (selectedCount == 11) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateTeamNext(
                        isFromContestScreen: widget.isContestScreen,
                        isFromJoinContest: widget.isJoinContestScreen,
                        isFromMyTeam: widget.isMyTeam,
                        time: formatRemainingTime(remainingTime),
                        selectedPlayers: selectedPlayers,
                        selectedPlayersWithTeams:
                            selectedPlayersWithTeams, // Pass the selected players with team short names
                        cId: widget.contestID,
                        amount: widget.amount,
                        firstMatch: widget.firstMatch,
                        secMatch: widget.secMatch,
                        currentuserteamids: widget.currentuserids,
                        Id: widget.Id,
                        //point:,
                        matchName: widget.matchName,
                        team1: team1name,
                        team2: team2name,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                        child: Text(
                            "Selected $selectedCount players. Please select 11 players."),
                      ),
                    ),
                  );
                }
              });
            },
            child: Container(
              height: 47,
              width: 166,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: selectedCount == 11
                    ? const Color(0xff140B40)
                    : Colors.grey.shade300,
              ),
              child: const Center(
                child: Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTabContent(List<bool> isSelectedList, String role) {
    return FutureBuilder<PlayerModel?>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        } else {
          final playerData = snapshot.data;

          List<Player> team1Players = [];
          List<Player> team2Players = [];

          // Separate players by team and role
          for (var classifiedPlayer
              in playerData!.data.first.classifiedPlayers) {
            if (classifiedPlayer.role == role) {
              for (var player in classifiedPlayer.players) {
                if (player.teamShortName == teamLogos[0].teamShortName) {
                  team1Players.add(player);
                } else if (player.teamShortName == teamLogos[1].teamShortName) {
                  team2Players.add(player);
                }
              }
            }
          }

          // Interleave players from both teams
          List<Player> interleavedPlayers = [];
          int maxLength = team1Players.length > team2Players.length
              ? team1Players.length
              : team2Players.length;

          for (int i = 0; i < maxLength; i++) {
            if (i < team1Players.length)
              interleavedPlayers.add(team1Players[i]);
            if (i < team2Players.length)
              interleavedPlayers.add(team2Players[i]);
          }

          // Calculate dynamic height
          final double baseHeight = MediaQuery.of(context).size.height * 0.50.h;
          final double bottomPadding =
              MediaQuery.of(context).padding.bottom - 22.h;
          final double containerHeight = baseHeight + bottomPadding;

          double availableHeight = MediaQuery.of(context).size.height -
              AppBar().preferredSize.height - // Height of the AppBar
              kBottomNavigationBarHeight; // Height of the Bottom Navigation Bar

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height:
                      availableHeight - 270.h, // Dynamically calculated height
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: interleavedPlayers.length,
                    itemBuilder: (context, index) {
                      if (index >= isSelectedList.length) {
                        debugPrint('Index out of bounds: $index');
                        return Container();
                      }

                      final player = interleavedPlayers[index];
                      final isTeamFull = (player.teamShortName ==
                                  teamLogos[0].teamShortName &&
                              team1PlayerCount >= 7) ||
                          (player.teamShortName == teamLogos[1].teamShortName &&
                              team2PlayerCount >= 7);
                      final isSelectable = !isTeamFull || isSelectedList[index];

                      final nameParts = player.playerName.split(' ');
                      final shortName = nameParts.length > 1
                          ? '${nameParts[0][0]} ${nameParts[1]}'
                          : player.playerName;

                      return GestureDetector(
                        onTap: () {
                          if (!isSelectable) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Maximum players allowed from 1 team.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }
                          setState(() {
                            if (selectedCount < maxSelections ||
                                isSelectedList[index]) {
                              isSelectedList[index] = !isSelectedList[index];
                              if (isSelectedList[index]) {
                                selectedPlayers.add(player);
                                if (player.teamShortName ==
                                    teamLogos[0].teamShortName) {
                                  team1PlayerCount++;
                                } else if (player.teamShortName ==
                                    teamLogos[1].teamShortName) {
                                  team2PlayerCount++;
                                }
                              } else {
                                selectedPlayers.remove(player);
                                if (player.teamShortName ==
                                    teamLogos[0].teamShortName) {
                                  team1PlayerCount--;
                                } else if (player.teamShortName ==
                                    teamLogos[1].teamShortName) {
                                  team2PlayerCount--;
                                }
                              }
                              selectedCount = calculateSelectedCount();
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: isSelectedList[index]
                                ? Colors.yellow.withOpacity(0.2)
                                : (isSelectable
                                    ? Colors.transparent
                                    : Colors.grey.withOpacity(0.5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Image.network(
                                      player.playerPhoto ?? "",
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                            'assets/dummy_player.png');
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shortName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Text(
                                        "Sel by 73.34%",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const Text(
                                        "Played last match (Sub)",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    player.totalPoints.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(width: 50.w),
                                  Text(
                                    player.credit.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(width: 40.w),
                                  Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.5),
                                      color: isSelectable
                                          ? (isSelectedList[index]
                                              ? Colors.transparent
                                              : Colors.green.withOpacity(0.2))
                                          : Colors.grey.withOpacity(0.5),
                                      border: Border.all(
                                        color: isSelectedList[index]
                                            ? Colors.green
                                            : Colors.transparent,
                                      ),
                                    ),
                                    child: Icon(
                                      isSelectedList[index]
                                          ? Icons.remove
                                          : Icons.add,
                                      size: 15,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }
      },
    );
  }

  // Widget buildTabContent(List<bool> isSelectedList, String role) {
  //   return FutureBuilder<PlayerModel?>(
  //     future: _futureData,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       } else if (snapshot.hasError) {
  //         return Center(child: Text('Error: ${snapshot.error}'));
  //       } else if (!snapshot.hasData) {
  //         return const Center(child: Text('No data available'));
  //       } else {
  //         final playerData = snapshot.data;
  //
  //         List<Player> team1Players = [];
  //         List<Player> team2Players = [];
  //
  //         // Separate players by team and role
  //         for (var classifiedPlayer in playerData!.data.first.classifiedPlayers) {
  //           if (classifiedPlayer.role == role) {
  //             for (var player in classifiedPlayer.players) {
  //               if (player.teamShortName == teamLogos[0].teamShortName) {
  //                 team1Players.add(player);
  //               } else if (player.teamShortName == teamLogos[1].teamShortName) {
  //                 team2Players.add(player);
  //               }
  //             }
  //           }
  //         }
  //
  //         // Interleave players from both teams
  //         List<Player> interleavedPlayers = [];
  //         int maxLength = team1Players.length > team2Players.length
  //             ? team1Players.length
  //             : team2Players.length;
  //
  //
  //         for (int i = 0; i < maxLength; i++) {
  //           if (i < team1Players.length) interleavedPlayers.add(team1Players[i]);
  //           if (i < team2Players.length) interleavedPlayers.add(team2Players[i]);
  //         }
  //
  //         return SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               SizedBox(
  //                 height: MediaQuery.of(context).size.height * 0.51, // Responsive height
  //                 child: ListView.builder(
  //                   shrinkWrap: true,
  //                   itemCount: interleavedPlayers.length,
  //                   itemBuilder: (context, index) {
  //                     if (index >= isSelectedList.length) {
  //                       debugPrint('Index out of bounds: $index');
  //                       return Container();
  //                     }
  //                     final nameParts = interleavedPlayers[index].playerName.split(' ');
  //                     final shortName = nameParts.length > 1
  //                         ? '${nameParts[0][0]} ${nameParts[1]}'
  //                         : interleavedPlayers[index].playerName;
  //                     return GestureDetector(
  //                       onTap: () {
  //                         setState(() {
  //                           if (selectedCount < maxSelections || isSelectedList[index]) {
  //                             isSelectedList[index] = !isSelectedList[index];
  //                             if (isSelectedList[index]) {
  //                               selectedPlayers.add(interleavedPlayers[index]);
  //                               if (interleavedPlayers[index].teamShortName ==
  //                                   teamLogos[0].teamShortName) {
  //                                 team1PlayerCount++;
  //                               } else if (interleavedPlayers[index].teamShortName ==
  //                                   teamLogos[1].teamShortName) {
  //                                 team2PlayerCount++;
  //                               }
  //                             } else {
  //                               selectedPlayers.remove(interleavedPlayers[index]);
  //                               if (interleavedPlayers[index].teamShortName ==
  //                                   teamLogos[0].teamShortName) {
  //                                 team1PlayerCount--;
  //                               } else if (interleavedPlayers[index].teamShortName ==
  //                                   teamLogos[1].teamShortName) {
  //                                 team2PlayerCount--;
  //                               }
  //                             }
  //                             selectedCount = calculateSelectedCount();
  //                           }
  //                         });
  //                       },
  //                       child: Container(
  //                         margin: const EdgeInsets.only(bottom: 5),
  //                         height: 70,
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(8),
  //                           color: isSelectedList[index]
  //                               ? Colors.yellow.withOpacity(0.2)
  //                               : Colors.transparent,
  //                         ),
  //                         child: Padding(
  //                           padding: const EdgeInsets.symmetric(horizontal: 20),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               SizedBox(
  //                                 height: 60,
  //                                 width: MediaQuery.of(context).size.width / 2,
  //                                 child: Row(
  //                                   children: [
  //                                     SizedBox(
  //                                       height: 44,
  //                                       width: 44,
  //                                       child: Image.network(
  //                                         interleavedPlayers[index].playerPhoto ?? "",
  //                                         errorBuilder: (context, error, stackTrace) {
  //                                           return Image.asset('assets/dummy_player.png');
  //                                         },
  //                                       ),
  //                                     ),
  //                                     SizedBox(
  //                                       height: 66,
  //                                       width: MediaQuery.of(context).size.width * 0.3,
  //                                       child: Column(
  //                                         crossAxisAlignment:
  //                                         CrossAxisAlignment.start,
  //                                         children: [
  //                                           Text(
  //                                             shortName ?? '',
  //                                             // interleavedPlayers[index]
  //                                             //     .playerName ??
  //                                             //     "",
  //                                             softWrap: true,
  //                                             overflow: TextOverflow.ellipsis,
  //                                             style: const TextStyle(
  //                                               fontSize: 13,
  //                                               fontWeight: FontWeight.w500,
  //                                             ),
  //                                           ),
  //                                           const Text(
  //                                             "Sel by 73.34%",
  //                                             softWrap: true,
  //                                             overflow: TextOverflow.ellipsis,
  //                                             style: TextStyle(
  //                                               fontSize: 10,
  //                                               color: Colors.grey,
  //                                             ),
  //                                           ),
  //                                           const Text(
  //                                             "Played last match (Sub)",
  //                                             softWrap: true,
  //                                             overflow: TextOverflow.ellipsis,
  //                                             style: TextStyle(
  //                                               fontSize: 10,
  //                                               color: Colors.grey,
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.only(right: 15),
  //                                 child: Text(
  //                                   interleavedPlayers[index].totalPoints.toString(),
  //                                 ),
  //                               ),
  //                               const SizedBox(width: 20),
  //                               Text(interleavedPlayers[index].credit.toString()),
  //                               const SizedBox(width: 3),
  //                               SizedBox(
  //                                 height: 60,
  //                                 width: 20,
  //                                 child: Center(
  //                                   child: Container(
  //                                     height: 21,
  //                                     width: 21,
  //                                     decoration: BoxDecoration(
  //                                       borderRadius: BorderRadius.circular(11),
  //                                       color: isSelectedList[index]
  //                                           ? Colors.transparent
  //                                           : Colors.green.withOpacity(0.2),
  //                                       border: Border.all(
  //                                         width: 1,
  //                                         color: isSelectedList[index]
  //                                             ? Colors.green
  //                                             : Colors.transparent,
  //                                       ),
  //                                     ),
  //                                     child: isSelectedList[index]
  //                                         ? const Icon(
  //                                       Icons.remove,
  //                                       size: 15,
  //                                       color: Colors.green,
  //                                     )
  //                                         : const Icon(
  //                                       Icons.add,
  //                                       size: 15,
  //                                       color: Colors.green,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //             ],
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }
  // Widget buildTabContent(List<bool> isSelectedList, String role) {
  //   return FutureBuilder<PlayerModel?>(
  //     future: _futureData,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       } else if (snapshot.hasError) {
  //         return Center(child: Text('Error: ${snapshot.error}'));
  //       } else if (!snapshot.hasData) {
  //         return const Center(child: Text('No data available'));
  //       } else {
  //         final playerData = snapshot.data;
  //
  //         List<Player> team1Players = [];
  //         List<Player> team2Players = [];
  //
  //         // Separate players by team and role
  //         for (var classifiedPlayer in playerData!.data.first.classifiedPlayers) {
  //           if (classifiedPlayer.role == role) {
  //             for (var player in classifiedPlayer.players) {
  //               if (player.teamShortName == teamLogos[0].teamShortName) {
  //                 team1Players.add(player);
  //               } else if (player.teamShortName == teamLogos[1].teamShortName) {
  //                 team2Players.add(player);
  //               }
  //             }
  //           }
  //         }
  //
  //         // Interleave players from both teams
  //         List<Player> interleavedPlayers = [];
  //         int maxLength = team1Players.length > team2Players.length
  //             ? team1Players.length
  //             : team2Players.length;
  //
  //         for (int i = 0; i < maxLength; i++) {
  //           if (i < team1Players.length) interleavedPlayers.add(team1Players[i]);
  //           if (i < team2Players.length) interleavedPlayers.add(team2Players[i]);
  //         }
  //
  //         return SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               SizedBox(
  //                 height: MediaQuery.of(context).size.height * 0.484.h, // Responsive height
  //                 child: ListView.builder(
  //                   shrinkWrap: true,
  //                   itemCount: interleavedPlayers.length,
  //                   // itemBuilder: (context, index) {
  //                   //   if (index >= isSelectedList.length) {
  //                   //     debugPrint('Index out of bounds: $index');
  //                   //     return Container();
  //                   //   }
  //                   //   final player = interleavedPlayers[index];
  //                   //   final isTeamFull = (player.teamShortName == teamLogos[0].teamShortName && team1PlayerCount >= 7) ||
  //                   //       (player.teamShortName == teamLogos[1].teamShortName && team2PlayerCount >= 7);
  //                   //   final nameParts = player.playerName.split(' ');
  //                   //   final shortName = nameParts.length > 1
  //                   //       ? '${nameParts[0][0]} ${nameParts[1]}'
  //                   //       : player.playerName;
  //                   //
  //                   //   return GestureDetector(
  //                   //     onTap: isTeamFull ? null : () {
  //                   //       setState(() {
  //                   //         if (selectedCount < maxSelections || isSelectedList[index]) {
  //                   //           isSelectedList[index] = !isSelectedList[index];
  //                   //           if (isSelectedList[index]) {
  //                   //             selectedPlayers.add(player);
  //                   //             if (player.teamShortName == teamLogos[0].teamShortName) {
  //                   //               team1PlayerCount++;
  //                   //             } else if (player.teamShortName == teamLogos[1].teamShortName) {
  //                   //               team2PlayerCount++;
  //                   //             }
  //                   //           } else {
  //                   //             selectedPlayers.remove(player);
  //                   //             if (player.teamShortName == teamLogos[0].teamShortName) {
  //                   //               team1PlayerCount--;
  //                   //             } else if (player.teamShortName == teamLogos[1].teamShortName) {
  //                   //               team2PlayerCount--;
  //                   //             }
  //                   //           }
  //                   //           selectedCount = calculateSelectedCount();
  //                   //         }
  //                   //       });
  //                   //     },
  //                   //     child: Container(
  //                   //       margin: const EdgeInsets.only(bottom: 5),
  //                   //       height: 70,
  //                   //       decoration: BoxDecoration(
  //                   //         borderRadius: BorderRadius.circular(8),
  //                   //         color: isTeamFull
  //                   //             ? Colors.grey.withOpacity(0.5)
  //                   //             : (isSelectedList[index] ? Colors.yellow.withOpacity(0.2) : Colors.transparent),
  //                   //       ),
  //                   //       child: Padding(
  //                   //         padding: const EdgeInsets.symmetric(horizontal: 20),
  //                   //         child: Row(
  //                   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   //           crossAxisAlignment: CrossAxisAlignment.center,
  //                   //           children: [
  //                   //             SizedBox(
  //                   //               height: 60,
  //                   //               width: MediaQuery .of(context).size.width / 2,
  //                   //               child: Row(
  //                   //                 children: [
  //                   //                   SizedBox(
  //                   //                     height: 44,
  //                   //                     width: 44,
  //                   //                     child: Image.network(
  //                   //                       player.playerPhoto ?? "",
  //                   //                       errorBuilder: (context, error, stackTrace) {
  //                   //                         return Image.asset('assets/dummy_player.png');
  //                   //                       },
  //                   //                     ),
  //                   //                   ),
  //                   //                   SizedBox(
  //                   //                     height: 66,
  //                   //                     width: MediaQuery.of(context).size.width * 0.3,
  //                   //                     child: Column(
  //                   //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                   //                       children: [
  //                   //                         Text(
  //                   //                           shortName ?? '',
  //                   //                           softWrap: true,
  //                   //                           overflow: TextOverflow.ellipsis,
  //                   //                           style: const TextStyle(
  //                   //                             fontSize: 13,
  //                   //                             fontWeight: FontWeight.w500,
  //                   //                           ),
  //                   //                         ),
  //                   //                         const Text(
  //                   //                           "Sel by 73.34%",
  //                   //                           softWrap: true,
  //                   //                           overflow: TextOverflow.ellipsis,
  //                   //                           style: TextStyle(
  //                   //                             fontSize: 10,
  //                   //                             color: Colors.grey,
  //                   //                           ),
  //                   //                         ),
  //                   //                         const Text(
  //                   //                           "Played last match (Sub)",
  //                   //                           softWrap: true,
  //                   //                           overflow: TextOverflow.ellipsis,
  //                   //                           style: TextStyle(
  //                   //                             fontSize: 10,
  //                   //                             color: Colors.grey,
  //                   //                           ),
  //                   //                         ),
  //                   //                       ],
  //                   //                     ),
  //                   //                   ),
  //                   //                 ],
  //                   //               ),
  //                   //             ),
  //                   //             Padding(
  //                   //               padding: const EdgeInsets.only(right: 15),
  //                   //               child: Text(
  //                   //                 player.totalPoints.toString(),
  //                   //               ),
  //                   //             ),
  //                   //             const SizedBox(width: 20),
  //                   //             Text(player.credit.toString()),
  //                   //             const SizedBox(width: 3),
  //                   //             SizedBox(
  //                   //               height: 60,
  //                   //               width: 20,
  //                   //               child: Center(
  //                   //                 child: Container(
  //                   //                   height: 21,
  //                   //                   width: 21,
  //                   //                   decoration: BoxDecoration(
  //                   //                     borderRadius: BorderRadius.circular(11),
  //                   //                     color: isTeamFull ? Colors.grey.withOpacity(0.5) : (isSelectedList[index] ? Colors.transparent : Colors.green.withOpacity(0.2)),
  //                   //                     border: Border.all(
  //                   //                       width: 1,
  //                   //                       color: isSelectedList[index] ? Colors.green : Colors.transparent,
  //                   //                     ),
  //                   //                   ),
  //                   //                   child: isSelectedList[index]
  //                   //                       ? const Icon(
  //                   //                     Icons.remove,
  //                   //                     size: 15,
  //                   //                     color: Colors.green,
  //                   //                   )
  //                   //                       : const Icon(
  //                   //                     Icons.add,
  //                   //                     size: 15,
  //                   //                     color: Colors.green,
  //                   //                   ),
  //                   //                 ),
  //                   //               ),
  //                   //             ),
  //                   //           ],
  //                   //         ),
  //                   //       ),
  //                   //     ),
  //                   //   );
  //                   // },
  //                     itemBuilder: (context, index) {
  //                       if (index >= isSelectedList.length) {
  //                         debugPrint('Index out of bounds: $index');
  //                         return Container();
  //                       }
  //                       final player = interleavedPlayers[index];
  //
  //                       // Check if the current player is from a team that reached the 7-player limit
  //                       final isTeamFull = (player.teamShortName == teamLogos[0].teamShortName && team1PlayerCount >= 7) ||
  //                           (player.teamShortName == teamLogos[1].teamShortName && team2PlayerCount >= 7);
  //
  //                       // Determine whether this player is selectable or not
  //                       final isSelectable = !isTeamFull || isSelectedList[index];
  //
  //                       final nameParts = player.playerName.split(' ');
  //                       final shortName = nameParts.length > 1
  //                           ? '${nameParts[0][0]} ${nameParts[1]}'
  //                           : player.playerName;
  //
  //                       return GestureDetector(
  //                         // onTap: isSelectable
  //                         //     ? () {
  //                         //   setState(() {
  //                         //     if (selectedCount < maxSelections || isSelectedList[index]) {
  //                         //       isSelectedList[index] = !isSelectedList[index];
  //                         //       if (isSelectedList[index]) {
  //                         //         selectedPlayers.add(player);
  //                         //         if (player.teamShortName == teamLogos[0].teamShortName) {
  //                         //           team1PlayerCount++;
  //                         //         } else if (player.teamShortName == teamLogos[1].teamShortName) {
  //                         //           team2PlayerCount++;
  //                         //         }
  //                         //       } else {
  //                         //         selectedPlayers.remove(player);
  //                         //         if (player.teamShortName == teamLogos[0].teamShortName) {
  //                         //           team1PlayerCount--;
  //                         //         } else if (player.teamShortName == teamLogos[1].teamShortName) {
  //                         //           team2PlayerCount--;
  //                         //         }
  //                         //       }
  //                         //       selectedCount = calculateSelectedCount();
  //                         //     }
  //                         //   });
  //                         // }
  //                         //     : null,
  //                         onTap: () {
  //                           if (!isSelectable) {
  //                             // Show a snackbar if the player cannot be selected
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                               const SnackBar(
  //                                 content: Text('Maximum & player allowed from 1 Team.'),
  //                                 duration: Duration(seconds: 2),
  //                                 // backgroundColor: Colors.red,
  //                               ),
  //                             );
  //                             return;
  //                           }
  //                           setState(() {
  //                             if (selectedCount < maxSelections || isSelectedList[index]) {
  //                               isSelectedList[index] = !isSelectedList[index];
  //                               if (isSelectedList[index]) {
  //                                 selectedPlayers.add(player);
  //                                 if (player.teamShortName == teamLogos[0].teamShortName) {
  //                                   team1PlayerCount++;
  //                                 } else if (player.teamShortName == teamLogos[1].teamShortName) {
  //                                   team2PlayerCount++;
  //                                 }
  //                               } else {
  //                                 selectedPlayers.remove(player);
  //                                 if (player.teamShortName == teamLogos[0].teamShortName) {
  //                                   team1PlayerCount--;
  //                                 } else if (player.teamShortName == teamLogos[1].teamShortName) {
  //                                   team2PlayerCount--;
  //                                 }
  //                               }
  //                               selectedCount = calculateSelectedCount();
  //                             }
  //                           });
  //                         },
  //
  //                         child: Container(
  //                           margin: const EdgeInsets.only(bottom: 5),
  //                           height: 70,
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(8),
  //                             color: isSelectedList[index]
  //                                 ? Colors.yellow.withOpacity(0.2) // Selected player color
  //                                 : (isSelectable ? Colors.transparent : Colors.grey.withOpacity(0.5)), // Unselectable color
  //                           ),
  //                           child: Padding(
  //                             padding: const EdgeInsets.symmetric(horizontal: 20),
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               children: [
  //                                 SizedBox(
  //                                   height: 60,
  //                                   width: MediaQuery.of(context).size.width / 2,
  //                                   child: Row(
  //                                     children: [
  //                                       SizedBox(
  //                                         height: 44,
  //                                         width: 44,
  //                                         child: Image.network(
  //                                           player.playerPhoto ?? "",
  //                                           errorBuilder: (context, error, stackTrace) {
  //                                             return Image.asset('assets/dummy_player.png');
  //                                           },
  //                                         ),
  //                                       ),
  //                                       SizedBox(
  //                                         height: 66,
  //                                         width: MediaQuery.of(context).size.width * 0.3,
  //                                         child: Column(
  //                                           crossAxisAlignment: CrossAxisAlignment.start,
  //                                           children: [
  //                                             Text(
  //                                               shortName ?? '',
  //                                               softWrap: true,
  //                                               overflow: TextOverflow.ellipsis,
  //                                               style: const TextStyle(
  //                                                 fontSize: 13,
  //                                                 fontWeight: FontWeight.w500,
  //                                               ),
  //                                             ),
  //                                             const Text(
  //                                               "Sel by 73.34%",
  //                                               softWrap: true,
  //                                               overflow: TextOverflow.ellipsis,
  //                                               style: TextStyle(
  //                                                 fontSize: 10,
  //                                                 color: Colors.grey,
  //                                               ),
  //                                             ),
  //                                             const Text(
  //                                               "Played last match (Sub)",
  //                                               softWrap: true,
  //                                               overflow: TextOverflow.ellipsis,
  //                                               style: TextStyle(
  //                                                 fontSize: 10,
  //                                                 color: Colors.grey,
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(right: 25),
  //                                   child: Text(
  //                                     player.totalPoints.toString(),
  //                                   ),
  //                                 ),
  //                                 const SizedBox(width: 0),
  //                                 Text(player.credit.toString()),
  //                                 const SizedBox(width: 3),
  //                                 SizedBox(
  //                                   height: 60,
  //                                   width: 20,
  //                                   child: Center(
  //                                     child: Container(
  //                                       height: 21,
  //                                       width: 21,
  //                                       decoration: BoxDecoration(
  //                                         borderRadius: BorderRadius.circular(11),
  //                                         color: isSelectable
  //                                             ? (isSelectedList[index]
  //                                             ? Colors.transparent
  //                                             : Colors.green.withOpacity(0.2))
  //                                             : Colors.grey.withOpacity(0.5), // Unselectable color
  //                                         border: Border.all(
  //                                           width: 1,
  //                                           color: isSelectedList[index] ? Colors.green : Colors.transparent,
  //                                         ),
  //                                       ),
  //                                       child: isSelectedList[index]
  //                                           ? const Icon(
  //                                         Icons.remove,
  //                                         size: 15,
  //                                         color: Colors.green,
  //                                       )
  //                                           : const Icon(
  //                                         Icons.add,
  //                                         size: 15,
  //                                         color: Colors.green,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       );
  //                     }
  //
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //             ],
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }
  // Widget buildTabContent(List<bool> isSelectedList, String role) {
  //   return FutureBuilder<PlayerModel?>(
  //     future: _futureData,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       } else if (snapshot.hasError) {
  //         return Center(child: Text('Error: ${snapshot.error}'));
  //       } else if (!snapshot.hasData) {
  //         return const Center(child: Text('No data available'));
  //       } else {
  //         final playerData = snapshot.data;
  //
  //         List<Player> team1Players = [];
  //         List<Player> team2Players = [];
  //
  //         // Separate players by team and role
  //         for (var classifiedPlayer in playerData!.data.first.classifiedPlayers) {
  //           if (classifiedPlayer.role == role) {
  //             for (var player in classifiedPlayer.players) {
  //               if (player.teamShortName == teamLogos[0].teamShortName) {
  //                 team1Players.add(player);
  //               } else if (player.teamShortName == teamLogos[1].teamShortName) {
  //                 team2Players.add(player);
  //               }
  //             }
  //           }
  //         }
  //
  //         // Interleave players from both teams
  //         List<Player> interleavedPlayers = [];
  //         int maxLength = team1Players.length > team2Players.length
  //             ? team1Players.length
  //             : team2Players.length;
  //
  //         for (int i = 0; i < maxLength; i++) {
  //           if (i < team1Players.length) interleavedPlayers.add(team1Players[i]);
  //           if (i < team2Players.length) interleavedPlayers.add(team2Players[i]);
  //         }
  //
  //         return SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               SizedBox(
  //                 height: MediaQuery.of(context).size.height * 0.48, // 50% height
  //                 child: ListView.builder(
  //                   shrinkWrap: true,
  //                   itemCount: interleavedPlayers.length,
  //                   itemBuilder: (context, index) {
  //                     if (index >= isSelectedList.length) {
  //                       debugPrint('Index out of bounds: $index');
  //                       return Container();
  //                     }
  //                     final player = interleavedPlayers[index];
  //
  //                     // Check if the current player is from a team that reached the 7-player limit
  //                     final isTeamFull = (player.teamShortName == teamLogos[0].teamShortName && team1PlayerCount >= 7) ||
  //                         (player.teamShortName == teamLogos[1].teamShortName && team2PlayerCount >= 7);
  //
  //                     // Determine whether this player is selectable or not
  //                     final isSelectable = !isTeamFull || isSelectedList[index];
  //
  //                     final nameParts = player.playerName.split(' ');
  //                     final shortName = nameParts.length > 1
  //                         ? '${nameParts[0][0]} ${nameParts[1]}'
  //                         : player.playerName;
  //
  //                     return GestureDetector(
  //                       onTap: () {
  //                         if (!isSelectable) {
  //                           // Show a snackbar if the player cannot be selected
  //                           ScaffoldMessenger.of(context).showSnackBar(
  //                             const SnackBar(
  //                               content: Text('Maximum players allowed from 1 team.'),
  //                               duration: Duration(seconds: 2),
  //                             ),
  //                           );
  //                           return;
  //                         }
  //                         setState(() {
  //                           if (selectedCount < maxSelections || isSelectedList[index]) {
  //                             isSelectedList[index] = !isSelectedList[index];
  //                             if (isSelectedList[index]) {
  //                               selectedPlayers.add(player);
  //                               if (player.teamShortName == teamLogos[0].teamShortName) {
  //                                 team1PlayerCount++;
  //                               } else if (player.teamShortName == teamLogos[1].teamShortName) {
  //                                 team2PlayerCount++;
  //                               }
  //                             } else {
  //                               selectedPlayers.remove(player);
  //                               if (player.teamShortName == teamLogos[0].teamShortName) {
  //                                 team1PlayerCount--;
  //                               } else if (player.teamShortName == teamLogos[1].teamShortName) {
  //                                 team2PlayerCount--;
  //                               }
  //                             }
  //                             selectedCount = calculateSelectedCount();
  //                           }
  //                         });
  //                       },
  //                       child: Container(
  //                         margin: EdgeInsets.symmetric(
  //                           vertical: MediaQuery.of(context).size.height * 0.005,
  //                         ),
  //                         padding: EdgeInsets.symmetric(
  //                           horizontal: MediaQuery.of(context).size.width * 0.04,
  //                         ),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(8),
  //                           color: isSelectedList[index]
  //                               ? Colors.yellow.withOpacity(0.2)
  //                               : (isSelectable
  //                               ? Colors.transparent
  //                               : Colors.grey.withOpacity(0.5)),
  //                         ),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             // Player Image and Info
  //                             Row(
  //                               children: [
  //                                 SizedBox(
  //                                   height: 50,
  //                                   width: 50,
  //                                   child: Image.network(
  //                                     player.playerPhoto ?? "",
  //                                     fit: BoxFit.cover,
  //                                     errorBuilder: (context, error, stackTrace) {
  //                                       return Image.asset('assets/dummy_player.png');
  //                                     },
  //                                   ),
  //                                 ),
  //                                 SizedBox(width: 10),
  //                                 Column(
  //                                   crossAxisAlignment: CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                       shortName,
  //                                       style: const TextStyle(
  //                                         fontSize: 14,
  //                                         fontWeight: FontWeight.w600,
  //                                       ),
  //                                     ),
  //                                     const Text(
  //                                       "Sel by 73.34%",
  //                                       style: TextStyle(
  //                                         fontSize: 10,
  //                                         color: Colors.grey,
  //                                       ),
  //                                     ),
  //                                     const Text(
  //                                       "Played last match (Sub)",
  //                                       style: TextStyle(
  //                                         fontSize: 10,
  //                                         color: Colors.grey,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ],
  //                             ),
  //                             // Points and Credits
  //                             Row(
  //                               children: [
  //                                 // SizedBox(width: 1),
  //                                 Text(player.totalPoints.toString(),
  //                                     style: const TextStyle(fontSize: 12)),
  //                                 SizedBox(width: 60),
  //                                 Text(player.credit.toString(),
  //                                     style: const TextStyle(fontSize: 12)),
  //                                 SizedBox(width: 35),
  //                                 // Add/Remove Button
  //                                 Container(
  //                                   height: 25,
  //                                   width: 25,
  //                                   decoration: BoxDecoration(
  //                                     borderRadius: BorderRadius.circular(12.5),
  //                                     color: isSelectable
  //                                         ? (isSelectedList[index]
  //                                         ? Colors.transparent
  //                                         : Colors.green.withOpacity(0.2))
  //                                         : Colors.grey.withOpacity(0.5),
  //                                     border: Border.all(
  //                                       color: isSelectedList[index]
  //                                           ? Colors.green
  //                                           : Colors.transparent,
  //                                     ),
  //                                   ),
  //                                   child: Icon(
  //                                     isSelectedList[index]
  //                                         ? Icons.remove
  //                                         : Icons.add,
  //                                     size: 15,
  //                                     color: Colors.green,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //             ],
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

  // Widget buildTabContent(List<bool> isSelectedList, String role) {
  //   return FutureBuilder<PlayerModel?>(
  //     future: _futureData,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       } else if (snapshot.hasError) {
  //         return Center(child: Text('Error: ${snapshot.error}'));
  //       } else if (!snapshot.hasData) {
  //         return const Center(child: Text('No data available'));
  //       } else {
  //         final playerData = snapshot.data;
  //
  //         List<Player> team1Players = [];
  //         List<Player> team2Players = [];
  //
  //         // Separate players by team and role
  //         for (var classifiedPlayer in playerData!.data.first.classifiedPlayers) {
  //           if (classifiedPlayer.role == role) {
  //             for (var player in classifiedPlayer.players) {
  //               if (player.teamShortName == teamLogos[0].teamShortName) {
  //                 team1Players.add(player);
  //               } else if (player.teamShortName == teamLogos[1].teamShortName) {
  //                 team2Players.add(player);
  //               }
  //             }
  //           }
  //         }
  //
  //         // Interleave players from both teams
  //         List<Player> interleavedPlayers = [];
  //         int maxLength = team1Players.length > team2Players.length
  //             ? team1Players.length
  //             : team2Players.length;
  //
  //         for (int i = 0; i < maxLength; i++) {
  //           if (i < team1Players.length) interleavedPlayers.add(team1Players[i]);
  //           if (i < team2Players.length) interleavedPlayers.add(team2Players[i]);
  //         }
  //
  //         return SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               SafeArea(
  //                 child: SizedBox(
  //                   height: (MediaQuery.of(context).size.height * 0.48) + MediaQuery.of(context).padding.bottom,
  //       // height: MediaQuery.of(context).size.height * 0.48, // 50% height
  //
  //                   // height: 0.48.sh, // 48% of screen height
  //                   child: ListView.builder(
  //                     shrinkWrap: true,
  //                     itemCount: interleavedPlayers.length,
  //                     itemBuilder: (context, index) {
  //                       if (index >= isSelectedList.length) {
  //                         debugPrint('Index out of bounds: $index');
  //                         return Container();
  //                       }
  //                       final player = interleavedPlayers[index];
  //
  //                       final isTeamFull = (player.teamShortName == teamLogos[0].teamShortName && team1PlayerCount >= 7) ||
  //                           (player.teamShortName == teamLogos[1].teamShortName && team2PlayerCount >= 7);
  //
  //                       final isSelectable = !isTeamFull || isSelectedList[index];
  //
  //                       final nameParts = player.playerName.split(' ');
  //                       final shortName = nameParts.length > 1
  //                           ? '${nameParts[0][0]} ${nameParts[1]}'
  //                           : player.playerName;
  //
  //                       return GestureDetector(
  //                         onTap: () {
  //                           if (!isSelectable) {
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                               const SnackBar(
  //                                 content: Text('Maximum players allowed from 1 team.'),
  //                                 duration: Duration(seconds: 2),
  //                               ),
  //                             );
  //                             return;
  //                           }
  //                           setState(() {
  //                             if (selectedCount < maxSelections || isSelectedList[index]) {
  //                               isSelectedList[index] = !isSelectedList[index];
  //                               if (isSelectedList[index]) {
  //                                 selectedPlayers.add(player);
  //                                 if (player.teamShortName == teamLogos[0].teamShortName) {
  //                                   team1PlayerCount++;
  //                                 } else if (player.teamShortName == teamLogos[1].teamShortName) {
  //                                   team2PlayerCount++;
  //                                 }
  //                               } else {
  //                                 selectedPlayers.remove(player);
  //                                 if (player.teamShortName == teamLogos[0].teamShortName) {
  //                                   team1PlayerCount--;
  //                                 } else if (player.teamShortName == teamLogos[1].teamShortName) {
  //                                   team2PlayerCount--;
  //                                 }
  //                               }
  //                               selectedCount = calculateSelectedCount();
  //                             }
  //                           });
  //                         },
  //                         child: Container(
  //                           margin: EdgeInsets.symmetric(vertical: 5.h),
  //                           padding: EdgeInsets.symmetric(horizontal: 16.w),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(8.r),
  //                             color: isSelectedList[index]
  //                                 ? Colors.yellow.withOpacity(0.2)
  //                                 : (isSelectable
  //                                 ? Colors.transparent
  //                                 : Colors.grey.withOpacity(0.5)),
  //                           ),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Row(
  //                                 children: [
  //                                   SizedBox(
  //                                     height: 50.r,
  //                                     width: 50.r,
  //                                     child: Image.network(
  //                                       player.playerPhoto ?? "",
  //                                       fit: BoxFit.cover,
  //                                       errorBuilder: (context, error, stackTrace) {
  //                                         return Image.asset('assets/dummy_player.png');
  //                                       },
  //                                     ),
  //                                   ),
  //                                   SizedBox(width: 10.w),
  //                                   Column(
  //                                     crossAxisAlignment: CrossAxisAlignment.start,
  //                                     children: [
  //                                       Text(
  //                                         shortName,
  //                                         style: TextStyle(
  //                                           fontSize: 14.sp,
  //                                           fontWeight: FontWeight.w600,
  //                                         ),
  //                                       ),
  //                                       Text(
  //                                         "Sel by 73.34%",
  //                                         style: TextStyle(
  //                                           fontSize: 10.sp,
  //                                           color: Colors.grey,
  //                                         ),
  //                                       ),
  //                                       Text(
  //                                         "Played last match (Sub)",
  //                                         style: TextStyle(
  //                                           fontSize: 10.sp,
  //                                           color: Colors.grey,
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ],
  //                               ),
  //                               Row(
  //                                 children: [
  //                                   Text(
  //                                     player.totalPoints.toString(),
  //                                     style: TextStyle(fontSize: 12.sp),
  //                                   ),
  //                                   SizedBox(width: 30.w),
  //
  //                                   SizedBox(width: 20.w),
  //                                   Text(
  //                                     player.credit.toString(),
  //                                     style: TextStyle(fontSize: 12.sp),
  //                                   ),
  //                                   SizedBox(width: 20.w),
  //
  //                                   SizedBox(width: 20.w),
  //                                   Container(
  //                                     height: 25.r,
  //                                     width: 25.r,
  //                                     decoration: BoxDecoration(
  //                                       borderRadius: BorderRadius.circular(12.5.r),
  //                                       color: isSelectable
  //                                           ? (isSelectedList[index]
  //                                           ? Colors.transparent
  //                                           : Colors.green.withOpacity(0.2))
  //                                           : Colors.grey.withOpacity(0.5),
  //                                       border: Border.all(
  //                                         color: isSelectedList[index]
  //                                             ? Colors.green
  //                                             : Colors.transparent,
  //                                       ),
  //                                     ),
  //                                     child: Icon(
  //                                       isSelectedList[index] ? Icons.remove : Icons.add,
  //                                       size: 15.sp,
  //                                       color: Colors.green,
  //                                     ),
  //                                   ),
  //                                   // SizedBox(width: 10),
  //                                 ],
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(height: 20.h),
  //             ],
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

  int calculateSelectedCount() {
    wicketKeeperCount =
        isSelectedListWK.where((isSelected) => isSelected).length;
    batsmanCount = isSelectedListBAT.where((isSelected) => isSelected).length;
    allrounderCount = isSelectedListAR.where((isSelected) => isSelected).length;
    bowlerCount = isSelectedListBOWL.where((isSelected) => isSelected).length;
    return wicketKeeperCount + batsmanCount + allrounderCount + bowlerCount;
  }

  Widget buildNationalityCount(String nationality, PlayerModel? playerModel) {
    int selectedCount = selectedPlayers
        .where((player) => player.nationality == nationality.toLowerCase())
        .length;
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 13,
          child: Image.asset('assets/${nationality.toLowerCase()}.png'),
        ),
        const SizedBox(width: 8),
        Text(
          nationality,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 3),
        const Text(
          "-",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          "$selectedCount",
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

//best
// Widget buildTabContent(List<bool> isSelectedList, String role) {
//   return FutureBuilder<PlayerModel?>(
//     future: _futureData,
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Center(child: CircularProgressIndicator());
//       } else if (snapshot.hasError) {
//         return Center(child: Text('Error: ${snapshot.error}'));
//       } else if (!snapshot.hasData) {
//         return const Center(child: Text('No data available'));
//       } else {
//         final playerData = snapshot.data;
//         List<Player> filteredPlayers = [];
//         for (var classifiedPlayer in playerData!.data.first.classifiedPlayers) {
//           if (classifiedPlayer.role == role) {
//             filteredPlayers.addAll(classifiedPlayer.players);
//           }
//         }
//
//         // Use an Expanded widget to allow the ListView to take available height
//         return SingleChildScrollView(
//           child: Column(children: [
//             // Removed the SizedBox with fixed height
//             // Added an Expanded widget for the ListView.builder
//             SizedBox(
//               // height: MediaQuery.of(context).size.height * 0.44, // Responsive height
//               height: MediaQuery.of(context).size.height * 0.48, // Responsive height
//
//               // height: 400,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: filteredPlayers.length,
//                 itemBuilder: (context, index) {
//                   if (index >= isSelectedList.length) {
//                     debugPrint('Index out of bounds: $index');
//                     return Container();
//                   }
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         if (selectedCount < maxSelections || isSelectedList[index]) {
//                           isSelectedList[index] = !isSelectedList[index];
//                           if (isSelectedList[index]) {
//                             selectedPlayers.add(filteredPlayers[index]);
//                             if (filteredPlayers[index].teamShortName == teamLogos[0].teamShortName) {
//                               team1PlayerCount++;
//                             } else if (filteredPlayers[index].teamShortName == teamLogos[1].teamShortName) {
//                               team2PlayerCount++;
//                             }
//                           } else {
//                             selectedPlayers.remove(filteredPlayers[index]);
//                             if (filteredPlayers[index].teamShortName == teamLogos[0].teamShortName) {
//                               team1PlayerCount--;
//                             } else if (filteredPlayers[index].teamShortName == teamLogos[1].teamShortName) {
//                               team2PlayerCount--;
//                             }
//                           }
//                           selectedCount = calculateSelectedCount();
//                         }
//                       });
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.only(bottom: 5),
//                       height: 70,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: isSelectedList[index] ? Colors.yellow.withOpacity(0.2) : Colors.transparent,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               // height: MediaQuery.of(context).size.height * 2,
//                               height: 60.h,
//                               width: MediaQuery.of(context).size.width / 2,
//                               child: Row(
//                                 children: [
//                                   SizedBox(
//                                     height: 44,
//                                     width: 44,
//                                     child: Image.network(filteredPlayers[index].playerPhoto ?? ""),
//                                   ),
//                                   SizedBox(
//                                     height: 66,
//                                     width: MediaQuery.of(context).size.width * 0.3,
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           filteredPlayers[index].playerName ?? "",
//                                           softWrap: true,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                         const Text(
//                                           "Sel by 73.34%",
//                                           softWrap: true,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: TextStyle(
//                                             fontSize: 10,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                         const Text(
//                                           "Played last match (Sub)",
//                                           softWrap: true,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: TextStyle(
//                                             fontSize: 10,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(right: 15),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text(filteredPlayers[index].totalPoints.toString()),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 20,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text(filteredPlayers[index].credit.toString()),
//                               ],
//                             ),
//                             const SizedBox(
//                               width: 3,
//                             ),
//                             SizedBox(
//                               height: 60,
//                               width: 20,
//                               child: Center(
//                                 child: Container(
//                                   height: 21,
//                                   width: 21,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(11),
//                                     color: isSelectedList[index] ? Colors.transparent : Colors.green.withOpacity(0.2),
//                                     border: Border.all(
//                                       width: 1,
//                                       color: isSelectedList[index] ? Colors.green : Colors.transparent,
//                                     ),
//                                   ),
//                                   child: isSelectedList[index]
//                                       ? const Icon(
//                                     Icons.remove,
//                                     size: 15,
//                                     color: Colors.green,
//                                   )
//                                       : const Icon(
//                                     Icons.add,
//                                     size: 15,
//                                     color: Colors.green,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 20),
//           ]),
//
//         );
//       }
//     },
//   );
// }


// void onPlayerSelect(Player player, bool isSelected) {
//   setState(() {
//     if (isSelected) {
//       print("Selecting player: ${player.playerName}");
//       selectedPlayers.add(player);
//       if (player.teamShortName == teamLogos[0].teamShortName) {
//         team1PlayerCount++;
//         print("Team 1 count: $team1PlayerCount");
//       } else if (player.teamShortName == teamLogos[1].teamShortName) {
//         team2PlayerCount++;
//         print("Team 2 count: $team2PlayerCount");
//       }
//     } else {
//       print("Deselecting player: ${player.playerName}");
//       selectedPlayers.remove(player);
//       if (player.teamShortName == teamLogos[0].teamShortName) {
//         team1PlayerCount--;
//         print("Team 1 count: $team1PlayerCount");
//       } else if (player.teamShortName == teamLogos[1].teamShortName) {
//         team2PlayerCount--;
//         print("Team 2 count: $team2PlayerCount");
//       }
//     }
//     selectedCount = selectedPlayers.length;
//     print("Total selected: $selectedCount");
//   });
// }

// void onPlayerSelect(Player player, bool isSelected) {
//   setState(() {
//     if (isSelected) {
//       print("Selecting player: ${player.playerName}");
//       selectedPlayers.add(player);
//       String teamShortName = player.teamShortName;
//       selectedPlayersWithTeams.add(SelectedPlayer(player, teamShortName, player.role!)); // Pass the role here
//
//       if (teamShortName == teamLogos[0].teamShortName) {
//         team1PlayerCount++;
//       } else if (teamShortName == teamLogos[1].teamShortName) {
//         team2PlayerCount++;
//       }
//     } else {
//       print("Deselecting player: ${player.playerName}");
//       selectedPlayers.remove(player);
//       selectedPlayersWithTeams.removeWhere((selectedPlayer) => selectedPlayer.player == player);
//       String teamShortName = player.teamShortName;
//       if (teamShortName == teamLogos[0].teamShortName) {
//         team1PlayerCount--;
//       } else if (teamShortName == teamLogos[1].teamShortName) {
//         team2PlayerCount--;
//       }
//     }
//     selectedCount = selectedPlayers.length;
//     print("Total selected: $selectedCount");
//   });
// }

// void onPlayerSelect(Player player, bool isSelected) {
//   setState(() {
//     if (isSelected) {
//       print("Selecting player: ${player.playerName}");
//       selectedPlayers.add(player);
//       String teamShortName = player.teamShortName;
//       selectedPlayersWithTeams.add(SelectedPlayer(player, teamShortName)); // Add the selected player with team short name
//
//       if (teamShortName == teamLogos[0].teamShortName) {
//         team1PlayerCount++;
//       } else if (teamShortName == teamLogos[1].teamShortName) {
//         team2PlayerCount++;
//       }
//     } else {
//       print("Deselecting player: ${player.playerName}");
//       selectedPlayers.remove(player);
//       selectedPlayersWithTeams.removeWhere((selectedPlayer) => selectedPlayer.player == player); // Remove the player from the list
//       String teamShortName = player.teamShortName;
//       if (teamShortName == teamLogos[0].teamShortName) {
//         team1PlayerCount--;
//       } else if (teamShortName == teamLogos[1].teamShortName) {
//         team2PlayerCount--;
//       }
//     }
//     selectedCount = selectedPlayers.length;
//     print("Total selected: $selectedCount");
//   });
// }




// void initializeSelectionLists(PlayerModel data) {
//   // Clear previous selections
//   isSelectedListWK.clear();
//   isSelectedListBAT.clear();
//   isSelectedListAR.clear();
//   isSelectedListBOWL.clear();
//
//   // Initialize lists for each role
//   for (var classifiedPlayer in data.data.first.classifiedPlayers) {
//     List<bool> selectionList = List<bool>.filled(classifiedPlayer.players.length, false);
//
//     if (classifiedPlayer.role == 'Wicket Keeper') {
//       isSelectedListWK = selectionList;
//     } else if (classifiedPlayer.role == 'Batsman') {
//       isSelectedListBAT = selectionList;
//     } else if (classifiedPlayer.role == 'All Rounder') {
//       isSelectedListAR = selectionList;
//     } else if (classifiedPlayer.role == 'Bowler') {
//       isSelectedListBOWL = selectionList;
//     }
//
//     // Populate the selected players with their roles
//     for (var player in classifiedPlayer.players) {
//       selectedPlayersWithTeams.add(SelectedPlayer(player, player.teamShortName, classifiedPlayer.role));
//     }
//   }
// }






// Widget buildTabContent(List<bool> isSelectedList, String role) {
//   return FutureBuilder<PlayerModel?>(
//     future: _futureData,
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Center(child: CircularProgressIndicator());
//       } else if (snapshot.hasError) {
//         return Center(child: Text('Error: ${snapshot.error}'));
//       } else if (!snapshot.hasData) {
//         return const Center(child: Text('No data available'));
//       } else {
//         final playerData = snapshot.data;
//         List<Player> filteredPlayers = [];
//         for (var classifiedPlayer
//             in playerData!.data.first.classifiedPlayers) {
//           if (classifiedPlayer.role == role) {
//             filteredPlayers.addAll(classifiedPlayer.players);
//           }
//         }
//         return SingleChildScrollView(
//           child: Column(children: [
//             SizedBox(
//               // height: 460,
//               height: 300,
//               child: Align(
//                 alignment: Alignment.center,
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: filteredPlayers.length,
//                   itemBuilder: (context, index) {
//                     if (index >= isSelectedList.length) {
//                       debugPrint('Index out of bounds: $index');
//                       return Container();
//                     }
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           if (selectedCount < maxSelections ||
//                               isSelectedList[index]) {
//                             isSelectedList[index] = !isSelectedList[index];
//                             if (isSelectedList[index]) {
//                               selectedPlayers.add(filteredPlayers[index]);
//                               if (filteredPlayers[index].teamShortName ==
//                                   teamLogos[0].teamShortName) {
//                                 team1PlayerCount++;
//                               } else if (filteredPlayers[index]
//                                       .teamShortName ==
//                                   teamLogos[1].teamShortName) {
//                                 team2PlayerCount++;
//                               }
//                             } else {
//                               selectedPlayers.remove(filteredPlayers[index]);
//                               if (filteredPlayers[index].teamShortName ==
//                                   teamLogos[0].teamShortName) {
//                                 team1PlayerCount--;
//                               } else if (filteredPlayers[index]
//                                       .teamShortName ==
//                                   teamLogos[1].teamShortName) {
//                                 team2PlayerCount--;
//                               }
//                             }
//                             selectedCount = calculateSelectedCount();
//                           }
//                         });
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.only(bottom: 5),
//                         height: 70,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: isSelectedList[index]
//                               ? Colors.yellow.withOpacity(0.2)
//                               : Colors.transparent,
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                 height: 50.h,
//                                 width: MediaQuery.of(context).size.width / 2,
//                                 child: Row(
//                                   children: [
//                                     SizedBox(
//                                       height: 44,
//                                       width: 44,
//                                       child: Image.network(
//                                           filteredPlayers[index]
//                                                   .playerPhoto ??
//                                               ""),
//                                     ),
//                                     SizedBox(
//                                       height: 66,
//                                       width: MediaQuery.of(context).size.width *0.3,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             filteredPlayers[index]
//                                                     .playerName ??
//                                                 "",
//                                             softWrap: true,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: const TextStyle(
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                           const Text(
//                                             "Sel by 73.34%",
//                                             softWrap: true,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                               fontSize: 10,
//                                               color: Colors.grey,
//                                             ),
//                                           ),
//                                           const Text(
//                                             "Played last match (Sub)",
//                                             softWrap: true,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                               fontSize: 10,
//                                               color: Colors.grey,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 15),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.center,
//                                   children: [
//                                     Text(filteredPlayers[index]
//                                         .totalPoints
//                                         .toString()),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 20,
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text(filteredPlayers[index]
//                                       .credit
//                                       .toString()),
//                                 ],
//                               ),
//                               const SizedBox(
//                                 width: 3,
//                               ),
//                               SizedBox(
//                                 height: 60,
//                                 width: 20,
//                                 child: Center(
//                                   child: Container(
//                                     height: 21,
//                                     width: 21,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(11),
//                                       color: isSelectedList[index]
//                                           ? Colors.transparent
//                                           : Colors.green.withOpacity(0.2),
//                                       border: Border.all(
//                                         width: 1,
//                                         color: isSelectedList[index]
//                                             ? Colors.green
//                                             : Colors.transparent,
//                                       ),
//                                     ),
//                                     child: isSelectedList[index]
//                                         ? const Icon(
//                                             Icons.remove,
//                                             size: 15,
//                                             color: Colors.green,
//                                           )
//                                         : const Icon(
//                                             Icons.add,
//                                             size: 15,
//                                             color: Colors.green,
//                                           ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             // const SizedBox(
//             //   height: 500,
//             // )
//           ]),
//         );
//       }
//     },
//   );
// }