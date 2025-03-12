import 'package:batting_app/services/restricted_states.dart';
import 'package:flutter/material.dart';

class GeoBlockingMessage extends StatelessWidget {
  const GeoBlockingMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.red.shade200,
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_off,
            color: Colors.red,
            size: 48.0,
          ),
          const SizedBox(height: 16.0),
          Text(
            RestrictedStates.restrictionMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}