import 'package:batting_app/screens/Auth/login.dart';
import 'package:batting_app/widget/bigtext.dart';
import 'package:batting_app/widget/smalltext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBordindthree extends StatelessWidget {
  const OnBordindthree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF0F1F5),
        leading:InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(
              Icons.arrow_back
          ),
        ),
        actions: [
          Padding(
            padding:  const EdgeInsets.only(right: 30),
            child:InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
                },
                child: const Text("Skip",style:TextStyle(fontSize: 16,color:Color(0xff140B40) ),)),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color(0xffF0F1F5),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding:const EdgeInsets.only(left: 25,right: 15,top: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow:[
                    BoxShadow(
                        color: Colors.grey.shade400,
                        spreadRadius: 0,
                        blurRadius: 5.h
                    )
                  ],
                  borderRadius:const BorderRadius.only(topRight: Radius.circular(40),topLeft: Radius.circular(40))
              ),
              height: 380,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BigText(
                    color: Colors.black,
                    text: "Betting Sports Bets\nUsing the Samrtphone",),
                  const SizedBox(height: 10,),
                  SmallText(color: Colors.black45,
                      text: "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts."),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Opacity(
                            opacity: .3,
                            child: Container(
                              height: 3,
                              width: 12,
                              decoration: BoxDecoration(
                                  borderRadius:BorderRadius.circular(2),
                                  color:const Color(0xff140B40)
                              ),
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Opacity(
                            opacity: .3,
                            child: Container(
                              height: 3,
                              width: 12,
                              decoration: BoxDecoration(
                                  borderRadius:BorderRadius.circular(2),
                                  color:const Color(0xff140B40)
                              ),
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Container(
                            height: 3,
                            width: 30,
                            decoration: BoxDecoration(
                                borderRadius:BorderRadius.circular(8),
                                color:const Color(0xff140B40)
                            ),
                          ),


                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                              onTap:(){
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>const LoginScreen()));
                              },
                              child: Image.asset("assets/On Boarding 3 (1).png",height: 98,))
                        ],
                      )
                    ],
                  )
                ],

              ),

            ),
          )
        ],
      ),
    );
  }
}
