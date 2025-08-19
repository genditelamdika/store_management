import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:store_app/app/data/model/product.dart';
import 'package:hive/hive.dart';
import 'package:store_app/app/data/model/promo.dart';
import 'package:http/http.dart' as http;

class PromoController extends GetxController {
  var promos = <Promo>[].obs;
  var products = <Product>[].obs;
  var selectedProduct = Rxn<Product>();
  final normalPriceController = TextEditingController();
  final promoPriceController = TextEditingController();

  late Map<String, dynamic> args;
  late Box promoBox;

  @override
  void onInit() {
    super.onInit();
    args = Get.arguments as Map<String, dynamic>;

    loadProductsFromHive();
    promoBox = Hive.box('PromoStore');
    loadPromosFromHive(args['storeId']);

    promoBox.listenable().addListener(() {
      loadPromosFromHive(args['storeId']);
    });
  }

  void loadProductsFromHive() {
    var box = Hive.box('appData');
    final storedProducts = box.get('products', defaultValue: []);
    if (storedProducts is List) {
      products.value = storedProducts
          .where((e) => e != null)
          .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
  }

  Future<void> sendPromoReport() async {
    var box = Hive.box('PendingPromoStore');
    final pendingPromos = box.values.toList();
    String apiUrl = dotenv.env['API_URL'] ?? "default_url";

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
      Get.snackbar("Info", "Promo disimpan di Hive, akan dikirim saat online");
      print("Error sendPromoReport: $e");
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

        final index = promos.indexWhere(
          (p) => p.product.id == pendingPromo.product.id,
        );
        if (index != -1) {
          promos[index].normalPrice = pendingPromo.normalPrice;
          promos[index].promoPrice = pendingPromo.promoPrice;
        } else {
          promos.add(pendingPromo);
        }

        promoBox.put(
          'PromoStore${data['store_id']}Product${pendingPromo.product.id}',
          pendingPromo.toJson(),
        );
      }
    }

    pendingBox.clear();
    promos.refresh();
  }

  void pendingPromoReport() {
    if (selectedProduct.value == null ||
        normalPriceController.text.isEmpty ||
        promoPriceController.text.isEmpty)
      return;

    final newPromo = {
      "store_id": args['storeId'],
      "product_id": selectedProduct.value!.id,
      "promo_name": selectedProduct.value!.name,
      "normal_price": double.parse(normalPriceController.text),
      "promo_price": double.parse(promoPriceController.text),
    };

    var box = Hive.box('PendingPromoStore');

    box.put(
      'PromoStore${args['storeId']}Product${selectedProduct.value!.id}',
      newPromo,
    );
    print("==== PendingPromoStore ====");
    for (var key in box.keys) {
      print("$key: ${box.get(key)}");
    }
    print("==========================");
    sendPromoReport();
  }


  void loadPromosFromHive(int storeId) {
    print("jalankan ga load");
    var box = Hive.box('PromoStore');

    final prefix = 'PromoStore$storeId';
    final keys = box.keys.where((k) => k.toString().startsWith(prefix));

    List<Promo> loadedPromos = [];

    for (var key in keys) {
      final data = box.get(key);
      if (data != null && data is Map) {
        try {
          loadedPromos.add(Promo.fromJson(Map<String, dynamic>.from(data)));
        } catch (e) {
          print('Error parsing promo from Hive key $key: $e');
        }
      }
    }

    promos.assignAll(loadedPromos);
    promos.refresh();
  }

  @override
  void onClose() {
    super.onClose();
    Get.delete<PromoController>(force: true);
  }

  void onDispose() {
    normalPriceController.dispose();
    promoPriceController.dispose();
    Get.delete<PromoController>(force: true);

    super.dispose();
  }
}
