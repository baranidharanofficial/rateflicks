import 'package:flutter/material.dart';
import 'package:pricetracker/pages/login.dart';

class SliderScreen extends StatefulWidget {
  const SliderScreen({super.key});

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  int _pageIndex = 0;
  final _pageController = PageController(initialPage: 0);

  void _goToNextPage() {
    _pageController.animateToPage(
      _pageController.page!.toInt() + 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPreviousPage() {
    _pageController.animateToPage(
      _pageController.page!.toInt() - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: _pageController,
          onPageChanged: (value) {
            _pageIndex = value;
            setState(() {});
            print(value);
          },
          scrollDirection: Axis.horizontal,
          children: [
            Slide(
              width: width,
              imgUrl: 'assets/images/1.png',
              title: 'Find awesome deals on popular products',
              color: Colors.white,
            ),
            Slide(
              width: width,
              imgUrl: 'assets/images/2.png',
              title: 'Create alert for your favourite products',
              color: Colors.white,
            ),
            Slide(
              width: width,
              imgUrl: 'assets/images/3.png',
              title: 'Buy your favourite products at low price',
              color: Colors.white,
            )
          ],
        ),
        Positioned(
          bottom: 0,
          child: SizedBox(
            height: height * 0.15,
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.3,
                  child: Visibility(
                    visible: _pageIndex > 0,
                    child: GestureDetector(
                      onTap: _goToPreviousPage,
                      child: const Text(
                        "Previous",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SliderDot(expanded: _pageIndex == 0),
                      const SizedBox(
                        width: 5,
                      ),
                      SliderDot(expanded: _pageIndex == 1),
                      const SizedBox(
                        width: 5,
                      ),
                      SliderDot(expanded: _pageIndex == 2),
                    ],
                  ),
                ),
                Visibility(
                  visible: _pageIndex < 2,
                  child: SizedBox(
                    width: width * 0.3,
                    child: GestureDetector(
                      onTap: _goToNextPage,
                      child: const Text(
                        "Next",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _pageIndex == 2,
                  child: SizedBox(
                    width: width * 0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              "Done",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}

class Slide extends StatelessWidget {
  const Slide({
    super.key,
    required this.width,
    required this.title,
    required this.imgUrl,
    required this.color,
  });

  final double width;
  final String title;
  final String imgUrl;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(imgUrl),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
          ),
          SizedBox(
            width: width * 0.8,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SliderDot extends StatelessWidget {
  const SliderDot({
    super.key,
    required bool expanded,
  }) : _expanded = expanded;

  final bool _expanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 10,
      width: _expanded ? 30 : 10,
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color:
            _expanded ? Theme.of(context).primaryColor : Colors.blueGrey[800],
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
