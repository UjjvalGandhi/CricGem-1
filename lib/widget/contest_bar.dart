import 'package:batting_app/screens/contest_bycode.dart';
import 'package:batting_app/screens/create_contest.dart';
import 'package:flutter/material.dart';

class ContestCategory {
  final String name;
  final IconData icon;

  ContestCategory({required this.name, required this.icon});
}

void showCustomPositionedDialog(BuildContext context) {
  List<ContestCategory> categories = [
    ContestCategory(name: 'Create Contest', icon: Icons.add_circle_outline),
    ContestCategory(name: 'Enter Contest Code', icon: Icons.input),
  ];

  showDialog(
    barrierColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return Stack(
        children: <Widget>[
          Positioned(
            left: 20,
            right: 120,
            bottom: 80,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: ModalRoute.of(context)!.animation!,
                curve: Curves.easeOut,
              )),
              child: Card(
                color: Colors.white,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: categories.map((category) => ListTile(
                      leading: Icon(category.icon),
                      title: Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.pop(context);
                        if (category.name == 'Enter Contest Code') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ContestByCode(),
                            ),
                          );
                        } else if (category.name == 'Create Contest') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateContest(),
                            ),
                          );
                        }
                      },
                    )).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
