import 'dart:convert';

import 'package:demo_project/models/allotment.dart';
import 'package:demo_project/models/auth.dart';
import 'package:demo_project/models/mortality.dart';
import 'package:demo_project/models/water.dart';
import 'package:demo_project/models/weight.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage storage;

  SecureStorageService({required this.storage});

  Future<void> setItem(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> getItem(String key) async {
    return await storage.read(key: key);
  }

  Future<void> deleteItem(String key) async {
    await storage.delete(key: key);
  }

  Future<Auth?> getAuth() async {
    String? storedData = await getItem("Auth");

    if (storedData != null) {
      Map<String, dynamic> json = jsonDecode(storedData);
      return Auth.fromJson(json);
    }
  
    return null;
  }

  Future<Allotment?> getAllotment(String allotmentId) async {
    String? storedData = await getItem(allotmentId);

    if (storedData != null) {
      Map<String, dynamic> json = jsonDecode(storedData);
      return Allotment.fromJson(json);
    }
    return null;
  }

  Future<void> setMortality(Mortality value, double newDeathPercentage) async {
    String? storedData = await getItem(value.allotmentId);

    if (storedData != null) {
      await deleteItem(value.allotmentId);
      Map<String, dynamic> json = jsonDecode(storedData);
      Allotment allotment = Allotment.fromJson(json);

      allotment.currentDeathPercentage = newDeathPercentage;
      allotment.mortalityHistory.add(value);

      await setItem(value.allotmentId, jsonEncode(allotment));
    }
  }

  Future<void> setWater(Water value, int newTotalConsume) async {
    String? storedData = await getItem(value.allotmentId);

    if (storedData != null) {
      await deleteItem(value.allotmentId);
      Map<String, dynamic> json = jsonDecode(storedData);
      Allotment allotment = Allotment.fromJson(json);

      allotment.currentTotalWaterConsume = newTotalConsume;
      allotment.waterHistory.add(value);

      await setItem(value.allotmentId, jsonEncode(allotment));
    }
  }

  Future<void> setWeight(Weight value, double latestWeight) async {
    String? storedData = await getItem(value.allotmentId);

    if (storedData != null) {
      await deleteItem(value.allotmentId);
      Map<String, dynamic> json = jsonDecode(storedData);
      Allotment allotment = Allotment.fromJson(json);

      allotment.currentWeight = latestWeight;
      allotment.weightHistory.add(value);

      await setItem(value.allotmentId, jsonEncode(allotment));
    }
  }
}