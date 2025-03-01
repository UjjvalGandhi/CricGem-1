import 'package:batting_app/widget/normaltext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/appbartext.dart';
import '../widget/smalltext.dart';

class ManageProduct extends StatefulWidget {
  const ManageProduct({super.key});

  @override
  State<ManageProduct> createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(95.0.h),
        child: ClipRRect(
          child: AppBar(
            leading: Container(),
            surfaceTintColor:const Color(0xffF0F1F5) ,
            backgroundColor:const Color(0xffF0F1F5) , // Custom background color
            elevation: 0, // Remove shadow
            centerTitle: true,
            flexibleSpace: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff1D1459),Color(0xff140B40)
                      ])
              ),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back,color: Colors.white,)),
                      AppBarText(color: Colors.white, text: "Manage Payments"),
                      Container(width: 20,)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color(0xffF0F1F5),
        padding: const EdgeInsets.symmetric(horizontal: 15),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            SmallText(color: Colors.grey, text: "Wallets"),
            const SizedBox(height: 3,),
            Container(
              padding: const EdgeInsets.all(10),
              height: 195,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/pay.png',height: 40,),
                            const SizedBox(width: 15,),
                            NormalText(color: Colors.black, text: "Amazon Pay")
                          ],
                        ),
                        Row(
                          children: [
                            const Text( "Link Account", style: TextStyle(
                              color: Color(0xff0000FF),
                              fontSize: 13,
                            ),),
                            const SizedBox(width: 5,),
                            Image.asset('assets/arrowup.png',height: 9,),
                          ],
                        )

                      ],
                    ),
                  ),
                  const SizedBox(height: 18,),
                  SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/ppay.png',height: 40,),
                            const SizedBox(width: 15,),
                            NormalText(color: Colors.black, text: "Phone Pay")
                          ],
                        ),
                        Row(
                          children: [
                            const Text( "Link Account", style: TextStyle(
                              color: Color(0xff0000FF),
                              fontSize: 13,
                            ),),
                            const SizedBox(width: 5,),
                            Image.asset('assets/arrowup.png',height: 9,),
                          ],
                        )

                      ],
                    ),
                  ),
                  const SizedBox(height: 18,),
                  SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/gpay.png',height: 40,),
                            const SizedBox(width: 15,),
                            NormalText(color: Colors.black, text: "Google Pay")
                          ],
                        ),
                        Row(
                          children: [
                            const Text( "Link Account", style: TextStyle(
                              color: Color(0xff0000FF),
                              fontSize: 13,
                            ),),
                            const SizedBox(width: 5,),
                            Image.asset('assets/arrowup.png',height: 9,),
                          ],
                        )

                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            SmallText(color: Colors.grey, text: "Add Debit Card or Credit Card"),
            const SizedBox(height: 3,),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              padding:const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white
              ),
              child: const Text("Add a card for convenient payments from payment options", style: TextStyle(
                color: Colors.black,
                fontSize: 10,),
                            )
            )
          ],
        ),
      ),
    );
  }
}
