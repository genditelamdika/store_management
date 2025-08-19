import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/app/data/model/product.dart';
import 'package:store_app/app/data/model/store.dart';
import 'dart:convert';

import 'package:store_app/app/utils/hive.dart';

class LoginController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void parseLoginData(Map<String, dynamic>? data) async {
    print('Raw data: $data');
    DataHive();

    await Hive.openBox('appData');
    await Hive.openBox('PromoStore');

    if (data == null) {
      Get.snackbar('Error', 'Data login kosong');
      return;
    }

    final token = (data['token'] ?? '') as String;
    print('Token: $token');

    // User
    final userData = data['user'] as Map<String, dynamic>?;

    List<Store> stores = [];
    if (data['stores'] != null && data['stores'] is List) {
      print('Stores raw: ${data['stores']}');
      stores = (data['stores'] as List)
          .where((e) => e != null)
          .map((e) => Store.fromJson(e))
          .toList();
    }
    print('Parsed stores: ${stores.length}');

    List<Product> products = [];
    if (data['products'] != null && data['products'] is List) {
      print('Products raw: ${data['products']}');
      products = (data['products'] as List)
          .where((e) => e != null)
          .map((e) => Product.fromJson(e))
          .toList();
    }
    print('Parsed products: ${products.length}');

    saveLoginDataToHive(token, userData, stores, products);
  }

  void saveLoginDataToHive(
    String token,
    Map<String, dynamic>? userData,
    List<Store> stores,
    List<Product> products,
  ) {
    var box = Hive.box('appData');
    box.put('token', token);
    box.put('user', userData);
    box.put('stores', stores.map((s) => s.toJson()).toList());
    box.put('products', products.map((p) => p.toJson()).toList());
  }

  void login() async {
    final username = emailController.text;
    final password = passwordController.text;
    String apiUrl = dotenv.env['API_URL'] ?? "default_url";

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email dan password wajib diisi');
      return;
    }

    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse('$apiUrl/api/v1/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'fullname': username, 'password': password}),
      );
      isLoading.value = false;

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("object: $data");
        parseLoginData(data['data']);
        Get.snackbar('Success', "Login berhasil");
        Get.offAllNamed('/attedance');
      } else {
        Get.snackbar('Error', "${response.statusCode}");
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Tidak bisa terhubung ke server: $e');
      print('Error during login: $e');
    }
  }
}
