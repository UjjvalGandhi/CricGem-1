import 'package:batting_app/widget/normal3.dart';
import 'package:batting_app/widget/small2.0.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget/appbartext.dart';
import '../widget/normal_400.dart';

class RewordDetails extends StatefulWidget {
  const RewordDetails({super.key});

  @override
  State<RewordDetails> createState() => _RewordDetailsState();
}

class _RewordDetailsState extends State<RewordDetails> {
  int number = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      AppBarText(color: Colors.white, text: "Rewards"),
                      Container(width: 20,)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children:[
          Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color(0xffF0F1F5),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    decoration:const BoxDecoration(
                        image:  DecorationImage(
                            image: AssetImage('assets/Reward.png'),
                            fit: BoxFit.cover)
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                    height: 32,
                    width: 65,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xff140B40)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/noto_coin.png',height: 22,),
                        const SizedBox(width: 3,),
                        const Text("20",style: TextStyle(fontSize: 18,color: Colors.white),)
                      ],
                    ),
                  ),),
                ],
              ),
              const SizedBox(height: 20,),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                height: 500,
                child: ListView.builder(
                  itemCount: 1,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            margin:const EdgeInsets.only(bottom: 20),
                            padding:const EdgeInsets.all(15),
                            height: 390,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5,),
                                const Text("DC vs MI - Watch Live in Delhi", style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),),
                                const SizedBox(height: 8,),
                                Normal400(color: Colors.black, text: "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for"),
                                const SizedBox(height: 15,),
                                Divider(
                                  height: 1,
                                  color:Colors.grey.shade300 ,
                                ),
                                const SizedBox(height: 12,),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Small2Text(color: Colors.grey, text: "Valid Until"),
                                    Normal400(color: Colors.grey, text: "22 Apr, 2024"),
                                  ],
                                ),
                                const SizedBox(height: 8,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Small2Text(color: Colors.grey, text: "Winner Declaration"),
                                    Normal400(color: Colors.grey, text: "2 PM, 24 Apr, 2024"),
                                  ],
                                ),
                              ],
                            ),

                          ),
                          Container(
                            height: 399,
                            width: MediaQuery.of(context).size.width,
                            padding:const EdgeInsets.all(15) ,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,

                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("How to redeem", style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),),
                                const SizedBox(height: 8,),
                                Normal400(color: Colors.black, text: "1. Lorem ipsum is placeholder text commonly "),
                                Normal400(color: Colors.black, text: "1. Lorem ipsum is placeholder text commonly "),
                                Normal400(color: Colors.black, text: "1. Lorem ipsum is placeholder text commonly "),
                                Normal400(color: Colors.black, text: "1. Lorem ipsum is placeholder text commonly "),
                                Normal400(color: Colors.black, text: "1. Lorem ipsum is placeholder text commonly "),
                                Normal400(color: Colors.black, text: "1. Lorem ipsum is placeholder text commonly "),
                              ],
                            ),
                          ),
                          const SizedBox(height: 190,),
                        ],
                      );
                    },),
              )
            ],
          ),
        ),
          Positioned(
            bottom: 0,
              child: Container(
            height: 182,
            width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
             color: Colors.white,
             boxShadow: [
               BoxShadow(
                 color:Colors.black.withOpacity(0.1),
                 blurRadius: 8,
                 spreadRadius: 0.1,

               )
             ]
           ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 90,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 85,
                            width: 60,
                            child: Column(
                              children: [
                                Normal3Text(color: Colors.black, text: "Balance",),
                                Container(
                                  height: 34,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: const Color(0xff140B40)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/noto_coin.png',height: 20,),
                                      const SizedBox(width: 2,),
                                      const Text("30",style: TextStyle(fontSize: 17,color: Colors.white),)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 80,
                            width: 90,
                            color: Colors.white,
                            child: Column(
                               children: [
                                Normal3Text(color: Colors.black, text: "Raffle Tickets"),
                               Stack(
                                 children:[
                                   Container(
                                   padding: const EdgeInsets.symmetric(horizontal: 8),
                                   height: 30,
                                   width: 89,
                                   decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(8),
                                     color: const Color(0xff140B40)

                                   ),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       GestureDetector(
                                           onTap:(){
                                             setState(() {
                                               if(number == 1){
                                               }
                                               else
                                               {
                                                 number--;
                                               }
                                             });
                                           } ,
                                           child: const Icon(Icons.remove,color: Colors.white,size: 16,)),
                                       GestureDetector(
                                           onTap:
                                               () {
                                             setState(
                                                     () {
                                                   number++;
                                                 });
                                           },
                                           child: const Icon(Icons.add,color: Colors.white,size: 16,)),
                                     ],
                                   ),
                                 ),
                                   Positioned(
                                     top: 1,
                                       bottom: 1,
                                       left: 30,
                                       right: 30,
                                       child:
                                   Container(height: 29,
                                   width: 29,
                                     color: Colors.white,
                                     child: Center(child: Text( number
                                         .toString(),style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),)),

                                   ))
                                ]
                               )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(height: 1,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey,),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child:    InkWell(
                        onTap: (){

                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Container(
                              height: 48,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color:const Color(0xff140B40)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Get for ",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w500),),
                                  Image.asset('assets/noto_coin.png',height: 20,),
                                  const SizedBox(width: 5,),
                                  const Text("30",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w500),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
          )
          )
       ]
      ),
    );
  }
}
