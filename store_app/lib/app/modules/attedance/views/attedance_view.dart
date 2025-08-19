import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app/app/modules/attedance/controllers/attedance_controller.dart';

class AttedanceView extends GetView<AttedanceController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time, size: 100, color: Colors.white),
                SizedBox(height: 30),
                Text(
                  "Absensi Hari Ini",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  "Silakan pilih status kehadiran Anda",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      ElevatedButton( 
                        onPressed: controller.isLoading.value ? null : () => controller.submitAttendance(true),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 60),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text("Masuk Kerja", style: TextStyle(fontSize: 20)),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: controller.isLoading.value ? null : () => controller.submitAttendance(false),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 60),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text("Absen / Tidak Masuk", style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          if (controller.isLoading.value)
            Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
        ],
      )),
    );
  }
}
