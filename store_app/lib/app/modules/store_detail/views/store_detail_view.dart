import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app/app/modules/product/views/product_view.dart';
import 'package:store_app/app/modules/promo/views/promo_view.dart';
import 'package:store_app/app/modules/store_detail/controllers/store_detail_controller.dart';

class StoreDetailView extends GetView<StoreDetailController> {
  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text("${args['name']}"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "${args['address']}",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionCard(
                  icon: Icons.inventory_2,
                  label: "Product",
                  color: Colors.orangeAccent,
                  onTap: () {
                    Get.to(
                      () => ProductView(),
                      arguments: {'storeId': args['id']},
                    );
                  },
                ),
                _buildOptionCard(
                  icon: Icons.local_offer,
                  label: "Promo",
                  color: Colors.greenAccent,
                  onTap: () {
                    Get.to(
                      () => PromoView(),
                      arguments: {'storeId': args['id']},
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
