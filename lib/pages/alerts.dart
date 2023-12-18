import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pricetracker/controllers/data_controller.dart';
import 'package:pricetracker/models/Alert.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  DataController dataController = Get.find();
  bool showLoader = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showLoader = true;
      setState(() {});
      await dataController.fetchAlerts();
      showLoader = false;
      setState(() {});
    });
  }

  deleteAlert(id) async {
    showLoader = true;
    setState(() {});
    await dataController.deleteAlert(id);
    showLoader = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () async {
              showLoader = true;
              setState(() {});
              await dataController.fetchAlerts();
              showLoader = false;
              setState(() {});
            },
            child: const Icon(
              Icons.refresh,
              size: 24,
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              "Alerts",
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: dataController.alerts.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("No alerts to show"),
                  )
                : ListView.builder(
                    itemCount: dataController.alerts.length,
                    padding: const EdgeInsets.only(top: 16),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          String productId = "";

                          if (dataController.alerts[index].url
                              .contains('/dp/')) {
                            debugPrint(
                                "${dataController.alerts[index].url.split('/dp/')[1].split('/').first} - 1");
                            productId = dataController.alerts[index].url
                                .split('/dp/')[1]
                                .split('/')
                                .first;
                          } else if (dataController.alerts[index].url
                              .contains('/gp/product/')) {
                            debugPrint(
                                "${dataController.alerts[index].url.split('/gp/product/')[1].split('/').first} - 2");
                            productId = dataController.alerts[index].url
                                .split('/gp/product/')[1]
                                .split('/')
                                .first;
                          } else if (dataController.alerts[index].url
                              .contains('/gp/aw/d/')) {
                            debugPrint(
                                "${dataController.alerts[index].url.split('/gp/aw/d/')[1].split('/').first} - 3");
                            productId = dataController.alerts[index].url
                                .split('/gp/aw/d/')[1]
                                .split('/')
                                .first;
                          }

                          Uri url;

                          if (productId.isNotEmpty) {
                            url = Uri.parse(
                                "https://www.amazon.in/dp/$productId?tag=affluencer0d-21");
                          } else {
                            url = Uri.parse(
                                "${dataController.alerts[index].url}&tag=affluencer0d-21");
                          }

                          if (!await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw Exception('Could not launch $url');
                          }
                        },
                        child: AlertCard(
                          alert: dataController.alerts[index],
                          deleteAlert: deleteAlert,
                        ),
                      );
                    },
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

class AlertCard extends StatelessWidget {
  const AlertCard({
    super.key,
    required this.alert,
    required this.deleteAlert,
  });

  final Alert alert;
  final Function deleteAlert;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
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
          SizedBox(
            height: 120,
            width: 120,
            child: alert.imgUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      alert.imgUrl,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    Icons.image,
                    size: 70,
                    color: Color.fromARGB(255, 137, 194, 148),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  alert.title.isNotEmpty
                      ? Text(
                          alert.title.trim(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 8,
                  ),
                  alert.current_price.isNotEmpty
                      ? Text("Current Price : Rs. ${alert.current_price}")
                      : const SizedBox(),
                  const SizedBox(
                    height: 4,
                  ),
                  Text("Alert Price : Rs. ${alert.alert_price}"),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
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
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await deleteAlert(alert.id);
                        },
                        child: Icon(
                          Icons.delete,
                          size: 24,
                          color: Color(0xFFEA8F89),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
