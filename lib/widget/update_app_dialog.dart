import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class UpdateDialog extends StatelessWidget {
  final bool isForceUpdate;
  final VoidCallback onUpdate;
  final VoidCallback? onLater;

  const UpdateDialog({
    Key? key,
    required this.isForceUpdate,
    required this.onUpdate,
    this.onLater,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !isForceUpdate,
      child: AlertDialog(
        title: const Text('Update Available'),
        content: const Text(
          'A new version of CricGem is available! Would you like to update now?',
        ),
        actions: [
          if (!isForceUpdate)
            TextButton(
              onPressed: () {
                onLater?.call();
                Navigator.of(context).pop();
              },
              child: const Text('Later'),
            ),
          TextButton(
            onPressed: () {
              onUpdate();
              if (!isForceUpdate) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Update Now'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        elevation: 24,
      ),
    );
  }

  static void show({
    required BuildContext context,
    required bool isForceUpdate,
    required VoidCallback onUpdate,
    VoidCallback? onLater,
  }) {
    showDialog(
      context: context,
      barrierDismissible: !isForceUpdate,
      builder: (context) => UpdateDialog(
        isForceUpdate: isForceUpdate,
        onUpdate: onUpdate,
        onLater: onLater,
      ),
    );
  }
}
