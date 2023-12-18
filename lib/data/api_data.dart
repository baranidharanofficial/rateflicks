import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pricetracker/data/local_storage.dart';
import 'package:pricetracker/models/Alert.dart';
import 'package:pricetracker/models/Offer.dart';
import 'package:pricetracker/models/TopDeal.dart';

class DataApi {
  Future<bool> loginUser(email, password, fcmToken) async {
    final url = Uri.parse('http://65.2.75.93:3000/login');

    final Map<String, String> data = {
      'email': email,
      'password': password,
      'fcm_token': fcmToken
    };

    debugPrint(email);
    debugPrint(password);
    debugPrint(fcmToken);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final responseData = response.body;
        debugPrint(responseData);
        dynamic jsonData = json.decode(response.body);
        await localStoreSetUserId(jsonData['id']);
        debugPrint(jsonData['id']);
        return true;
      } else {
        debugPrint('Error: ${response.statusCode}');
        return false;
      }
    } catch (err) {
      debugPrint('Error: $err');
      return false;
    }
  }

  Future<bool> registerUser(email, password, fcmToken) async {
    final url = Uri.parse('http://65.2.75.93:3000/register');

    final Map<String, String> data = {
      'email': email,
      'password': password,
      'fcm_token': fcmToken
    };

    debugPrint(email);
    debugPrint(password);
    debugPrint(fcmToken);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        final responseData = response.body;
        debugPrint(responseData);
        dynamic jsonData = json.decode(responseData);
        await localStoreSetUserId(jsonData['id']);
        return true;
      } else {
        debugPrint('Error: ${response.statusCode}');
        return false;
      }
    } catch (err) {
      debugPrint('Error: $err');
      return false;
    }
  }

  Future<List<TopDeal>> getTopDeals() async {
    final url = Uri.parse('http://65.2.75.93:3000/top-deals');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = response.body;
        debugPrint(responseData);
        List<dynamic> jsonData = json.decode(responseData);
        final topdeals =
            jsonData.map((data) => TopDeal.fromJson(data)).toList();
        return topdeals;
      } else {
        debugPrint('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error: $e');
      return [];
    }
  }

  Future<List<Offer>> getOffers() async {
    final url = Uri.parse('http://65.2.75.93:3000/offers');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = response.body;
        debugPrint(responseData);
        List<dynamic> jsonData = json.decode(responseData);
        final offers = jsonData.map((data) => Offer.fromJson(data)).toList();
        return offers;
      } else {
        debugPrint('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error: $e');
      return [];
    }
  }

  Future<List<Alert>> getAlerts() async {
    String userId = await localStoreGetUserId() ?? "";

    final url = Uri.parse('http://65.2.75.93:3000/alerts/$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = response.body;
        debugPrint(responseData);
        List<dynamic> jsonData = json.decode(responseData);
        final alerts = jsonData.map((data) => Alert.fromJson(data)).toList();
        return alerts;
      } else {
        debugPrint('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error: $e');
      return [];
    }
  }

  Future<void> deleteAlert(id) async {
    final url = Uri.parse('http://65.2.75.93:3000/alerts/$id');

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        final responseData = response.body;
        debugPrint(responseData);
      } else {
        debugPrint('Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
