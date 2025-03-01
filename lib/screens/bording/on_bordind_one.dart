import 'package:flutter/material.dart';
import 'package:batting_app/widget/bigtext.dart';
import 'package:batting_app/widget/smalltext.dart';
import 'package:batting_app/screens/Auth/login.dart';

class NonScrollablePageView extends StatelessWidget {
  final PageController controller;
  final List<Widget> children;

  const NonScrollablePageView({
    super.key,
    required this.controller,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      physics: const NeverScrollableScrollPhysics(), // Disable swipe gestures
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF0F1F5),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: InkWell(
              onTap: _goToLogin,
              child: const Text(
                "Skip",
                style: TextStyle(fontSize: 16, color: Color(0xff140B40)),
              ),
            ),
          )
        ],
      ),
      body: NonScrollablePageView(

        controller: _pageController,
        children: [
          OnboardingPageOne(
            onNext: _goToNextPage,
          ),
          OnboardingPageTwo(
            onNext: _goToNextPage,
          ),
          OnboardingPageThree(
            onNext: _goToLogin,
          ),
        ],
      ),
    );
  }
}

class OnboardingPageOne extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingPageOne({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      title: "Welcome to Live\nSports Batting App",
      description:
      "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts.",
      indicatorIndex: 0,
      onNext: onNext,
    );
  }
}

class OnboardingPageTwo extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingPageTwo({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      title: "Most Favored App\nfor Betting Lovers",
      description:
      "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts.",
      indicatorIndex: 1,
      onNext: onNext,
    );
  }
}

class OnboardingPageThree extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingPageThree({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      title: "Join the Best\nBetting Community",
      description:
      "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts.",
      indicatorIndex: 2,
      onNext: onNext,
    );
  }
}

class OnboardingPageTemplate extends StatelessWidget {
  final String title;
  final String description;
  final int indicatorIndex;
  final VoidCallback onNext;

  const OnboardingPageTemplate({
    super.key,
    required this.title,
    required this.description,
    required this.indicatorIndex,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xffF0F1F5),
      child: Stack(
        children: [
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 40),
             child: Container(
               height: double.infinity,
               width: double.infinity,
               decoration: const BoxDecoration(
                   color: Color(0xffF0F1F5),
                   image: DecorationImage(image:  AssetImage('assets/onbrdingg.png'), opacity: double.infinity )
               ),

             ),
           ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              // padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              padding: const EdgeInsets.only(left: 25, right: 15, top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade400,
                      spreadRadius: 0,
                      blurRadius: 5)
                ],
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40)),
              ),
              height: 350,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BigText(
                    color: Colors.black,
                    text: title,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SmallText(
                    color: Colors.black45,
                    text: description,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onHorizontalDragUpdate: (_) {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: List.generate(
                            3,
                                (index) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Container(
                                height: 3,
                                width: indicatorIndex == index ? 30 : 12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      indicatorIndex == index ? 8 : 2),
                                  color: const Color(0xff140B40).withOpacity(
                                      indicatorIndex == index ? 1.0 : 0.3),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: onNext,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              border: Border.all(width: 1, color: const Color(0xff140B40)),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff140B40),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
