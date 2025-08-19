import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

class AttedanceController extends GetxController {
  //TODO: Implement AttedanceController
  var isLoading = false.obs;

  Future<void> submitAttendance(bool isPresent) async {
    isLoading.value = true;
    var box = await Hive.openBox('appData');
    var users = box.get('user');

    print("📦 Data user dari Hive: $users");

    if (users == null || users.isEmpty) {
      Get.delete<AttedanceController>();

      isLoading.value = false;
      return;
    }
    if (users is! List) {
      users = [users];
    }

    String apiUrl = dotenv.env['API_URL'] ?? "default_url";

    for (var user in users) {
      final userId = user['id'];
      if (userId == null) continue; // skip kalau id kosong

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
          print(
            ' Absensi berhasil dikirim untuk userId $userId: ${response.body}',
          );
          isAbsen(isPresent);

          Get.snackbar(
            "Absen",
            isPresent
                ? "berhasil absen masuk"
                : "berhasil absen keluar",
            snackPosition: SnackPosition.BOTTOM,
          );

          await box.delete('user'); 
          return; 
        } else {
          Get.snackbar(
            "Error",
            "Gagal mengirim absensi ${response.statusCode} untuk user $userId",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        isAbsen(isPresent );
        print("Error kirim absen untuk user $userId: $e");
      }
    }

    isLoading.value = false;
  }

  void isAbsen(bool isPresent) {
    if (isPresent) {
      if (!Get.isRegistered<AttedanceController>()) {
        Get.put(AttedanceController(), permanent: true);
      }
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
