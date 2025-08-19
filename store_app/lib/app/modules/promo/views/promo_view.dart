import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app/app/data/model/product.dart';
import '../controllers/promo_controller.dart';

class PromoView extends GetView<PromoController> {
  const PromoView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PromoController());

    return Scaffold(
      appBar: AppBar(
        title:  Text("Promo"),
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
      body: Obx(() {
        if (controller.promos.isEmpty) {
          return const Center(
            child: Text(
              "Belum ada promo tersedia",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.promos.length,
          itemBuilder: (context, index) {
            final promo = controller.promos[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blueAccent.withOpacity(0.2),
                  child: Text(
                    promo.product.name[0].toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                title: Text(
                  promo.product.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      "Harga Normal: Rp ${promo.normalPrice.toStringAsFixed(0)}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      "Harga Promo: Rp ${promo.promoPrice.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => null,
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add),
        label: const Text("Tambah Promo"),
        onPressed: () => _showAddPromoDialog(context),
      ),
    );
  }

  void _showAddPromoDialog(BuildContext context) {
    // final normalPriceController = TextEditingController();
    // final promoPriceController = TextEditingController();
    final controller = Get.find<PromoController>();
    // Product? selectedProduct;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Tambah Promo",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 24),

              Obx(() {
                return DropdownButtonFormField<Product>(
                  decoration: InputDecoration(
                    labelText: "Pilih Produk",
                    filled: true,
                    fillColor: Colors.blue[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  value: controller.selectedProduct.value,
                  items: controller.products.map((product) {
                    return DropdownMenuItem<Product>(
                      value: product,
                      child: Text(product.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedProduct.value = value;
                  },
                );
              }),
              const SizedBox(height: 16),

              TextField(
                controller: controller.normalPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Harga Normal",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: controller.promoPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Harga Promo",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.blueAccent,
                    elevation: 5,
                  ),
                  onPressed: () {
                    // ignore: unnecessary_null_comparison
                    if (controller.selectedProduct != null &&
                        controller.normalPriceController.text.isNotEmpty &&
                       controller. promoPriceController.text.isNotEmpty) {
                          controller.pendingPromoReport();
                          Get.back();

                    }
                  },
                  child: const Text(
                    "Simpan",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
