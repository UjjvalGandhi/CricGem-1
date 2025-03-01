import 'package:flutter/material.dart';

class BalanceNotifier extends ValueNotifier<String> {
  BalanceNotifier(super.initialBalance);

  void updateBalance(String newBalance) {
    value = newBalance;
    notifyListeners(); // Notify all listeners of the change
  }

  String get balance => value;
}
// import 'package:flutter/material.dart';
//
// class BalanceNotifier extends ValueNotifier<String> {
//   BalanceNotifier(String initialBalance) : super(initialBalance);
//
//   void updateBalance(String newBalance) {
//     value = newBalance;
//     notifyListeners();
//   }
//   String get balance => value;
//
// }
