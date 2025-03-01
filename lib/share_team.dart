// import 'package:flutter/material.dart';
// import 'package:share/share.dart';
//
// class ShareTeamScreen extends StatelessWidget {
//   final String teamName;
//   final List<String> teamMembers;
//
//   const ShareTeamScreen({
//     Key? key,
//     required this.teamName,
//     required this.teamMembers,
//   }) : super(key: key);
//
//   void shareTeam() {
//     String membersText = teamMembers.join(', '); // Convert list to comma-separated string
//
//     Share.share(
//       'Check out our team $teamName! Team members: $membersText',
//       subject: 'Sharing Our Team', // Optional subject for emails
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Share Team'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             shareTeam();
//           },
//           child: Text('Share Team'),
//         ),
//       ),
//     );
//   }
// }
