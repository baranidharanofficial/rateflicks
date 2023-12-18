import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

import 'package:pricetracker/data/local_storage.dart';
import 'package:pricetracker/pages/login.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  Detail? detail;
  bool showLoader = false;
  String errorText = "";
  bool showError = false;
  TextEditingController urlController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  Future<void> fetchWebsiteContent(productUrl) async {
    showLoader = true;
    setState(() {});

    final Map<String, String> data = {
      'url': productUrl.trim(),
    };

    debugPrint(productUrl.trim());

    final postData = await jsonEncode(data);

    debugPrint(postData);

    try {
      final response = await http.post(
        Uri.parse("http://65.2.75.93:3000/details"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: postData,
      );

      debugPrint(response.body + "Test");

      if (response.statusCode == 200) {
        dynamic jsonData = json.decode(response.body);
        debugPrint(jsonData['title']);
        debugPrint(jsonData['price']);
        debugPrint(jsonData['imgUrl']);
        detail = Detail.fromJson(jsonData);
        showSnackbar(context, "Product Details Fetched");

        showLoader = false;
        setState(() {});
        debugPrint(response.body);
      } else {
        showLoader = false;
        setState(() {});
        dynamic jsonData = json.decode(response.body);
        debugPrint("Error ${jsonData['message']}");
        showSnackbar(context, "${jsonData['message']}");
      }
    } catch (err) {
      showLoader = false;
      setState(() {});
      debugPrint(" Error : $err ");
      showSnackbar(context, "Error ${err}");
    }
  }

  Future<void> _requestNotificationPermission() async {
    final PermissionStatus status = await Permission.notification.request();
    print("Notification permission status: $status");
  }

  Future<void> createAlert() async {
    showLoader = true;
    setState(() {});

    if (showError) {
      showLoader = false;
      setState(() {});
      showSnackbar(context, errorText);
      return;
    }

    if (await Permission.notification.isGranted) {
      String productUrl = urlController.text;
      String price = priceController.text;
      String? email = await localStoreGetEmail();

      debugPrint(productUrl);
      print(price);

      final url = Uri.parse('http://65.2.75.93:3000/alerts');

      Map<String, dynamic> data = {
        "email": email,
        "url": productUrl,
        "price": price
      };

      String jsonData = jsonEncode(data);
      debugPrint(jsonData);

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type':
                'application/json', // Set the content-type header to indicate JSON data
          },
          body: jsonData,
        );
        if (response.statusCode == 201) {
          final responseData = response.body;
          urlController.clear();
          priceController.clear();
          detail = null;
          debugPrint(responseData);
        } else {
          debugPrint('Error: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Error: $e');
      }

      showLoader = false;
      setState(() {});
    } else {
      await _requestNotificationPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              "Create Alert",
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Visibility(
                  visible: detail != null,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1C000000),
                          spreadRadius: 1,
                          blurRadius: 15,
                          offset: Offset(0, 0),
                        )
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        detail != null && detail!.imgUrl.isNotEmpty
                            ? Image.network(
                                detail!.imgUrl,
                                width: MediaQuery.of(context).size.width * 0.35,
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 16,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                detail != null && detail!.title.isNotEmpty
                                    ? Text(
                                        detail!.title.replaceAll('&amp;', '&'),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  height: 10,
                                ),
                                detail != null && detail!.price.isNotEmpty
                                    ? Text(
                                        "Rs." + detail!.price,
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Amazon Product URL (Full Link)",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Copy product link from browser (App link will not work)",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7F6EA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: urlController,
                      onChanged: (value) async {
                        if (value.isNotEmpty && value.contains("https://")) {
                          print(value);

                          await fetchWebsiteContent(value);
                        }
                      },
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      cursorColor: const Color(0xFF26A842),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Alert Price",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7F6EA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      cursorColor: const Color(0xFF26A842),
                      onChanged: (value) {
                        print(double.parse(priceController.text) <
                            double.parse(detail!.price.split(',').join()) / 2);

                        if (double.parse(priceController.text) <
                            double.parse(detail!.price.split(',').join()) / 2) {
                          errorText =
                              "Alert Price should be more than half the price of the product.";
                          showError = true;
                        } else if (double.parse(priceController.text) >
                            double.parse(detail!.price.split(',').join())) {
                          errorText =
                              "Alert Price should not exceed the price of the product.";
                          showError = true;
                        } else {
                          errorText = "";
                          showError = false;
                        }
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: Text(
                    errorText,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () async {
                    await createAlert();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF26A842),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Create Alert",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: showLoader,
          child: Positioned.fill(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xA6212121),
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class Detail {
  final String imgUrl;
  final String price;
  final String title;

  Detail({
    required this.imgUrl,
    required this.price,
    required this.title,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      imgUrl: json['imgUrl'],
      price: json['price'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imgUrl': imgUrl,
      'price': price,
      'title': title,
    };
  }
}



  // parseWebsiteContent(String htmlString) {
  //   dom.Document document = parser.parse(htmlString);

  //   title = document.getElementById('productTitle') != null
  //       ? document.getElementById('productTitle')!.innerHtml
  //       : "";

  //   if (document.getElementById("apex_desktop") != null) {
  //     dom.Document priceElement =
  //         parser.parse(document.getElementById("apex_desktop")!.innerHtml);
  //     price =
  //         priceElement.getElementsByClassName('a-offscreen').first.innerHtml;
  //   }

  //   if (document.getElementById('main-image') != null) {
  //     imgUrl = document.getElementById('main-image')!.attributes['src']!;
  //   } else if (document.getElementById('landingImage') != null) {
  //     imgUrl = document.getElementById('landingImage')!.attributes['src']!;
  //   }

  //   setState(() {});
  // }