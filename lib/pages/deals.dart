import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:pricetracker/controllers/data_controller.dart';
import 'package:pricetracker/data/local_storage.dart';
import 'package:pricetracker/pages/login.dart';
import 'package:url_launcher/url_launcher.dart';

class DealsPage extends StatefulWidget {
  const DealsPage({super.key});

  @override
  State<DealsPage> createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {
  int selectedPage = 0;
  final PageController pageController = PageController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  DataController dataController = Get.put(DataController());

  bool showLoader = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showLoader = true;
      setState(() {});
      await dataController.fetchDealsAndOffers();
      showLoader = false;
      setState(() {});
    });
  }

  goToLogin() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Today's Top Deals",
              style: TextStyle(color: Colors.black),
            ),
            GestureDetector(
              onTap: () async {
                _googleSignIn.signOut();
                await localStoreSetEmail("");
                await localStoreSetUserId("");
                goToLogin();
              },
              child: Icon(
                Icons.logout,
                size: 24,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: pageController,
                      onPageChanged: (page) {
                        setState(() {
                          selectedPage = page;
                        });
                      },
                      itemCount: dataController.deals.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            if (!await launchUrl(
                                Uri.parse(dataController.deals[index].url))) {
                              debugPrint("Something went wrong");
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                dataController.deals[index].imgUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 10,
                      left: -10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PageViewDotIndicator(
                            currentItem: selectedPage,
                            count: 4,
                            size: const Size(8, 8),
                            unselectedSize: const Size(6, 6),
                            unselectedColor: Colors.black26,
                            selectedColor: Theme.of(context).primaryColor,
                            duration: const Duration(milliseconds: 200),
                            alignment: Alignment.center,
                            fadeEdges: true,
                            boxShape: BoxShape.circle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    itemCount: dataController.offers.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          Uri url = Uri.parse(dataController.offers[index].url);

                          if (!await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw Exception('Could not launch $url');
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(28, 0, 0, 0),
                                spreadRadius: 1,
                                blurRadius: 20,
                                offset: Offset(0, 0),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              Image.network(
                                dataController.offers[index].img_url,
                                height: 80,
                                width: 80,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dataController.offers[index].title,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            dataController.offers[index].price,
                                            style: const TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            dataController
                                                .offers[index].offer_price,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          "Buy on Amazon",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
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
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
