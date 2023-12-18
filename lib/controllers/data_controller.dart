import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pricetracker/data/api_data.dart';
import 'package:pricetracker/models/Alert.dart';
import 'package:pricetracker/models/Offer.dart';
import 'package:pricetracker/models/TopDeal.dart';

class DataController extends GetxController {
  DataApi dataApi = DataApi();

  List<TopDeal> _deals = [];
  List<Offer> _offers = [];
  List<Alert> _alerts = [];

  List<TopDeal> get deals => _deals;
  List<Offer> get offers => _offers;
  List<Alert> get alerts => _alerts;

  fetchDealsAndOffers() async {
    debugPrint("TEST ---- ${_deals.length}");
    if (deals.length == 0) {
      _deals = await dataApi.getTopDeals();
      update();
    }
    if (offers.length == 0) {
      _offers = await dataApi.getOffers();
      update();
    }
  }

  fetchAlerts() async {
    if (alerts.length == 0) {
      _alerts = await dataApi.getAlerts();
      update();
    }
  }

  deleteAlert(id) async {
    await dataApi.deleteAlert(id);
    _alerts = await dataApi.getAlerts();
    update();
  }
}
