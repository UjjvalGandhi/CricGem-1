import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackButtonPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize:  Size.fromHeight(67.h),
      child: ClipRRect(
        child: AppBar(
          surfaceTintColor: const Color(0xffF0F1F5),
          backgroundColor: const Color(0xffF0F1F5),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            padding:  EdgeInsets.symmetric(horizontal: 20.w),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff140B40), Color(0xff140B40)],
              ),
            ),
            child: Padding(
              padding:  EdgeInsets.only(top: 30.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: onBackButtonPressed ??
                            () {
                          Navigator.pop(context);
                        },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style:  TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                   SizedBox(width: 30.w), // Placeholder for alignment
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(67);
}
