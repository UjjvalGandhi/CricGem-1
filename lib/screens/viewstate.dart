import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/ViewStatsModel.dart';
import '../widget/appbar_for_setting.dart';

class ViewState extends StatefulWidget {
  final String? Id;
  final String? matchId;
  const ViewState({super.key, this.Id, this.matchId});

  @override
  State<ViewState> createState() => _ViewStateState();
}

class _ViewStateState extends State<ViewState> {
  ViewStatsModel? _viewStatsModel;
  bool _isLoading = true;
  bool _hasData = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse(
        'https://batting-api-1.onrender.com/api/playerpoints/playerPoint?matchId=${widget.matchId}'));
    print('idmatch${widget.matchId}');

    if (response.statusCode == 200) {
      final data = viewStatsModelFromJson(response.body);
      setState(() {
        _viewStatsModel = data;
        _isLoading = false;
        _hasData = data.data != null && data.data!.isNotEmpty;
      });
    } else {
      setState(() {
        _isLoading = false;
        _hasData = false;
      });
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to HomeScreens when back button is pressed
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const MyHomePage(),
        //   ),
        // );
        Navigator.pop(context);
        return false; // Prevent the default back navigation
      },
      child: Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(60.0),
        //   child: ClipRRect(
        //     child: AppBar(
        //       leading: Container(),
        //       surfaceTintColor: const Color(0xffF0F1F5),
        //       backgroundColor: const Color(0xffF0F1F5),
        //       elevation: 0,
        //       centerTitle: true,
        //       flexibleSpace: Container(
        //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        //         height: 100,
        //         width: MediaQuery.of(context).size.width,
        //         decoration: const BoxDecoration(
        //             gradient: LinearGradient(
        //                 begin: Alignment.topCenter,
        //                 end: Alignment.bottomCenter,
        //                 colors: [
        //                   Color(0xff1D1459), Color(0xff140B40)
        //                 ])
        //         ),
        //         child: Column(
        //           children: [
        //             const SizedBox(height: 50),
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 InkWell(
        //                   onTap: () {
        //                     Navigator.pop(context);
        //                   },
        //                   child: const Icon(
        //                     Icons.arrow_back, color: Colors.white,
        //                   ),
        //                 ),
        //                 AppBarText(color: Colors.white, text: "View Stats"),
        //                 Container(width: 20,)
        //               ],
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(67.h),
        //   child: ClipRRect(
        //     child: AppBar(
        //       surfaceTintColor: const Color(0xffF0F1F5),
        //       backgroundColor: const Color(0xffF0F1F5),
        //       elevation: 0,
        //       centerTitle: true,
        //       automaticallyImplyLeading: false,
        //       flexibleSpace: Container(
        //         padding: EdgeInsets.symmetric(horizontal: 20.w),
        //         decoration: const BoxDecoration(
        //           gradient: LinearGradient(
        //             begin: Alignment.topCenter,
        //             end: Alignment.bottomCenter,
        //             colors: [Color(0xff1D1459), Color(0xff140B40)],
        //           ),
        //         ),
        //         child: Padding(
        //           padding: EdgeInsets.only(top: 30.h),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               InkWell(
        //                 onTap: () {
        //                   Navigator.pop(context);
        //                 },
        //                 child: const Icon(
        //                   Icons.arrow_back,
        //                   color: Colors.white,
        //                 ),
        //               ),
        //               AppBarText(color: Colors.white, text: "View Stats"),
        //               Container(
        //                 width: 30,
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        appBar: CustomAppBar(
          title: "View Stats",
          onBackButtonPressed: () {
            // Custom behavior for back button (if needed)
            Navigator.pop(context);
          },
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : !_hasData
                ? const Center(child: Text('No data available'))
                : ListView.builder(
                    itemCount: _viewStatsModel!.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final player = _viewStatsModel!.data![index];
                      return ListTile(
                        // leading: Image.network(player.playerPhoto!),
                        leading: Image.network(
                          player.playerPhoto!,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/dummy_player.png',
                              fit: BoxFit.cover, // Adjust as needed
                            );
                          },
                          fit: BoxFit
                              .cover, // Optional: adjusts how the image is displayed
                        ),
                        title: Text(player.playerName!),
                        subtitle: Text(
                            '${player.playerRole!} - ${player.teamShortName!}'),
                        trailing: Text('Points: ${player.totalPoints}'),
                      );
                    },
                  ),
      ),
    );
  }
}
