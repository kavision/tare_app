import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tare_app/models/tare_range.dart';
import 'package:tare_app/utils/path_builder.dart';

class TareRangeProvider with ChangeNotifier {
  Future<String?> updateTareRange(String rawTare, String rawRange) async {
    final tareRange = TareRange.fromRaw(rawTare, rawRange);
    final trPath = await getTareRangePath();

    try {
      final file = File(trPath);
      await file.writeAsString(json.encode(tareRange));
      return Future.value('Success');
    } catch (e) {
      log("Provider Exception: ${e.toString()}");
      return null;
    }
  }

  Future<Map<String, double>?> readTareRange() async {
    final trPath = await getTareRangePath();

    try {
      final file = File(trPath);
      final dataAsString = await file.readAsString();
      final dataAsJson = jsonDecode(dataAsString);
      final dataAsMap = TareRange.fromJson(dataAsJson).toJson();
      return Future.value(dataAsMap);
    } catch (e) {
      log("Provider Exception: ${e.toString()}");
      return null;
    }
  }

  // Future<void> refresh() async {
  //   _articles.clear();
  //   notifyListeners();
  //   await fetchArticles(_categoryId, 1);
  // }
}
