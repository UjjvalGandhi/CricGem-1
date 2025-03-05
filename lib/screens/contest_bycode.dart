import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContestByCode extends StatefulWidget {
  const ContestByCode({Key? key}) : super(key: key);

  @override
  State<ContestByCode> createState() => _ContestByCodeState();
}

class _ContestByCodeState extends State<ContestByCode> {
  final TextEditingController _codeController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _codeController.removeListener(_updateButtonState);
    _codeController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _codeController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C133A),
        title: const Text(
          'Enter Contest Code',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // White back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _codeController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Contest Code',
                labelStyle: const TextStyle(color: Colors.grey),
                hintText: 'Invite code',
                hintStyle: const TextStyle(color: Colors.grey),
                fillColor: const Color(0xFFD9D9D9),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                prefixIcon: const Icon(
                  Icons.code,
                  color: Colors.grey,
                ),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  // TODO: Implement contest code submission
                  print('Contest code submitted: $value');
                }
              },
            ),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: _isButtonEnabled ? () {
                final code = _codeController.text.trim();
                // TODO: Implement contest code submission
                print('Contest code submitted: $code');
              } : null,
              child: Container(
                height: 50.h,
                width: 30.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.r),
                  color: _isButtonEnabled ? const Color(0xff140B40) : Colors.grey,
                ),
                child: const Center(
                  child: Text(
                    "Join Contest",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}