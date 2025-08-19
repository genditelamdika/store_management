import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:store_app/app/data/model/product.dart';
import 'package:store_app/app/data/model/promo.dart';
import 'package:store_app/app/data/model/store.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/app/modules/attedance/controllers/attedance_controller.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  var stores = <Store>[].obs;
  var statusServer = true.obs;
  var isConnected = false.obs;

  final controllerAbsen = Get.find<AttedanceController>();

  @override
  void onInit() {
    super.onInit();
    printAppData();
    loadStores();
    Connectivity().onConnectivityChanged.listen((status) {
      if (status != ConnectivityResult.none) {
        isConnected.value = status != ConnectivityResult.none;
        print('Koneksi internet terdeteksi: $isConnected');
        sendPromoReport();
        sendProductReport(false);
        pendingAttendance(true);
      }
    });
  }

  void loadStores() {
    var box = Hive.box('appData');
    final storeList = (box.get('stores', defaultValue: []) as List)
        .map((e) => Store.fromJson(e))
        .toList();
    stores.value = storeList;
  }

  void printAppData() {
    var box = Hive.box('PromoStore');
    print("===== Isi Box appData =====");
    print(box.toMap());
    box.toMap().forEach((key, value) {
      print("Key: $key => Value: $value");
    });
  }

  void logout() async {
    Get.offAllNamed('/login');
    await Hive.deleteFromDisk();

    Get.snackbar(
      "Logout",
      "Berhasil keluar",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> sendPromoReport() async {
    var box = Hive.box('PendingPromoStore');
    final pendingPromos = box.values.toList();
    String apiUrl = dotenv.env['API_URL'] ?? "default_url";

    print("Pending promos: $pendingPromos");

    if (pendingPromos.isEmpty) return;

    final url = Uri.parse('$apiUrl/api/v1/report/promo');

    try {
      // Cek koneksi
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        Get.snackbar('Sukses', 'Tidak ada koneksi internet function');
        return;
      }

      for (var promo in pendingPromos) {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(promo),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          addPromo();

          Get.snackbar(
            "Sukses",
            "Promo berhasil ditambahkan",
            snackPosition: SnackPosition.BOTTOM,
          );
          print("data store siapa: ${promo["store_id"]}");
          print("data product siapa: $promo");
          // Sukses → hapus dari Hive
          box.delete(
            'PromoStore${promo["store_id"]}Product${promo["product_id"]}',
          );
        } else {
          print(
            "Gagal kirim promo ${promo["promo_name"]}: ${response.statusCode}",
          );
        }
      }
    } catch (e) {
      print("Error sendPromoReport: $e");
    }
  }

  Future<void> sendProductReport(bool isWidget) async {
    var box = Hive.box('PendingProductReport');

    if (box.isEmpty) {
      print('Tidak ada data pending di Hive');
      return;
    }
    for (var key in box.keys) {
      final pending = box.get(key);

      if (pending == null) continue;

      try {
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          print('⚠️ Tidak ada koneksi internet, hentikan pengiriman.');
          break;
        }
        String apiUrl = dotenv.env['API_URL'] ?? "default_url";

        final url = Uri.parse('$apiUrl/api/v1/report/product');

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(pending),
        );

        if (response.statusCode == 200) {
          if (isWidget) {
            Get.back();
            Get.back();
          }

          print('Laporan berhasil dikirim untuk $key');
          box.delete(key);
          Get.snackbar(
            'Sukses',
            'Laporan produk berhasil dikirim',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          print('Gagal kirim untuk $key: ${response.statusCode}');
        }
      } catch (e) {
        Get.back();
        Get.back();
        Get.snackbar(
          'Info',
          'Data disimpan, akan dikirim saat online.',
          snackPosition: SnackPosition.BOTTOM,
        );
        print('Error kirim untuk $key: $e');
      }
    }
  }

  Future<void> pendingAttendance(bool isPresent) async {
    var box = await Hive.openBox('appData');
    var users = box.get('user');

    if (users == null || users.isEmpty) {
      return;
    }

    if (users is! List) {
      users = [users];
    }

    String apiUrl = dotenv.env['API_URL'] ?? "default_url";

    for (var user in users) {
      final userId = user['id'];
      if (userId == null) continue; 

      try {
        final url = Uri.parse('$apiUrl/api/v1/report/attendance');
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "user_id": userId,
            "status": isPresent ? "masuk" : "absent",
          }),
        );

        if (response.statusCode == 200) {
          Get.snackbar(
            "Absen",
            isPresent
                ? "User  berhasil absen masuk"
                : "User  berhasil absen keluar",
            snackPosition: SnackPosition.BOTTOM,
          );

          await box.delete('user'); 
          return;
        } else {
          Get.snackbar(
            "Error",
            "Gagal mengirim absensi ${response.statusCode}",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        print("⚠️ Error kirim absen untuk user $userId: $e");
      }
    }
  }

  void addPromo() {
    var pendingBox = Hive.box('PendingPromoStore');
    var promoBox = Hive.box('PromoStore');

    for (var key in pendingBox.keys) {
      final data = pendingBox.get(key);
      if (data != null) {
        final pendingPromo = Promo(
          product: Product(
            id: data['product_id'],
            name: data['promo_name'],
            volume: '',
            barcode: '',
          ),
          normalPrice: data['normal_price'],
          promoPrice: data['promo_price'],
        );

        promoBox.put(
          'PromoStore${data['store_id']}Product${pendingPromo.product.id}',
          pendingPromo.toJson(),
        );
      }
    }

    pendingBox.clear();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
